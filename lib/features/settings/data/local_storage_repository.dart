import 'dart:convert';
import 'dart:typed_data';

import 'storage_repository.dart';

/// Local, zero-backend implementation: images are encoded as `data:` URIs so
/// they render anywhere (network image widgets accept them) and serialise into
/// the same JSON settings document. No external service required — the app
/// works immediately.
class LocalStorageRepository implements StorageRepository {
  const LocalStorageRepository();

  @override
  Future<String> uploadImage({
    required String path,
    required Uint8List bytes,
    required String contentType,
  }) async {
    final b64 = base64Encode(bytes);
    return 'data:$contentType;base64,$b64';
  }

  @override
  Future<void> deleteImage(String reference) async {
    // `data:` URIs are self-contained; dropping the reference is enough.
  }
}
