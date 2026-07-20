import 'dart:async';
import 'dart:convert';

import '../../../core/services/local_storage_service.dart';
import '../domain/gym_settings.dart';
import 'settings_repository.dart';

/// SharedPreferences-backed implementation. The whole [GymSettings] aggregate
/// is serialised to a single JSON string under one key — cheap, synchronous to
/// read, and mirrors the shape a Firestore document would take, so migration is
/// trivial.
class LocalSettingsRepository implements SettingsRepository {
  LocalSettingsRepository(this._storage);

  final LocalStorageService _storage;

  static const String _key = 'gym_settings_v1';

  final StreamController<GymSettings> _controller =
      StreamController<GymSettings>.broadcast();

  @override
  Future<GymSettings> load() async {
    final raw = _storage.getString(_key);
    if (raw == null || raw.isEmpty) {
      return GymSettings.seed();
    }
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return GymSettings.fromJson(decoded);
    } catch (_) {
      // Corrupt or incompatible payload — fall back to a usable default.
      return GymSettings.seed();
    }
  }

  @override
  Future<void> save(GymSettings settings) async {
    await _storage.setString(_key, jsonEncode(settings.toJson()));
    _controller.add(settings);
  }

  @override
  Stream<GymSettings> watch() async* {
    yield await load();
    yield* _controller.stream;
  }
}
