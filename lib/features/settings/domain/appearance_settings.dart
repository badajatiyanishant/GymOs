import 'package:flutter/material.dart';

/// Which theme mode the owner has chosen for the whole app.
enum AppThemeChoice {
  light,
  dark,
  system;

  String get label => switch (this) {
        AppThemeChoice.light => 'Light',
        AppThemeChoice.dark => 'Dark',
        AppThemeChoice.system => 'System',
      };

  ThemeMode get themeMode => switch (this) {
        AppThemeChoice.light => ThemeMode.light,
        AppThemeChoice.dark => ThemeMode.dark,
        AppThemeChoice.system => ThemeMode.system,
      };

  static AppThemeChoice fromString(String? v) => AppThemeChoice.values
      .firstWhere((c) => c.name == v, orElse: () => AppThemeChoice.system);
}

/// Branding & theming the owner controls (Settings → Branding). Colours are
/// stored as ARGB ints so they serialise cleanly to JSON/Firestore.
class AppearanceSettings {
  final int primaryColorValue;
  final int secondaryColorValue;
  final AppThemeChoice themeChoice;

  /// Image references (https URL or local `data:` URI). Empty = use default.
  final String appLogoUrl;
  final String loginBackgroundUrl;
  final String dashboardBannerUrl;

  const AppearanceSettings({
    required this.primaryColorValue,
    required this.secondaryColorValue,
    required this.themeChoice,
    required this.appLogoUrl,
    required this.loginBackgroundUrl,
    required this.dashboardBannerUrl,
  });

  Color get primaryColor => Color(primaryColorValue);
  Color get secondaryColor => Color(secondaryColorValue);

  factory AppearanceSettings.seed() => const AppearanceSettings(
        primaryColorValue: 0xFF6C4DFF, // electric violet
        secondaryColorValue: 0xFF00E5A0, // neon mint
        themeChoice: AppThemeChoice.system,
        appLogoUrl: '',
        loginBackgroundUrl: '',
        dashboardBannerUrl: '',
      );

  AppearanceSettings copyWith({
    int? primaryColorValue,
    int? secondaryColorValue,
    AppThemeChoice? themeChoice,
    String? appLogoUrl,
    String? loginBackgroundUrl,
    String? dashboardBannerUrl,
  }) {
    return AppearanceSettings(
      primaryColorValue: primaryColorValue ?? this.primaryColorValue,
      secondaryColorValue: secondaryColorValue ?? this.secondaryColorValue,
      themeChoice: themeChoice ?? this.themeChoice,
      appLogoUrl: appLogoUrl ?? this.appLogoUrl,
      loginBackgroundUrl: loginBackgroundUrl ?? this.loginBackgroundUrl,
      dashboardBannerUrl: dashboardBannerUrl ?? this.dashboardBannerUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'primaryColorValue': primaryColorValue,
        'secondaryColorValue': secondaryColorValue,
        'themeChoice': themeChoice.name,
        'appLogoUrl': appLogoUrl,
        'loginBackgroundUrl': loginBackgroundUrl,
        'dashboardBannerUrl': dashboardBannerUrl,
      };

  factory AppearanceSettings.fromJson(Map<String, dynamic> json) {
    final seed = AppearanceSettings.seed();
    return AppearanceSettings(
      primaryColorValue:
          json['primaryColorValue'] as int? ?? seed.primaryColorValue,
      secondaryColorValue:
          json['secondaryColorValue'] as int? ?? seed.secondaryColorValue,
      themeChoice: AppThemeChoice.fromString(json['themeChoice'] as String?),
      appLogoUrl: json['appLogoUrl'] as String? ?? '',
      loginBackgroundUrl: json['loginBackgroundUrl'] as String? ?? '',
      dashboardBannerUrl: json['dashboardBannerUrl'] as String? ?? '',
    );
  }
}
