import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/gym_entities.dart';
import '../domain/member.dart';
import 'entity_repository.dart';

/// Generic Firestore repository over `gyms/{gymId}/{collection}`.
///
/// Uses typed converters ([withConverter]) so documents (de)serialize through
/// the domain models exactly once, `saveAll` batches writes, and both
/// [loadPage] and [watch] are ordered + limited to avoid unnecessary reads.
class FirestoreEntityRepository<T> implements EntityRepository<T> {
  FirestoreEntityRepository({
    required this.gymId,
    required this.collection,
    required this.fromJson,
    required this.toJson,
    required this.idOf,
    this.orderByField = 'id',
    this.descending = false,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String gymId;
  final String collection;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final String Function(T) idOf;
  final String orderByField;
  final bool descending;
  final FirebaseFirestore _firestore;

  CollectionReference<T> get _col => _firestore
      .collection('gyms')
      .doc(gymId)
      .collection(collection)
      .withConverter<T>(
        fromFirestore: (snap, _) =>
            fromJson({...?snap.data(), 'id': snap.id}),
        toFirestore: (item, _) => toJson(item),
      );

  Query<T> get _ordered =>
      _col.orderBy(orderByField, descending: descending);

  @override
  Future<List<T>> load() async {
    final snap = await _ordered.get();
    return snap.docs.map((d) => d.data()).toList();
  }

  @override
  Future<List<T>> loadPage({int limit = 25, String? startAfterId}) async {
    Query<T> q = _ordered.limit(limit);
    if (startAfterId != null) {
      final cursor = await _col.doc(startAfterId).get();
      if (cursor.exists) q = q.startAfterDocument(cursor);
    }
    final snap = await q.get();
    return snap.docs.map((d) => d.data()).toList();
  }

  @override
  Future<void> save(T item) => _col.doc(idOf(item)).set(item);

  @override
  Future<void> saveAll(List<T> items) async {
    // Firestore batches cap at 500 operations.
    for (var i = 0; i < items.length; i += 450) {
      final batch = _firestore.batch();
      for (final item in items.skip(i).take(450)) {
        batch.set(
          _firestore
              .collection('gyms')
              .doc(gymId)
              .collection(collection)
              .doc(idOf(item)),
          toJson(item),
        );
      }
      await batch.commit();
    }
  }

  @override
  Future<void> delete(String id) => _col.doc(id).delete();

  @override
  Stream<List<T>> watch({int limit = 100}) {
    return _ordered
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }
}

// ---- Concrete typed repositories -------------------------------------------
// Each pins the collection name (matching the Firestore structure + rules) and
// a sensible default sort.

class FirestoreMemberRepository extends FirestoreEntityRepository<Member>
    implements MemberRepository {
  FirestoreMemberRepository({required super.gymId, super.firestore})
      : super(
          collection: 'members',
          fromJson: Member.fromJson,
          toJson: (m) => m.toJson(),
          idOf: (m) => m.id,
          orderByField: 'name',
        );
}

class FirestoreTrainerRepository extends FirestoreEntityRepository<Trainer>
    implements TrainerRepository {
  FirestoreTrainerRepository({required super.gymId, super.firestore})
      : super(
          collection: 'trainers',
          fromJson: Trainer.fromJson,
          toJson: (t) => t.toJson(),
          idOf: (t) => t.id,
          orderByField: 'name',
        );
}

class FirestoreAttendanceRepository
    extends FirestoreEntityRepository<AttendanceRecord>
    implements AttendanceRepository {
  FirestoreAttendanceRepository({required super.gymId, super.firestore})
      : super(
          collection: 'attendance',
          fromJson: AttendanceRecord.fromJson,
          toJson: (a) => a.toJson(),
          idOf: (a) => a.id,
          orderByField: 'checkInAt',
          descending: true,
        );
}

class FirestoreWorkoutRepository extends FirestoreEntityRepository<WorkoutPlan>
    implements WorkoutRepository {
  FirestoreWorkoutRepository({required super.gymId, super.firestore})
      : super(
          collection: 'workout_plans',
          fromJson: WorkoutPlan.fromJson,
          toJson: (w) => w.toJson(),
          idOf: (w) => w.id,
          orderByField: 'name',
        );
}

class FirestoreDietRepository extends FirestoreEntityRepository<DietPlan>
    implements DietRepository {
  FirestoreDietRepository({required super.gymId, super.firestore})
      : super(
          collection: 'diet_plans',
          fromJson: DietPlan.fromJson,
          toJson: (d) => d.toJson(),
          idOf: (d) => d.id,
          orderByField: 'name',
        );
}

class FirestorePaymentRepository
    extends FirestoreEntityRepository<PaymentRecord>
    implements PaymentRepository {
  FirestorePaymentRepository({required super.gymId, super.firestore})
      : super(
          collection: 'payments',
          fromJson: PaymentRecord.fromJson,
          toJson: (p) => p.toJson(),
          idOf: (p) => p.id,
          orderByField: 'paidAt',
          descending: true,
        );
}

class FirestoreNotificationRepository
    extends FirestoreEntityRepository<GymNotification>
    implements NotificationRepository {
  FirestoreNotificationRepository({required super.gymId, super.firestore})
      : super(
          collection: 'notifications',
          fromJson: GymNotification.fromJson,
          toJson: (n) => n.toJson(),
          idOf: (n) => n.id,
          orderByField: 'createdAt',
          descending: true,
        );
}
