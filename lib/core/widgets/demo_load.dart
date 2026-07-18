import 'package:flutter/material.dart';

import 'skeleton_loader.dart';

/// Simulates a short network fetch for the demo: shows [skeleton] for [delay],
/// then reveals [builder] with a soft cross-fade. Centralizes the "content is
/// loading" illusion so individual screens don't each reimplement it.
class DemoLoad extends StatefulWidget {
  final Widget skeleton;
  final WidgetBuilder builder;
  final Duration delay;

  const DemoLoad({
    super.key,
    required this.skeleton,
    required this.builder,
    this.delay = const Duration(milliseconds: 700),
  });

  @override
  State<DemoLoad> createState() => _DemoLoadState();
}

class _DemoLoadState extends State<DemoLoad> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: _loading
          ? SkeletonLoader(key: const ValueKey('skeleton'), child: widget.skeleton)
          : KeyedSubtree(
              key: const ValueKey('content'),
              child: widget.builder(context),
            ),
    );
  }
}
