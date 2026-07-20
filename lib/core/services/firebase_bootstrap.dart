import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

/// One-stop Firebase initialization.
///
/// Called from main() before runApp. If `firebase_options.dart` is still the
/// placeholder (flutterfire configure not run yet), initialization is skipped
/// and [isActive] stays false so providers fall back to local repositories —
/// the app keeps working end-to-end either way.
class FirebaseBootstrap {
  FirebaseBootstrap._();

  static bool _active = false;

  /// True when Firebase initialized successfully and cloud repositories
  /// (Auth/Firestore/Storage) should be used.
  static bool get isActive => _active;

  static Future<void> init() async {
    if (!DefaultFirebaseOptions.isConfigured) {
      debugPrint('Firebase: placeholder options detected — running in local '
          'mode. Run `flutterfire configure` to enable the cloud backend.');
      return;
    }
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _active = true;

      // Crashlytics is mobile-only; web crashes go to the zone handler.
      if (!kIsWeb) {
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }

      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    } catch (e) {
      debugPrint('Firebase init failed — continuing in local mode: $e');
    }
  }

  /// Reports a zone-level uncaught error to Crashlytics when active.
  static void recordZoneError(Object error, StackTrace stack) {
    if (_active && !kIsWeb) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
  }
}
