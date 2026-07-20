import '../domain/gym_settings.dart';

/// Abstraction over persistence of the [GymSettings] aggregate. The UI and
/// providers depend only on this interface — never on a concrete backend — so
/// switching from local storage to Firestore is a single provider change.
///
/// Firestore path intent: `gyms/{gymId}/settings/`.
abstract class SettingsRepository {
  /// Loads the current settings. Implementations return seed defaults when
  /// nothing has been persisted yet, so callers always get a usable value.
  Future<GymSettings> load();

  /// Persists the full settings aggregate.
  Future<void> save(GymSettings settings);

  /// Emits the current settings and every subsequent change. Local
  /// implementations may emit only on save; remote ones stream live updates.
  Stream<GymSettings> watch();
}
