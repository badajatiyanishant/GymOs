import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../core/constants/enums.dart';
import '../domain/app_user.dart';
import 'auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Production [AuthRepository] backed by Firebase Auth + Firestore.
///
/// Profile documents live at `users/{uid}` and carry the tenant key
/// (`gymId`) and `role` used by security rules and role-based navigation.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection('users').doc(uid);

  @override
  Stream<AppUser?> authState() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return _loadProfile(user);
    });
  }

  @override
  Future<AppUser?> currentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _loadProfile(user);
  }

  Future<AppUser?> _loadProfile(User user) async {
    final snap = await _userDoc(user.uid).get();
    final data = snap.data();
    if (data == null) return null;
    return AppUser.fromJson({...data, 'uid': user.uid});
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    try {
      // Web sessions honour Remember Me; mobile sessions always persist.
      if (kIsWeb) {
        await _auth.setPersistence(
          rememberMe ? Persistence.LOCAL : Persistence.SESSION,
        );
      }
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final profile = await _loadProfile(cred.user!);
      if (profile == null) {
        await _auth.signOut();
        throw const AuthException(
          'Your account has no profile yet. Ask your gym owner to add you.',
        );
      }
      return profile;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_friendly(e));
    }
  }

  @override
  Future<AppUser> signUpOwner({
    required String fullName,
    required String gymName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = cred.user!.uid;

      // New tenant: one gym document + the owner profile pointing at it.
      final gymRef = _firestore.collection('gyms').doc();
      final profile = AppUser(
        uid: uid,
        email: email.trim(),
        displayName: fullName.trim(),
        phone: phone.trim(),
        gymId: gymRef.id,
        role: UserRole.owner,
      );

      final batch = _firestore.batch();
      batch.set(gymRef, {
        'name': gymName.trim(),
        'ownerUid': uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      batch.set(_userDoc(uid), {
        ...profile.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      await batch.commit();

      await cred.user!.updateDisplayName(fullName.trim());
      return profile;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_friendly(e));
    }
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) return null;

      var profile = await _loadProfile(user);

      if (profile == null) {
        profile = AppUser(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? '',
          phone: user.phoneNumber ?? '',
          gymId: '',
          role: UserRole.owner,
        );

        await _userDoc(user.uid).set({
          ...profile.toJson(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return profile;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_friendly(e));
    }
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_friendly(e));
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  /// Maps Firebase error codes to messages safe to surface in the UI.
  String _friendly(FirebaseAuthException e) => switch (e.code) {
        'invalid-credential' ||
        'wrong-password' ||
        'user-not-found' =>
          'Incorrect email or password.',
        'invalid-email' => 'That email address is not valid.',
        'user-disabled' => 'This account has been disabled.',
        'email-already-in-use' => 'An account already exists for that email.',
        'weak-password' => 'Password is too weak — use at least 6 characters.',
        'too-many-requests' =>
          'Too many attempts. Please wait a moment and try again.',
        'network-request-failed' =>
          'Network error. Check your connection and try again.',
        _ => e.message ?? 'Authentication failed. Please try again.',
      };
}
