import '../domain/gym_entities.dart';
import '../domain/member.dart';

/// Generic contract every gym-scoped collection repository exposes.
///
/// `load / save / delete / watch` per the backend plan, plus [loadPage] so
/// large collections (members, attendance, payments) can paginate instead of
/// reading everything.
abstract class EntityRepository<T> {
  /// Loads all documents (small collections) — prefer [loadPage] for big ones.
  Future<List<T>> load();

  /// Loads one page ordered by the repository's default sort. [startAfterId]
  /// is the id of the last item of the previous page (null = first page).
  Future<List<T>> loadPage({int limit = 25, String? startAfterId});

  /// Creates or updates (upsert by id).
  Future<void> save(T item);

  /// Batch upsert — one round trip for imports/bulk edits.
  Future<void> saveAll(List<T> items);

  Future<void> delete(String id);

  /// Live stream of the collection (capped to the newest [limit] docs).
  Stream<List<T>> watch({int limit = 100});
}

/// Marker interfaces so providers stay strongly typed and swappable.
abstract class MemberRepository implements EntityRepository<Member> {}

abstract class TrainerRepository implements EntityRepository<Trainer> {}

abstract class AttendanceRepository
    implements EntityRepository<AttendanceRecord> {}

abstract class WorkoutRepository implements EntityRepository<WorkoutPlan> {}

abstract class DietRepository implements EntityRepository<DietPlan> {}

abstract class PaymentRepository implements EntityRepository<PaymentRecord> {}

abstract class NotificationRepository
    implements EntityRepository<GymNotification> {}
