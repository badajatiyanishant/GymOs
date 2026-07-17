/// App-wide constant values (no theming/colors here — see core/theme).
class AppConstants {
  AppConstants._();

  static const String appName = 'GymPro';
  static const String appTagline = 'Manage your entire gym from one app.';

  // Firestore root collections.
  static const String gymsCollection = 'gyms';
  static const String usersCollection = 'users';
  static const String membersCollection = 'members';
  static const String plansCollection = 'plans';
  static const String paymentsCollection = 'payments';
  static const String attendanceCollection = 'attendance';
  static const String workoutsCollection = 'workouts';
  static const String exercisesCollection = 'exercises';
  static const String dietsCollection = 'diets';
  static const String notificationsCollection = 'notifications';

  // Storage buckets/paths.
  static const String memberPhotosPath = 'member_photos';
  static const String progressPhotosPath = 'progress_photos';
  static const String gymLogosPath = 'gym_logos';
  static const String exerciseMediaPath = 'exercise_media';

  // Local storage keys.
  static const String keyThemeMode = 'theme_mode';
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyCachedRole = 'cached_role';
  static const String keyBiometricEnabled = 'biometric_enabled';

  // UI timings.
  static const Duration shortAnim = Duration(milliseconds: 200);
  static const Duration mediumAnim = Duration(milliseconds: 350);
  static const Duration longAnim = Duration(milliseconds: 600);

  // Pagination.
  static const int pageSize = 20;

  // Responsive breakpoints (logical px).
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
}
