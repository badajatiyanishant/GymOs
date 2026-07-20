/// Membership lifecycle rules (Settings → Membership).
class MembershipSettings {
  final bool trialEnabled;

  /// Trial length in days (only meaningful when [trialEnabled]).
  final int trialDurationDays;

  /// When true, memberships auto-expire on their end date without manual action.
  final bool autoExpiry;

  /// How many days before expiry to send a renewal reminder.
  final int renewalReminderDays;

  const MembershipSettings({
    required this.trialEnabled,
    required this.trialDurationDays,
    required this.autoExpiry,
    required this.renewalReminderDays,
  });

  factory MembershipSettings.seed() => const MembershipSettings(
        trialEnabled: true,
        trialDurationDays: 7,
        autoExpiry: true,
        renewalReminderDays: 3,
      );

  MembershipSettings copyWith({
    bool? trialEnabled,
    int? trialDurationDays,
    bool? autoExpiry,
    int? renewalReminderDays,
  }) {
    return MembershipSettings(
      trialEnabled: trialEnabled ?? this.trialEnabled,
      trialDurationDays: trialDurationDays ?? this.trialDurationDays,
      autoExpiry: autoExpiry ?? this.autoExpiry,
      renewalReminderDays: renewalReminderDays ?? this.renewalReminderDays,
    );
  }

  Map<String, dynamic> toJson() => {
        'trialEnabled': trialEnabled,
        'trialDurationDays': trialDurationDays,
        'autoExpiry': autoExpiry,
        'renewalReminderDays': renewalReminderDays,
      };

  factory MembershipSettings.fromJson(Map<String, dynamic> json) {
    final seed = MembershipSettings.seed();
    return MembershipSettings(
      trialEnabled: json['trialEnabled'] as bool? ?? seed.trialEnabled,
      trialDurationDays:
          json['trialDurationDays'] as int? ?? seed.trialDurationDays,
      autoExpiry: json['autoExpiry'] as bool? ?? seed.autoExpiry,
      renewalReminderDays:
          json['renewalReminderDays'] as int? ?? seed.renewalReminderDays,
    );
  }
}
