import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../welcome_screen.dart';
import 'route_paths.dart';

/// Central GoRouter configuration.
///
/// Feature 1 (Core) registers a single Welcome route. Each subsequent feature
/// adds its own routes here as its screens come into existence — this keeps the
/// router honest: it never points at a screen that doesn't exist yet.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.welcome,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: RoutePaths.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri}')),
    ),
  );
});
