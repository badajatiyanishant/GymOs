import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import 'storage_repository.dart';

/// Firebase Storage implementation of [StorageRepository] — ACTIVE.
///
/// The contract matches [LocalStorageRepository]: [uploadImage] returns an
/// https download URL instead of a `data:` URI; only the URL is ever stored
/// in Firestore. Paths are scoped per gym: `gyms/{gymId}/{logical path}`.
class FirebaseStorageRepository implements StorageRepository {
  FirebaseStorageRepository({required this.gymId, FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final String gymId;
  final FirebaseStorage _storage;

  @override
  Future<String> uploadImage({
    required String path,
    required Uint8List bytes,
    required String contentType,
  }) async {
    final ref = _storage.ref('gyms/$gymId/$path');
    await ref.putData(bytes, SettableMetadata(contentType: contentType));
    return ref.getDownloadURL();
  }

  @override
  Future<void> deleteImage(String reference) async {
    // Only delete objects we own (https URLs); data: URIs have no remote copy.
    if (!reference.startsWith('http')) return;
    try {
      await _storage.refFromURL(reference).delete();
    } on FirebaseException {
      // Already gone or foreign URL — nothing to clean up.
    }
  }
}
