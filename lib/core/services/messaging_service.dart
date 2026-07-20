import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Firebase Cloud Messaging bootstrap.
///
/// Requests permission, obtains the device token and subscribes the device to
/// the gym-wide topics used by the backend to fan out reminders:
///   - `attendance`    — attendance reminders
///   - `expiry`        — membership expiry warnings
///   - `payments`      — payment reminders
///   - `announcements` — owner announcements
///
/// Sending happens server-side (Cloud Functions / console campaigns) — the
/// client only needs to be reachable, which is what this sets up.
class MessagingService {
  MessagingService._();
  static final MessagingService instance = MessagingService._();

  static const topics = ['attendance', 'expiry', 'payments', 'announcements'];

  String? _token;

  /// The current FCM registration token (null before init / when denied).
  String? get token => _token;

  Future<void> init() async {
    try {
      final messaging = FirebaseMessaging.instance;

      final settings = await messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;

      // On web a VAPID key is required for tokens; skip silently if absent.
      _token = await messaging.getToken();
      debugPrint('FCM token: ${_token ?? '(unavailable)'}');

      // Topic subscribe is not supported on web clients.
      if (!kIsWeb) {
        for (final topic in topics) {
          await messaging.subscribeToTopic(topic);
        }
      }

      // Foreground messages: log now; surface in-app when the notification
      // center screen lands.
      FirebaseMessaging.onMessage.listen((message) {
        debugPrint('FCM foreground: ${message.notification?.title}');
      });
    } catch (e) {
      // Messaging is best-effort — never block startup on it.
      debugPrint('FCM init skipped: $e');
    }
  }
}
