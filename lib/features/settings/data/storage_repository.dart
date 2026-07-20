import 'dart:typed_data';

/// Abstraction over binary asset storage (logos, banners, QR codes). The UI
/// uploads bytes and gets back a reference string it can store in a settings
/// model and later render. The reference is intentionally opaque:
///  - [LocalStorageRepository] returns a `data:` URI (bytes inlined).
///  - [FirebaseStorageRepository] returns an https download URL.
///
/// Swapping implementations must not change any calling code.
abstract class StorageRepository {
  /// Uploads [bytes] under a logical [path] (e.g. "branding/logo") and returns
  /// a reference the app can render (https URL or `data:` URI).
  Future<String> uploadImage({
    required String path,
    required Uint8List bytes,
    required String contentType,
  });

  /// Removes a previously uploaded asset. A no-op for references the
  /// implementation doesn't own (e.g. a `data:` URI has nothing to delete).
  Future<void> deleteImage(String reference);
}
