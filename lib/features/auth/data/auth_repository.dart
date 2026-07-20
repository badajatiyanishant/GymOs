import '../domain/app_user.dart';

/// Thrown by [AuthRepository] methods with a message safe to show in a snack.
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

/// Abstraction over authentication + the `users/{uid}` profile document.
///
/// The UI depends only on this interface. [FirebaseAuthRepository] is the
/// production implementation; a fake can be injected in tests.
abstract class AuthRepository {
  /// Emits the current [AppUser] (profile + role) or null when signed out.
  /// This is the auto-login source of truth: an authenticated Firebase
  /// session emits immediately on app start.
  Stream<AppUser?> authState();

  /// The currently signed-in user's profile, or null.
  Future<AppUser?> currentUser();

  /// Email/password sign-in. [rememberMe] controls session persistence on
  /// web (LOCAL vs SESSION); mobile sessions always persist.
  Future<AppUser> signIn({
    required String email,
    required String password,
    bool rememberMe = true,
  });

  /// Registers a gym owner: creates the auth user, a new gym document and the
  /// `users/{uid}` profile with role=owner in one flow.
  Future<AppUser> signUpOwner({
    required String fullName,
    required String gymName,
    required String email,
    required String phone,
    required String password,
  });

  /// Sends a password-reset email.
  Future<void> sendPasswordReset(String email);

  Future<void> signOut();
}
