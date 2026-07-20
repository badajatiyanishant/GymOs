import 'dart:async';
import 'dart:convert';

import '../../../core/constants/enums.dart';
import '../../../core/services/local_storage_service.dart';
import '../domain/app_user.dart';
import 'auth_repository.dart';

/// Offline/demo [AuthRepository] used only while Firebase is not configured
/// (placeholder `firebase_options.dart`). It keeps the app fully navigable on
/// a fresh checkout: any credentials created via the signup form are stored
/// locally and can sign in again. Nothing is pre-seeded — no hardcoded users.
class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this._store);

  final LocalStorageService _store;
  final _controller = StreamController<AppUser?>.broadcast();

  static const _kUser = 'local_auth.user';
  static const _kPassword = 'local_auth.password';
  static const _kSession = 'local_auth.signed_in';

  AppUser? _readStored() {
    final raw = _store.getString(_kUser);
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return AppUser.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeStored(AppUser user) =>
      _store.setString(_kUser, jsonEncode(user.toJson()));

  @override
  Stream<AppUser?> authState() async* {
    yield _store.getBool(_kSession) ? _readStored() : null;
    yield* _controller.stream;
  }

  @override
  Future<AppUser?> currentUser() async =>
      _store.getBool(_kSession) ? _readStored() : null;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    final stored = _readStored();
    final storedPassword = _store.getString(_kPassword);
    if (stored == null ||
        stored.email.toLowerCase() != email.trim().toLowerCase() ||
        storedPassword != password) {
      throw const AuthException(
        'No matching local account. Create one via Sign Up (Firebase is not '
        'configured on this build).',
      );
    }
    await _store.setBool(_kSession, true);
    _controller.add(stored);
    return stored;
  }

  @override
  Future<AppUser> signUpOwner({
    required String fullName,
    required String gymName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final user = AppUser(
      uid: 'local-${email.trim().toLowerCase().hashCode}',
      email: email.trim(),
      displayName: fullName.trim(),
      phone: phone.trim(),
      gymId: 'local-gym',
      role: UserRole.owner,
    );
    await _writeStored(user);
    await _store.setString(_kPassword, password);
    await _store.setBool(_kSession, true);
    _controller.add(user);
    return user;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    // Nothing to send locally; succeed so the UI can show its sent state.
  }

  @override
  Future<void> signOut() async {
    await _store.setBool(_kSession, false);
    _controller.add(null);
  }
}
