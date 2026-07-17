/// Domain enums shared across features. Keeping them centralized avoids
/// stringly-typed bugs and gives us one source of truth for (de)serialization.

/// The four user roles. Permissions are derived from this across the app.
enum UserRole {
  owner,
  trainer,
  receptionist,
  member;

  String get label => switch (this) {
        UserRole.owner => 'Gym Owner',
        UserRole.trainer => 'Trainer',
        UserRole.receptionist => 'Receptionist',
        UserRole.member => 'Member',
      };

  static UserRole fromString(String? value) => UserRole.values.firstWhere(
        (r) => r.name == value,
        orElse: () => UserRole.member,
      );
}

/// Membership lifecycle status, derived from expiry date at read time.
enum MembershipStatus {
  active,
  expiringSoon,
  expired,
  frozen;

  String get label => switch (this) {
        MembershipStatus.active => 'Active',
        MembershipStatus.expiringSoon => 'Expiring Soon',
        MembershipStatus.expired => 'Expired',
        MembershipStatus.frozen => 'Frozen',
      };
}

/// Billing cycle for a membership plan.
enum PlanDuration {
  monthly,
  quarterly,
  halfYearly,
  yearly,
  custom;

  String get label => switch (this) {
        PlanDuration.monthly => 'Monthly',
        PlanDuration.quarterly => 'Quarterly',
        PlanDuration.halfYearly => 'Half Yearly',
        PlanDuration.yearly => 'Yearly',
        PlanDuration.custom => 'Custom',
      };

  /// Default number of days for the cycle (custom returns 0 — caller supplies).
  int get days => switch (this) {
        PlanDuration.monthly => 30,
        PlanDuration.quarterly => 90,
        PlanDuration.halfYearly => 180,
        PlanDuration.yearly => 365,
        PlanDuration.custom => 0,
      };

  static PlanDuration fromString(String? v) => PlanDuration.values.firstWhere(
        (d) => d.name == v,
        orElse: () => PlanDuration.monthly,
      );
}

/// Payment method used to settle an invoice.
enum PaymentMethod {
  cash,
  upi,
  card,
  online;

  String get label => switch (this) {
        PaymentMethod.cash => 'Cash',
        PaymentMethod.upi => 'UPI',
        PaymentMethod.card => 'Card',
        PaymentMethod.online => 'Online',
      };

  static PaymentMethod fromString(String? v) => PaymentMethod.values.firstWhere(
        (m) => m.name == v,
        orElse: () => PaymentMethod.cash,
      );
}

/// Whether a payment fully or partially settled the dues.
enum PaymentStatus {
  paid,
  partial,
  pending;

  String get label => switch (this) {
        PaymentStatus.paid => 'Paid',
        PaymentStatus.partial => 'Partial',
        PaymentStatus.pending => 'Pending',
      };

  static PaymentStatus fromString(String? v) => PaymentStatus.values.firstWhere(
        (s) => s.name == v,
        orElse: () => PaymentStatus.paid,
      );
}

/// How a member checked in.
enum CheckInMethod {
  qr,
  manual,
  biometric;

  String get label => switch (this) {
        CheckInMethod.qr => 'QR',
        CheckInMethod.manual => 'Manual',
        CheckInMethod.biometric => 'Biometric',
      };

  static CheckInMethod fromString(String? v) =>
      CheckInMethod.values.firstWhere(
        (m) => m.name == v,
        orElse: () => CheckInMethod.manual,
      );
}

enum Gender {
  male,
  female,
  other;

  String get label => switch (this) {
        Gender.male => 'Male',
        Gender.female => 'Female',
        Gender.other => 'Other',
      };

  static Gender fromString(String? v) => Gender.values.firstWhere(
        (g) => g.name == v,
        orElse: () => Gender.other,
      );
}
