import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// Constrains content to a comfortable reading width and centers it on wide
/// (tablet/desktop/web) viewports, while staying edge-to-edge on phones. Keeps
/// the mobile-first layouts looking intentional on large screens.
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = AppConstants.tabletBreakpoint,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
