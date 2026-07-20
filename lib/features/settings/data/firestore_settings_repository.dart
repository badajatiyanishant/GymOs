import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/gym_settings.dart';
import 'settings_repository.dart';

/// Firestore implementation of [SettingsRepository] — ACTIVE.
///
/// Document layout: `gyms/{gymId}/settings/config`, storing the same JSON that
/// [GymSettings.toJson] produces, so the local and remote payloads are
/// byte-compatible and switching backends never migrates data shape.
class FirestoreSettingsRepository implements SettingsRepository {
  FirestoreSettingsRepository({
    required this.gymId,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String gymId;
  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> get _doc => _firestore
      .collection('gyms')
      .doc(gymId)
      .collection('settings')
      .doc('config');

  @override
  Future<GymSettings> load() async {
    final snap = await _doc.get();
    final data = snap.data();
    return data == null ? GymSettings.seed() : GymSettings.fromJson(data);
  }

  @override
  Future<void> save(GymSettings settings) => _doc.set(settings.toJson());

  @override
  Stream<GymSettings> watch() {
    return _doc.snapshots().map((snap) {
      final data = snap.data();
      return data == null ? GymSettings.seed() : GymSettings.fromJson(data);
    });
  }
}
