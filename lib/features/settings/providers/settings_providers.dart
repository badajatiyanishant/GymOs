import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/local_storage_service.dart';
import '../data/local_settings_repository.dart';
import '../data/local_storage_repository.dart';
import '../data/settings_repository.dart';
import '../data/storage_repository.dart';
import '../domain/appearance_settings.dart';
import '../domain/business_settings.dart';
import '../domain/gym_info.dart';
import '../domain/gym_settings.dart';
import '../domain/membership_settings.dart';
import '../domain/notification_settings.dart';
import '../domain/payment_settings.dart';
import '../domain/security_settings.dart';
import '../domain/staff_settings.dart';

/// THE SINGLE SWAP POINT. To move the whole app onto Firebase, change only the
/// two providers below to return the Firestore/Firebase implementations — no
/// UI, controller, or model code changes.
///
///   settingsRepositoryProvider → FirestoreSettingsRepository(gymId: ...)
///   storageRepositoryProvider  → const FirebaseStorageRepository()
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return LocalSettingsRepository(LocalStorageService.instance);
});

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return const LocalStorageRepository();
});

/// Reactive holder for the full [GymSettings] aggregate. Starts at seed defaults
/// so the UI is never empty, then hydrates from the repository. Every mutation
/// updates state immediately (optimistic) and persists through the repository.
class SettingsController extends StateNotifier<GymSettings> {
  SettingsController(this._repo) : super(GymSettings.seed()) {
    _hydrate();
  }

  final SettingsRepository _repo;

  Future<void> _hydrate() async {
    state = await _repo.load();
  }

  Future<void> _commit(GymSettings next) async {
    state = next;
    await _repo.save(next);
  }

  Future<void> replaceAll(GymSettings settings) => _commit(settings);

  Future<void> updateInfo(GymInfoSettings info) =>
      _commit(state.copyWith(info: info));

  Future<void> updateBusiness(BusinessSettings business) =>
      _commit(state.copyWith(business: business));

  Future<void> updateAppearance(AppearanceSettings appearance) =>
      _commit(state.copyWith(appearance: appearance));

  Future<void> updateMembership(MembershipSettings membership) =>
      _commit(state.copyWith(membership: membership));

  Future<void> updatePayment(PaymentSettings payment) =>
      _commit(state.copyWith(payment: payment));

  Future<void> updateNotification(NotificationSettings notification) =>
      _commit(state.copyWith(notification: notification));

  Future<void> updateStaff(StaffSettings staff) =>
      _commit(state.copyWith(staff: staff));

  Future<void> updateSecurity(SecuritySettings security) =>
      _commit(state.copyWith(security: security));

  /// Bumps the session epoch — used by "log out from all devices".
  Future<void> logoutAllDevices() => updateSecurity(
        state.security.copyWith(sessionEpoch: state.security.sessionEpoch + 1),
      );
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, GymSettings>((ref) {
  return SettingsController(ref.watch(settingsRepositoryProvider));
});

/// Convenience selectors so widgets rebuild only on the slice they use.
final gymInfoProvider = Provider<GymInfoSettings>(
  (ref) => ref.watch(settingsControllerProvider).info,
);

final appearanceProvider = Provider<AppearanceSettings>(
  (ref) => ref.watch(settingsControllerProvider).appearance,
);

/// The owner-selected theme mode, sourced from branding settings.
final settingsThemeModeProvider = Provider<ThemeMode>(
  (ref) => ref.watch(appearanceProvider).themeChoice.themeMode,
);
