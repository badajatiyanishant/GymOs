/// A permission that can be granted to a staff member. Kept as an enum so the
/// UI can render a fixed checklist and storage stays stringly-safe.
enum StaffPermission {
  manageMembers,
  collectPayments,
  viewReports,
  manageStaff,
  editSettings,
  markAttendance;

  String get label => switch (this) {
        StaffPermission.manageMembers => 'Manage Members',
        StaffPermission.collectPayments => 'Collect Payments',
        StaffPermission.viewReports => 'View Reports',
        StaffPermission.manageStaff => 'Manage Staff',
        StaffPermission.editSettings => 'Edit Settings',
        StaffPermission.markAttendance => 'Mark Attendance',
      };

  static StaffPermission? fromString(String? v) {
    for (final p in StaffPermission.values) {
      if (p.name == v) return p;
    }
    return null;
  }
}

/// Staff role. Owner is implicit (the account holder); staff are managers or
/// trainers with a tailored permission set.
enum StaffRole {
  manager,
  trainer,
  receptionist;

  String get label => switch (this) {
        StaffRole.manager => 'Manager',
        StaffRole.trainer => 'Trainer',
        StaffRole.receptionist => 'Receptionist',
      };

  /// Sensible default permissions when a role is first assigned.
  Set<StaffPermission> get defaultPermissions => switch (this) {
        StaffRole.manager => {
            StaffPermission.manageMembers,
            StaffPermission.collectPayments,
            StaffPermission.viewReports,
            StaffPermission.markAttendance,
          },
        StaffRole.trainer => {
            StaffPermission.manageMembers,
            StaffPermission.markAttendance,
          },
        StaffRole.receptionist => {
            StaffPermission.manageMembers,
            StaffPermission.collectPayments,
            StaffPermission.markAttendance,
          },
      };

  static StaffRole fromString(String? v) => StaffRole.values
      .firstWhere((r) => r.name == v, orElse: () => StaffRole.trainer);
}

/// A single staff member with an assigned role and explicit permissions.
class StaffMember {
  final String id;
  final String name;
  final String phone;
  final StaffRole role;
  final Set<StaffPermission> permissions;

  const StaffMember({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.permissions,
  });

  StaffMember copyWith({
    String? name,
    String? phone,
    StaffRole? role,
    Set<StaffPermission>? permissions,
  }) {
    return StaffMember(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'role': role.name,
        'permissions': permissions.map((p) => p.name).toList(),
      };

  factory StaffMember.fromJson(Map<String, dynamic> json) {
    final perms = (json['permissions'] as List<dynamic>?)
            ?.map((e) => StaffPermission.fromString(e as String?))
            .whereType<StaffPermission>()
            .toSet() ??
        <StaffPermission>{};
    return StaffMember(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: StaffRole.fromString(json['role'] as String?),
      permissions: perms,
    );
  }
}

/// The full staff roster (Settings → Staff).
class StaffSettings {
  final List<StaffMember> members;

  const StaffSettings({required this.members});

  factory StaffSettings.seed() => const StaffSettings(
        members: [
          StaffMember(
            id: 'seed-manager',
            name: 'Neha Kapoor',
            phone: '+91 98111 22334',
            role: StaffRole.manager,
            permissions: {
              StaffPermission.manageMembers,
              StaffPermission.collectPayments,
              StaffPermission.viewReports,
              StaffPermission.markAttendance,
            },
          ),
          StaffMember(
            id: 'seed-trainer',
            name: 'Rahul Verma',
            phone: '+91 98222 33445',
            role: StaffRole.trainer,
            permissions: {
              StaffPermission.manageMembers,
              StaffPermission.markAttendance,
            },
          ),
        ],
      );

  StaffSettings copyWith({List<StaffMember>? members}) =>
      StaffSettings(members: members ?? this.members);

  Map<String, dynamic> toJson() => {
        'members': members.map((m) => m.toJson()).toList(),
      };

  factory StaffSettings.fromJson(Map<String, dynamic> json) {
    final list = (json['members'] as List<dynamic>?)
        ?.map((e) => StaffMember.fromJson(e as Map<String, dynamic>))
        .toList();
    return StaffSettings(members: list ?? const []);
  }
}
