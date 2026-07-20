import 'appearance_settings.dart';
import 'business_settings.dart';
import 'gym_info.dart';
import 'membership_settings.dart';
import 'notification_settings.dart';
import 'payment_settings.dart';
import 'security_settings.dart';
import 'staff_settings.dart';

/// The full settings aggregate for a single gym. Composes all eight sections
/// into one serialisable document — this is what the repository reads and
/// writes (Firestore path intent: `gyms/{gymId}/settings/`). The UI and the
/// rest of the app depend on this aggregate, never on individual storage.
class GymSettings {
  final GymInfoSettings info;
  final BusinessSettings business;
  final AppearanceSettings appearance;
  final MembershipSettings membership;
  final PaymentSettings payment;
  final NotificationSettings notification;
  final StaffSettings staff;
  final SecuritySettings security;

  const GymSettings({
    required this.info,
    required this.business,
    required this.appearance,
    required this.membership,
    required this.payment,
    required this.notification,
    required this.staff,
    required this.security,
  });

  /// A fully-populated default gym so a fresh install works immediately.
  factory GymSettings.seed() => GymSettings(
        info: GymInfoSettings.seed(),
        business: BusinessSettings.seed(),
        appearance: AppearanceSettings.seed(),
        membership: MembershipSettings.seed(),
        payment: PaymentSettings.seed(),
        notification: NotificationSettings.seed(),
        staff: StaffSettings.seed(),
        security: SecuritySettings.seed(),
      );

  GymSettings copyWith({
    GymInfoSettings? info,
    BusinessSettings? business,
    AppearanceSettings? appearance,
    MembershipSettings? membership,
    PaymentSettings? payment,
    NotificationSettings? notification,
    StaffSettings? staff,
    SecuritySettings? security,
  }) {
    return GymSettings(
      info: info ?? this.info,
      business: business ?? this.business,
      appearance: appearance ?? this.appearance,
      membership: membership ?? this.membership,
      payment: payment ?? this.payment,
      notification: notification ?? this.notification,
      staff: staff ?? this.staff,
      security: security ?? this.security,
    );
  }

  Map<String, dynamic> toJson() => {
        'info': info.toJson(),
        'business': business.toJson(),
        'appearance': appearance.toJson(),
        'membership': membership.toJson(),
        'payment': payment.toJson(),
        'notification': notification.toJson(),
        'staff': staff.toJson(),
        'security': security.toJson(),
      };

  factory GymSettings.fromJson(Map<String, dynamic> json) {
    final seed = GymSettings.seed();

    Map<String, dynamic>? section(String key) =>
        json[key] as Map<String, dynamic>?;

    final infoJson = section('info');
    final businessJson = section('business');
    final appearanceJson = section('appearance');
    final membershipJson = section('membership');
    final paymentJson = section('payment');
    final notificationJson = section('notification');
    final staffJson = section('staff');
    final securityJson = section('security');

    return GymSettings(
      info: infoJson == null
          ? seed.info
          : GymInfoSettings.fromJson(infoJson),
      business: businessJson == null
          ? seed.business
          : BusinessSettings.fromJson(businessJson),
      appearance: appearanceJson == null
          ? seed.appearance
          : AppearanceSettings.fromJson(appearanceJson),
      membership: membershipJson == null
          ? seed.membership
          : MembershipSettings.fromJson(membershipJson),
      payment: paymentJson == null
          ? seed.payment
          : PaymentSettings.fromJson(paymentJson),
      notification: notificationJson == null
          ? seed.notification
          : NotificationSettings.fromJson(notificationJson),
      staff: staffJson == null
          ? seed.staff
          : StaffSettings.fromJson(staffJson),
      security: securityJson == null
          ? seed.security
          : SecuritySettings.fromJson(securityJson),
    );
  }
}
