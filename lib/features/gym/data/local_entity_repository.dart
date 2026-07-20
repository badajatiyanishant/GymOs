import 'dart:async';
import 'dart:convert';

import '../../../core/services/local_storage_service.dart';
import '../domain/gym_entities.dart';
import '../domain/member.dart';
import 'entity_repository.dart';

/// Local JSON-list implementation of [EntityRepository], keyed per collection
/// in SharedPreferences. Behaviourally equivalent to the Firestore version
/// (same interface, same ordering semantics) so the provider swap is invisible
/// to the UI. Used while Firebase is not configured.
class LocalEntityRepository<T> implements EntityRepository<T> {
  LocalEntityRepository({
    required this.collection,
    required this.fromJson,
    required this.toJson,
    required this.idOf,
    required this.sortKey,
    this.descending = false,
    LocalStorageService? store,
  }) : _store = store ?? LocalStorageService.instance;

  final String collection;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final String Function(T) idOf;

  /// Extracts the comparable used for ordering (mirrors Firestore orderBy).
  final Comparable<Object?> Function(T) sortKey;
  final bool descending;
  final LocalStorageService _store;

  final _controller = StreamController<List<T>>.broadcast();

  String get _key => 'gym.$collection';

  List<T> _read() {
    final raw = _store.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      final items = list
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();
      items.sort(_compare);
      return items;
    } catch (_) {
      return [];
    }
  }

  int _compare(T a, T b) {
    final result = sortKey(a).compareTo(sortKey(b));
    return descending ? -result : result;
  }

  Future<void> _write(List<T> items) async {
    items.sort(_compare);
    await _store.setString(_key, jsonEncode(items.map(toJson).toList()));
    _controller.add(items);
  }

  @override
  Future<List<T>> load() async => _read();

  @override
  Future<List<T>> loadPage({int limit = 25, String? startAfterId}) async {
    final items = _read();
    var start = 0;
    if (startAfterId != null) {
      final idx = items.indexWhere((e) => idOf(e) == startAfterId);
      if (idx >= 0) start = idx + 1;
    }
    return items.skip(start).take(limit).toList();
  }

  @override
  Future<void> save(T item) async {
    final items = _read();
    final idx = items.indexWhere((e) => idOf(e) == idOf(item));
    if (idx >= 0) {
      items[idx] = item;
    } else {
      items.add(item);
    }
    await _write(items);
  }

  @override
  Future<void> saveAll(List<T> newItems) async {
    final items = _read();
    for (final item in newItems) {
      final idx = items.indexWhere((e) => idOf(e) == idOf(item));
      if (idx >= 0) {
        items[idx] = item;
      } else {
        items.add(item);
      }
    }
    await _write(items);
  }

  @override
  Future<void> delete(String id) async {
    final items = _read()..removeWhere((e) => idOf(e) == id);
    await _write(items);
  }

  @override
  Stream<List<T>> watch({int limit = 100}) async* {
    yield _read().take(limit).toList();
    yield* _controller.stream.map((items) => items.take(limit).toList());
  }
}

// ---- Concrete local repositories -------------------------------------------

class LocalMemberRepository extends LocalEntityRepository<Member>
    implements MemberRepository {
  LocalMemberRepository({super.store})
      : super(
          collection: 'members',
          fromJson: Member.fromJson,
          toJson: (m) => m.toJson(),
          idOf: (m) => m.id,
          sortKey: (m) => m.name.toLowerCase(),
        );
}

class LocalTrainerRepository extends LocalEntityRepository<Trainer>
    implements TrainerRepository {
  LocalTrainerRepository({super.store})
      : super(
          collection: 'trainers',
          fromJson: Trainer.fromJson,
          toJson: (t) => t.toJson(),
          idOf: (t) => t.id,
          sortKey: (t) => t.name.toLowerCase(),
        );
}

class LocalAttendanceRepository extends LocalEntityRepository<AttendanceRecord>
    implements AttendanceRepository {
  LocalAttendanceRepository({super.store})
      : super(
          collection: 'attendance',
          fromJson: AttendanceRecord.fromJson,
          toJson: (a) => a.toJson(),
          idOf: (a) => a.id,
          sortKey: (a) => a.checkInAt.toIso8601String(),
          descending: true,
        );
}

class LocalWorkoutRepository extends LocalEntityRepository<WorkoutPlan>
    implements WorkoutRepository {
  LocalWorkoutRepository({super.store})
      : super(
          collection: 'workout_plans',
          fromJson: WorkoutPlan.fromJson,
          toJson: (w) => w.toJson(),
          idOf: (w) => w.id,
          sortKey: (w) => w.name.toLowerCase(),
        );
}

class LocalDietRepository extends LocalEntityRepository<DietPlan>
    implements DietRepository {
  LocalDietRepository({super.store})
      : super(
          collection: 'diet_plans',
          fromJson: DietPlan.fromJson,
          toJson: (d) => d.toJson(),
          idOf: (d) => d.id,
          sortKey: (d) => d.name.toLowerCase(),
        );
}

class LocalPaymentRepository extends LocalEntityRepository<PaymentRecord>
    implements PaymentRepository {
  LocalPaymentRepository({super.store})
      : super(
          collection: 'payments',
          fromJson: PaymentRecord.fromJson,
          toJson: (p) => p.toJson(),
          idOf: (p) => p.id,
          sortKey: (p) => p.paidAt.toIso8601String(),
          descending: true,
        );
}

class LocalNotificationRepository
    extends LocalEntityRepository<GymNotification>
    implements NotificationRepository {
  LocalNotificationRepository({super.store})
      : super(
          collection: 'notifications',
          fromJson: GymNotification.fromJson,
          toJson: (n) => n.toJson(),
          idOf: (n) => n.id,
          sortKey: (n) => n.createdAt.toIso8601String(),
          descending: true,
        );
}
