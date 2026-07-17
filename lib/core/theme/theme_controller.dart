import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../services/local_storage_service.dart';

/// Holds the current [ThemeMode] and persists user choice locally so the app
/// remembers dark/light across launches.
class ThemeController extends StateNotifier<ThemeMode> {
  ThemeController() : super(_load());

  static ThemeMode _load() {
    final stored =
        LocalStorageService.instance.getString(AppConstants.keyThemeMode);
    return switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await LocalStorageService.instance
        .setString(AppConstants.keyThemeMode, mode.name);
  }

  void toggle() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    setMode(next);
  }
}

final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeMode>(
  (ref) => ThemeController(),
);
