/// Per-channel notification toggles (Settings → Notifications).
class NotificationSettings {
  final bool smsEnabled;
  final bool whatsappEnabled;
  final bool emailEnabled;
  final bool pushEnabled;

  const NotificationSettings({
    required this.smsEnabled,
    required this.whatsappEnabled,
    required this.emailEnabled,
    required this.pushEnabled,
  });

  factory NotificationSettings.seed() => const NotificationSettings(
        smsEnabled: false,
        whatsappEnabled: true,
        emailEnabled: true,
        pushEnabled: true,
      );

  NotificationSettings copyWith({
    bool? smsEnabled,
    bool? whatsappEnabled,
    bool? emailEnabled,
    bool? pushEnabled,
  }) {
    return NotificationSettings(
      smsEnabled: smsEnabled ?? this.smsEnabled,
      whatsappEnabled: whatsappEnabled ?? this.whatsappEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      pushEnabled: pushEnabled ?? this.pushEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'smsEnabled': smsEnabled,
        'whatsappEnabled': whatsappEnabled,
        'emailEnabled': emailEnabled,
        'pushEnabled': pushEnabled,
      };

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    final seed = NotificationSettings.seed();
    return NotificationSettings(
      smsEnabled: json['smsEnabled'] as bool? ?? seed.smsEnabled,
      whatsappEnabled: json['whatsappEnabled'] as bool? ?? seed.whatsappEnabled,
      emailEnabled: json['emailEnabled'] as bool? ?? seed.emailEnabled,
      pushEnabled: json['pushEnabled'] as bool? ?? seed.pushEnabled,
    );
  }
}
