import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Outlined "Continue with Google" button — UI only for the demo (no Firebase
/// wired yet). Uses a multi-color 'G' mark so it reads as the real thing.
class GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const GoogleButton({
    super.key,
    required this.onPressed,
    this.label = 'Continue with Google',
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final border = Theme.of(context).dividerTheme.color ?? Colors.grey;
    return SizedBox(
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _GoogleGlyph(),
            const SizedBox(width: 12),
            Text(
              label,
              style: t.labelLarge?.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A small stylized "G" using Google's brand colors, painted without any asset.
class _GoogleGlyph extends StatelessWidget {
  const _GoogleGlyph();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: ShaderMask(
        shaderCallback: (rect) => const SweepGradient(
          colors: [
            Color(0xFF4285F4),
            Color(0xFF34A853),
            Color(0xFFFBBC05),
            Color(0xFFEA4335),
            Color(0xFF4285F4),
          ],
        ).createShader(rect),
        child: const Icon(Icons.g_mobiledata_rounded,
            size: 28, color: Colors.white),
      ),
    );
  }
}
