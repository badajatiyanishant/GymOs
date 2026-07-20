import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../providers/settings_providers.dart';

/// A labelled image slot that lets the owner pick an image from their device,
/// preview it, and clear it. The picked bytes go through [storageRepository]
/// (local → `data:` URI, Firebase → https URL); the returned reference is sent
/// back via [onChanged]. Rendering handles both `data:` URIs and https URLs.
class ImageField extends ConsumerStatefulWidget {
  final String label;
  final String reference;
  final ValueChanged<String> onChanged;

  /// Logical storage path segment (e.g. "branding/logo").
  final String storagePath;

  /// Preview box aspect ratio (width / height).
  final double aspectRatio;

  const ImageField({
    super.key,
    required this.label,
    required this.reference,
    required this.onChanged,
    required this.storagePath,
    this.aspectRatio = 1,
  });

  @override
  ConsumerState<ImageField> createState() => _ImageFieldState();
}

class _ImageFieldState extends ConsumerState<ImageField> {
  bool _busy = false;

  Future<void> _pick() async {
    setState(() => _busy = true);
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      final contentType = _contentTypeFor(picked.name);
      final reference = await ref.read(storageRepositoryProvider).uploadImage(
            path: '${widget.storagePath}/${picked.name}',
            bytes: bytes,
            contentType: contentType,
          );
      widget.onChanged(reference);
    } catch (e) {
      if (mounted) context.showSnack('Could not load image', error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  static String _contentTypeFor(String name) {
    final lower = name.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    return 'image/jpeg';
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.reference.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            widget.label,
            style: context.text.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: InkWell(
            onTap: _busy ? null : _pick,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: _busy
                  ? const Center(
                      child: SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : hasImage
                      ? _Preview(reference: widget.reference)
                      : _EmptySlot(),
            ),
          ),
        ),
        if (hasImage)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => widget.onChanged(''),
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: const Text('Remove'),
            ),
          ),
      ],
    );
  }
}

class _EmptySlot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add_photo_alternate_outlined,
              color: AppColors.primary, size: 28),
          const SizedBox(height: 6),
          Text('Tap to upload', style: context.text.bodySmall),
        ],
      ),
    );
  }
}

/// Renders either a base64 `data:` URI (local storage) or a network URL.
class _Preview extends StatelessWidget {
  final String reference;
  const _Preview({required this.reference});

  @override
  Widget build(BuildContext context) {
    if (reference.startsWith('data:')) {
      final bytes = _decodeDataUri(reference);
      if (bytes == null) return _EmptySlot();
      return Image.memory(bytes, fit: BoxFit.cover);
    }
    return Image.network(
      reference,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _EmptySlot(),
    );
  }

  static Uint8List? _decodeDataUri(String uri) {
    final comma = uri.indexOf(',');
    if (comma == -1) return null;
    try {
      return base64Decode(uri.substring(comma + 1));
    } catch (_) {
      return null;
    }
  }
}

/// Standalone renderer for an image reference (data URI or URL), used outside
/// of the editable field (dashboard header, profile, login).
class BrandImage extends StatelessWidget {
  final String reference;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget fallback;

  const BrandImage({
    super.key,
    required this.reference,
    required this.fallback,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (reference.isEmpty) return fallback;
    if (reference.startsWith('data:')) {
      final bytes = _Preview._decodeDataUri(reference);
      if (bytes == null) return fallback;
      return Image.memory(bytes, width: width, height: height, fit: fit);
    }
    return Image.network(
      reference,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}
