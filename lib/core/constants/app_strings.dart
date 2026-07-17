/// Central place for all user-facing string literals so the app can be
/// localized later without hunting through widgets.
class AppStrings {
  AppStrings._();

  // Auth
  static const String login = 'Login';
  static const String signUp = 'Sign Up';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String continueWithGoogle = 'Continue with Google';
  static const String logout = 'Logout';

  // Roles
  static const String owner = 'Gym Owner';
  static const String trainer = 'Trainer';
  static const String receptionist = 'Receptionist';
  static const String member = 'Member';

  // Dashboard
  static const String dashboard = 'Dashboard';
  static const String todayCheckIns = "Today's Check-ins";
  static const String activeMembers = 'Active Members';
  static const String expiredMemberships = 'Expired Memberships';
  static const String monthlyRevenue = 'Monthly Revenue';
  static const String pendingPayments = 'Pending Payments';
  static const String newRegistrations = 'New Registrations';

  // Generic
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String somethingWentWrong = 'Something went wrong';
  static const String noData = 'Nothing here yet';
  static const String retry = 'Retry';
}
