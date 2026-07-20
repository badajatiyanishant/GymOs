import '../../../core/constants/enums.dart';

/// The signed-in user's profile, stored at `users/{uid}` in Firestore.
///
/// Every user belongs to exactly one gym ([gymId]) and has one [role] that
/// drives role-based navigation and permissions. No user data is ever
/// hardcoded — profiles are created at signup (owner) or by the owner when
/// adding staff.
class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final String phone;
  final String photoUrl;
  final String gymId;
  final UserRole role;

  const AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.phone = '',
    this.photoUrl = '',
    required this.gymId,
    required this.role,
  });

  bool get isOwner => role == UserRole.owner;
  bool get isReceptionist => role == UserRole.receptionist;
  bool get isTrainer => role == UserRole.trainer;

  /// Owners and receptionists manage members/payments day to day.
  bool get canManageMembers => isOwner || isReceptionist;

  /// Only owners may edit gym settings and payment configuration.
  bool get canEditSettings => isOwner;

  /// Trainers cannot record or edit payments.
  bool get canEditPayments => isOwner || isReceptionist;

  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? phone,
    String? photoUrl,
    String? gymId,
    UserRole? role,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      gymId: gymId ?? this.gymId,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'phone': phone,
        'photoUrl': photoUrl,
        'gymId': gymId,
        'role': role.name,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        uid: json['uid'] as String? ?? '',
        email: json['email'] as String? ?? '',
        displayName: json['displayName'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        photoUrl: json['photoUrl'] as String? ?? '',
        gymId: json['gymId'] as String? ?? '',
        role: UserRole.fromString(json['role'] as String?),
      );
}
