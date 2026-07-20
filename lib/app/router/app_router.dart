import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/enums.dart';
import '../../features/analytics/screens/analytics_screen.dart';
import '../../features/auth/domain/app_user.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/members/screens/members_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/settings/screens/settings_hub_screen.dart';
import '../../features/shell/home_shell.dart';
import 'route_paths.dart';

/// Where each role lands after signing in. Trainers skip straight to the
/// member roster (their day-to-day surface); owners and receptionists get the
/// full dashboard.
String homeForRole(UserRole role) => switch (role) {
      UserRole.trainer => RoutePaths.members,
      _ => RoutePaths.dashboard,
    };

/// Central GoRouter configuration.
///
/// Flow: Splash → auth (login/signup/forgot) → a [StatefulShellRoute] hosting
/// the four primary tabs (Home, Members, Analytics, Profile). Each tab is its
/// own branch so navigation state survives tab switches.
///
/// Auth guarding: the router listens to [authStateProvider]. Signed-out users
/// are pushed to login; signed-in users are kept out of the auth screens and
/// sent to their role's home. Settings is owner-only.
final appRouterProvider = Provider<GoRouter>((ref) {
  final rootKey = GlobalKey<NavigatorState>();

  // Bridge the auth stream into a Listenable so redirects re-run on change
  // without rebuilding the router (which would reset navigation state).
  final refresh = ValueNotifier(0);
  ref
    ..onDispose(refresh.dispose)
    ..listen(authStateProvider, (_, __) => refresh.value++);

  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: false,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      if (auth.isLoading) return null; // splash stays until auth resolves
      final AppUser? user = auth.valueOrNull;

      final loc = state.matchedLocation;
      final onAuthScreen = loc == RoutePaths.login ||
          loc == RoutePaths.signup ||
          loc == RoutePaths.forgotPassword;

      // Splash handles its own exit (branded minimum delay + auto-login).
      if (loc == RoutePaths.splash) return null;

      if (user == null) return onAuthScreen ? null : RoutePaths.login;
      if (onAuthScreen) return homeForRole(user.role);
      if (loc == RoutePaths.settings && !user.canEditSettings) {
        return homeForRole(user.role);
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        pageBuilder: (context, state) => _fade(state, const LoginScreen()),
      ),
      GoRoute(
        path: RoutePaths.signup,
        pageBuilder: (context, state) => _slide(state, const SignupScreen()),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        pageBuilder: (context, state) =>
            _slide(state, const ForgotPasswordScreen()),
      ),
      GoRoute(
        path: RoutePaths.settings,
        pageBuilder: (context, state) =>
            _slide(state, const SettingsHubScreen()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.members,
                builder: (context, state) => const MembersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.analytics,
                builder: (context, state) => const AnalyticsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri}')),
    ),
  );
});

/// Fade transition — used for the auth entry so it feels calm after the splash.
CustomTransitionPage<void> _fade(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondary, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

/// Horizontal slide — used for pushing deeper into the auth stack.
CustomTransitionPage<void> _slide(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondary, child) {
      final offset = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation);
      return SlideTransition(position: offset, child: child);
    },
  );
}
