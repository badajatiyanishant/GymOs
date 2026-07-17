import 'package:shared_preferences/shared_preferences.dart';

/// Thin singleton wrapper over [SharedPreferences] for simple key/value needs
/// (theme mode, onboarding flags, cached role). Larger data belongs in
/// Firestore or a proper cache — this is deliberately minimal.
class LocalStorageService {
  LocalStorageService._();
  static final LocalStorageService instance = LocalStorageService._();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _p {
    final p = _prefs;
    if (p == null) {
      throw StateError('LocalStorageService.init() was not called');
    }
    return p;
  }

  String? getString(String key) => _p.getString(key);
  Future<void> setString(String key, String value) => _p.setString(key, value);

  bool getBool(String key, {bool defaultValue = false}) =>
      _p.getBool(key) ?? defaultValue;
  Future<void> setBool(String key, bool value) => _p.setBool(key, value);

  Future<void> remove(String key) => _p.remove(key);
  Future<void> clear() => _p.clear();
}
