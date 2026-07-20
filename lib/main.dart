import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/services/firebase_bootstrap.dart';
import 'core/services/local_storage_service.dart';
import 'core/services/messaging_service.dart';

/// Application entry point.
///
/// Initializes Firebase and platform services *before* running the app so that
/// providers/repositories can assume they are ready. Everything is wrapped in a
/// [ProviderScope] so Riverpod manages state across the whole tree.
Future<void> main() async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Lock to portrait — a gym-floor app is used one-handed on phones.
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Lightweight key/value store for flags + the local-mode repositories.
    await LocalStorageService.instance.init();

    // Initialize Firebase before starting the application.
    await FirebaseBootstrap.init();

    if (FirebaseBootstrap.isActive) {
      // Offline-first: cache reads/writes locally and sync when back online.
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      // Push notifications (attendance/expiry/payment reminders,
      // announcements).
      await MessagingService.instance.init();
    }

    runApp(
      const ProviderScope(
        child: GymProApp(),
      ),
    );
  }, (error, stack) {
    FirebaseBootstrap.recordZoneError(error, stack);
    debugPrint('Uncaught zone error: $error\n$stack');
  });
}
