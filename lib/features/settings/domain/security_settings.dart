/// Account security preferences (Settings → Security). The password itself is
/// never stored here — changing it is an auth action. [sessionEpoch] is bumped
/// whenever the owner triggers "log out from all devices"; any session issued
/// before the current epoch is considered stale.
class SecuritySettings {
  final bool twoFactorEnabled;

  /// Monotonic counter bumped on "logout all devices". Sessions older than this
  /// epoch are invalidated.
  final int sessionEpoch;

  const SecuritySettings({
    required this.twoFactorEnabled,
    required this.sessionEpoch,
  });

  factory SecuritySettings.seed() => const SecuritySettings(
        twoFactorEnabled: false,
        sessionEpoch: 0,
      );

  SecuritySettings copyWith({
    bool? twoFactorEnabled,
    int? sessionEpoch,
  }) {
    return SecuritySettings(
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      sessionEpoch: sessionEpoch ?? this.sessionEpoch,
    );
  }

  Map<String, dynamic> toJson() => {
        'twoFactorEnabled': twoFactorEnabled,
        'sessionEpoch': sessionEpoch,
      };

  factory SecuritySettings.fromJson(Map<String, dynamic> json) {
    final seed = SecuritySettings.seed();
    return SecuritySettings(
      twoFactorEnabled:
          json['twoFactorEnabled'] as bool? ?? seed.twoFactorEnabled,
      sessionEpoch: json['sessionEpoch'] as int? ?? seed.sessionEpoch,
    );
  }
}
