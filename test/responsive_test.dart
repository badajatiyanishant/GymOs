import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gympro/core/services/local_storage_service.dart';
import 'package:gympro/core/theme/app_theme.dart';
import 'package:gympro/features/dashboard/screens/dashboard_screen.dart';
import 'package:gympro/features/members/screens/members_screen.dart';

Widget _host(Widget child) => ProviderScope(
      child: MaterialApp(theme: AppTheme.light, home: child),
    );

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await LocalStorageService.instance.init();
  });

  // Common phone logical widths. A RenderFlex overflow throws and fails here,
  // so passing means no yellow overflow stripes at these sizes.
  const widths = <double>[360, 375, 390, 412];
  final screens = <String, Widget Function()>{
    'Dashboard': () => const DashboardScreen(),
    'Members': () => const MembersScreen(),
  };

  for (final width in widths) {
    screens.forEach((name, build) {
      testWidgets('$name has no overflow at ${width.toInt()}px wide',
          (tester) async {
        tester.view.physicalSize = Size(width * 3, 900 * 3);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(_host(build()));
        // Let skeleton loaders / entrance animations settle to real content.
        await tester.pump(const Duration(milliseconds: 900));
        await tester.pump(const Duration(milliseconds: 900));
        expect(tester.takeException(), isNull);
      });
    });
  }
}
