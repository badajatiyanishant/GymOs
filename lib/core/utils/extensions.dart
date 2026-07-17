import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// Handy BuildContext extensions to cut boilerplate in widgets.
extension ContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get text => Theme.of(this).textTheme;
  ColorScheme get colors => Theme.of(this).colorScheme;

  Size get screenSize => MediaQuery.sizeOf(this);
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  bool get isMobile => width < AppConstants.mobileBreakpoint;
  bool get isTablet =>
      width >= AppConstants.mobileBreakpoint &&
      width < AppConstants.tabletBreakpoint;
  bool get isDesktop => width >= AppConstants.tabletBreakpoint;

  void showSnack(String message, {bool error = false}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: error ? Theme.of(this).colorScheme.error : null,
        ),
      );
  }
}

extension DateOnlyX on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
