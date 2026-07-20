import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/firebase_bootstrap.dart';
import '../../../core/services/local_storage_service.dart';
import '../data/auth_repository.dart';
import '../data/firebase_auth_repository.dart';
import '../data/local_auth_repository.dart';
import '../domain/app_user.dart';

/// SWAP POINT for authentication. When Firebase is configured the app uses
/// [FirebaseAuthRepository]; otherwise it degrades to [LocalAuthRepository]
/// so the project still runs on a fresh checkout with no cloud project.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (FirebaseBootstrap.isActive) return FirebaseAuthRepository();
  return LocalAuthRepository(LocalStorageService.instance);
});

/// Reactive auth state — null while signed out. This stream is what makes
/// auto-login work: on app start Firebase restores the session and the
/// router redirects straight to the role's home.
final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authState();
});

/// The signed-in user, or null. Prefer this in widgets.
final currentUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

/// The signed-in user's gymId — the tenant key every repository scopes to.
/// Empty string while signed out (repositories are only used post-login).
final gymIdProvider = Provider<String>((ref) {
  return ref.watch(currentUserProvider)?.gymId ?? '';
});

/// UI-facing auth actions with loading/error handling left to callers.
class AuthController {
  AuthController(this._repo);

  final AuthRepository _repo;

  Future<AppUser> signIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) =>
      _repo.signIn(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

  Future<AppUser?> signInWithGoogle() => _repo.signInWithGoogle();

  Future<AppUser> signUpOwner({
    required String fullName,
    required String gymName,
    required String email,
    required String phone,
    required String password,
  }) =>
      _repo.signUpOwner(
        fullName: fullName,
        gymName: gymName,
        email: email,
        phone: phone,
        password: password,
      );

  Future<void> sendPasswordReset(String email) =>
      _repo.sendPasswordReset(email);

  Future<void> signOut() => _repo.signOut();
}

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});
