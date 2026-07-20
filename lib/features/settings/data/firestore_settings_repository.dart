import '../domain/gym_settings.dart';
import 'settings_repository.dart';

/// Firestore implementation — INACTIVE. Written against the same interface so
/// enabling it is a one-line provider change with zero UI impact. To enable:
///   1. Add `cloud_firestore` to pubspec.yaml and configure firebase_options.
///   2. Uncomment the imports + bodies below.
///   3. Point `settingsRepositoryProvider` at this class (passing the gymId).
///
/// Document layout: `gyms/{gymId}/settings/config`, storing the same JSON that
/// [GymSettings.toJson] produces, so the local and remote payloads are
/// byte-compatible.
class FirestoreSettingsRepository implements SettingsRepository {
  FirestoreSettingsRepository({required this.gymId});

  final String gymId;

  // DocumentReference<Map<String, dynamic>> get _doc =>
  //     FirebaseFirestore.instance
  //         .collection('gyms')
  //         .doc(gymId)
  //         .collection('settings')
  //         .doc('config');

  @override
  Future<GymSettings> load() async {
    // final snap = await _doc.get();
    // final data = snap.data();
    // return data == null ? GymSettings.seed() : GymSettings.fromJson(data);
    throw UnimplementedError(
      'FirestoreSettingsRepository is not enabled. Add cloud_firestore and '
      'switch settingsRepositoryProvider to activate it.',
    );
  }

  @override
  Future<void> save(GymSettings settings) async {
    // await _doc.set(settings.toJson());
    throw UnimplementedError('FirestoreSettingsRepository is not enabled.');
  }

  @override
  Stream<GymSettings> watch() {
    // return _doc.snapshots().map((snap) {
    //   final data = snap.data();
    //   return data == null ? GymSettings.seed() : GymSettings.fromJson(data);
    // });
    throw UnimplementedError('FirestoreSettingsRepository is not enabled.');
  }
}
