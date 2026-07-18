/// Single source of truth for route path strings, avoiding typos in `go()`.
///
/// Paths for later features are declared here up front so route names stay
/// stable, but only routes whose screens exist are registered in the router.
class RoutePaths {
  RoutePaths._();

  static const String welcome = '/';
  static const String login = '/login';
  static const String signup = '/signup';

  // Owner / reception
  static const String dashboard = '/dashboard';
  static const String members = '/members';
  static const String plans = '/plans';
  static const String payments = '/payments';
  static const String attendance = '/attendance';
  static const String workouts = '/workouts';
  static const String diet = '/diet';
  static const String reports = '/reports';
  static const String settings = '/settings';

  // Trainer
  static const String trainerHome = '/trainer';

  // Member portal
  static const String memberHome = '/me';
}
