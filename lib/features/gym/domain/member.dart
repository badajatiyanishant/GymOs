import '../../../core/constants/enums.dart';

/// A gym member document at `gyms/{gymId}/members/{id}`.
class Member {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String photoUrl;
  final Gender gender;
  final String planId;
  final String planName;
  final DateTime joinedAt;
  final DateTime expiresAt;
  final bool frozen;
  final String assignedTrainerId;
  final String notes;

  const Member({
    required this.id,
    required this.name,
    this.email = '',
    this.phone = '',
    this.photoUrl = '',
    this.gender = Gender.other,
    this.planId = '',
    this.planName = '',
    required this.joinedAt,
    required this.expiresAt,
    this.frozen = false,
    this.assignedTrainerId = '',
    this.notes = '',
  });

  /// Lifecycle status derived from expiry at read time — never stored, so it
  /// can't go stale.
  MembershipStatus get status {
    if (frozen) return MembershipStatus.frozen;
    final now = DateTime.now();
    if (expiresAt.isBefore(now)) return MembershipStatus.expired;
    if (expiresAt.difference(now).inDays <= 7) {
      return MembershipStatus.expiringSoon;
    }
    return MembershipStatus.active;
  }

  int get daysToExpiry => expiresAt.difference(DateTime.now()).inDays;

  Member copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    Gender? gender,
    String? planId,
    String? planName,
    DateTime? joinedAt,
    DateTime? expiresAt,
    bool? frozen,
    String? assignedTrainerId,
    String? notes,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      gender: gender ?? this.gender,
      planId: planId ?? this.planId,
      planName: planName ?? this.planName,
      joinedAt: joinedAt ?? this.joinedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      frozen: frozen ?? this.frozen,
      assignedTrainerId: assignedTrainerId ?? this.assignedTrainerId,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'photoUrl': photoUrl,
        'gender': gender.name,
        'planId': planId,
        'planName': planName,
        'joinedAt': joinedAt.toIso8601String(),
        'expiresAt': expiresAt.toIso8601String(),
        'frozen': frozen,
        'assignedTrainerId': assignedTrainerId,
        'notes': notes,
      };

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        photoUrl: json['photoUrl'] as String? ?? '',
        gender: Gender.fromString(json['gender'] as String?),
        planId: json['planId'] as String? ?? '',
        planName: json['planName'] as String? ?? '',
        joinedAt: DateTime.tryParse(json['joinedAt'] as String? ?? '') ??
            DateTime.now(),
        expiresAt: DateTime.tryParse(json['expiresAt'] as String? ?? '') ??
            DateTime.now(),
        frozen: json['frozen'] as bool? ?? false,
        assignedTrainerId: json['assignedTrainerId'] as String? ?? '',
        notes: json['notes'] as String? ?? '',
      );
}
