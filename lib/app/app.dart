import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import '../features/settings/providers/settings_providers.dart';
import 'router/app_router.dart';

/// Root widget of GymPro.
///
/// Theme mode and brand colours are owned by the gym settings (Branding
/// section), so the whole app re-skins the moment the owner changes them.
class GymProApp extends ConsumerWidget {
  const GymProApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final appearance = ref.watch(appearanceProvider);

    return MaterialApp.router(
      title: 'GymPro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(
        primary: appearance.primaryColor,
        secondary: appearance.secondaryColor,
      ),
      darkTheme: AppTheme.dark(
        primary: appearance.primaryColor,
        secondary: appearance.secondaryColor,
      ),
      themeMode: appearance.themeChoice.themeMode,
      routerConfig: router,
    );
  }
}
