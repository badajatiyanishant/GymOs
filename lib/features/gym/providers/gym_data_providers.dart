import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/firebase_bootstrap.dart';
import '../../auth/providers/auth_providers.dart';
import '../data/entity_repository.dart';
import '../data/firestore_entity_repository.dart';
import '../data/local_entity_repository.dart';
import '../domain/gym_entities.dart';
import '../domain/member.dart';

/// SWAP POINT for every gym data collection. Each provider picks the
/// Firestore implementation when Firebase is active (scoped to the signed-in
/// user's gymId) and the local implementation otherwise. The UI only ever
/// sees the abstract repository types.
final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  if (FirebaseBootstrap.isActive) {
    return FirestoreMemberRepository(gymId: ref.watch(gymIdProvider));
  }
  return LocalMemberRepository();
});

final trainerRepositoryProvider = Provider<TrainerRepository>((ref) {
  if (FirebaseBootstrap.isActive) {
    return FirestoreTrainerRepository(gymId: ref.watch(gymIdProvider));
  }
  return LocalTrainerRepository();
});

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  if (FirebaseBootstrap.isActive) {
    return FirestoreAttendanceRepository(gymId: ref.watch(gymIdProvider));
  }
  return LocalAttendanceRepository();
});

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  if (FirebaseBootstrap.isActive) {
    return FirestoreWorkoutRepository(gymId: ref.watch(gymIdProvider));
  }
  return LocalWorkoutRepository();
});

final dietRepositoryProvider = Provider<DietRepository>((ref) {
  if (FirebaseBootstrap.isActive) {
    return FirestoreDietRepository(gymId: ref.watch(gymIdProvider));
  }
  return LocalDietRepository();
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  if (FirebaseBootstrap.isActive) {
    return FirestorePaymentRepository(gymId: ref.watch(gymIdProvider));
  }
  return LocalPaymentRepository();
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  if (FirebaseBootstrap.isActive) {
    return FirestoreNotificationRepository(gymId: ref.watch(gymIdProvider));
  }
  return LocalNotificationRepository();
});

// ---- Realtime streams (Phase 7) --------------------------------------------
// Live collection streams the dashboard/members/reports watch. With Firestore
// these are true realtime listeners; locally they emit on every save. Either
// way the UI updates with no manual refresh.

final membersStreamProvider = StreamProvider<List<Member>>((ref) {
  return ref.watch(memberRepositoryProvider).watch(limit: 500);
});

final attendanceStreamProvider =
    StreamProvider<List<AttendanceRecord>>((ref) {
  return ref.watch(attendanceRepositoryProvider).watch(limit: 300);
});

final paymentsStreamProvider = StreamProvider<List<PaymentRecord>>((ref) {
  return ref.watch(paymentRepositoryProvider).watch(limit: 200);
});

final notificationsStreamProvider =
    StreamProvider<List<GymNotification>>((ref) {
  return ref.watch(notificationRepositoryProvider).watch(limit: 100);
});

// ---- Derived live KPIs ------------------------------------------------------
// Small selectors the dashboard reads so its stat cards go realtime without
// the screen knowing about repositories.

final activeMemberCountProvider = Provider<int?>((ref) {
  final members = ref.watch(membersStreamProvider).valueOrNull;
  if (members == null) return null;
  return members.where((m) => m.status.name != 'expired').length;
});

final todayAttendanceCountProvider = Provider<int?>((ref) {
  final records = ref.watch(attendanceStreamProvider).valueOrNull;
  if (records == null) return null;
  final now = DateTime.now();
  return records
      .where((a) =>
          a.checkInAt.year == now.year &&
          a.checkInAt.month == now.month &&
          a.checkInAt.day == now.day)
      .length;
});

final todayRevenueProvider = Provider<int?>((ref) {
  final payments = ref.watch(paymentsStreamProvider).valueOrNull;
  if (payments == null) return null;
  final now = DateTime.now();
  return payments
      .where((p) =>
          p.paidAt.year == now.year &&
          p.paidAt.month == now.month &&
          p.paidAt.day == now.day)
      .fold<int>(0, (sum, p) => sum + p.amount);
});

final pendingRenewalCountProvider = Provider<int?>((ref) {
  final members = ref.watch(membersStreamProvider).valueOrNull;
  if (members == null) return null;
  return members.where((m) => m.daysToExpiry <= 7).length;
});
