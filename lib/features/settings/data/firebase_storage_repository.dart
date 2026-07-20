import 'dart:typed_data';

import 'storage_repository.dart';

/// Firebase Storage implementation — INACTIVE. Provided so the swap to a real
/// backend is a one-line provider change with no UI impact. To enable:
///   1. Add `firebase_storage` to pubspec.yaml.
///   2. Uncomment the import + body below.
///   3. Point `storageRepositoryProvider` at this class.
///
/// The contract matches [LocalStorageRepository]: [uploadImage] returns an
/// https download URL instead of a `data:` URI; everything else is identical.
class FirebaseStorageRepository implements StorageRepository {
  const FirebaseStorageRepository();

  @override
  Future<String> uploadImage({
    required String path,
    required Uint8List bytes,
    required String contentType,
  }) async {
    // --- Enable with the firebase_storage package: ---
    // final ref = FirebaseStorage.instance.ref(path);
    // await ref.putData(bytes, SettableMetadata(contentType: contentType));
    // return ref.getDownloadURL();
    throw UnimplementedError(
      'FirebaseStorageRepository is not enabled. Add firebase_storage and '
      'switch storageRepositoryProvider to activate it.',
    );
  }

  @override
  Future<void> deleteImage(String reference) async {
    // --- Enable with the firebase_storage package: ---
    // await FirebaseStorage.instance.refFromURL(reference).delete();
    throw UnimplementedError(
      'FirebaseStorageRepository is not enabled.',
    );
  }
}
