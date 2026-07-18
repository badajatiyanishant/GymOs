import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A smooth gradient-filled line chart drawn with a [CustomPainter].
///
/// Dependency-free (no fl_chart) so the Core stage stays lean. Animates its
/// stroke on build for a premium reveal. Values are plotted relative to their
/// own min/max, so any numeric series renders sensibly.
class LineChartCard extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final Color color;
  final double height;

  const LineChartCard({
    super.key,
    required this.values,
    required this.labels,
    this.color = AppColors.primary,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final labelColor = t.bodySmall?.color;
    return SizedBox(
      height: height,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, progress, _) {
          return CustomPaint(
            painter: _LinePainter(
              values: values,
              labels: labels,
              color: color,
              progress: progress,
              labelColor: labelColor ?? Colors.grey,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final Color color;
  final double progress;
  final Color labelColor;

  _LinePainter({
    required this.values,
    required this.labels,
    required this.color,
    required this.progress,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    const bottomPad = 24.0;
    const topPad = 12.0;
    final chartH = size.height - bottomPad - topPad;
    final maxV = values.reduce(math.max);
    final minV = values.reduce(math.min);
    final range = (maxV - minV).abs() < 0.001 ? 1 : maxV - minV;
    final stepX = size.width / (values.length - 1);

    Offset pointAt(int i) {
      final x = stepX * i;
      final norm = (values[i] - minV) / range;
      final y = topPad + chartH - (norm * chartH);
      return Offset(x, y);
    }

    // Faint horizontal gridlines.
    final grid = Paint()
      ..color = labelColor.withValues(alpha: 0.12)
      ..strokeWidth = 1;
    for (var g = 0; g <= 3; g++) {
      final y = topPad + chartH * (g / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final p = pointAt(i);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        final prev = pointAt(i - 1);
        final midX = (prev.dx + p.dx) / 2;
        path.cubicTo(midX, prev.dy, midX, p.dy, p.dx, p.dy);
      }
    }

    // Animated stroke reveal via path metrics.
    final metric = path.computeMetrics().fold<Path>(Path(), (acc, m) {
      acc.addPath(m.extractPath(0, m.length * progress), Offset.zero);
      return acc;
    });

    // Gradient fill under the (fully-formed) line.
    if (progress > 0.05) {
      final fillPath = Path.from(path)
        ..lineTo(size.width, topPad + chartH)
        ..lineTo(0, topPad + chartH)
        ..close();
      final fill = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.28 * progress),
            color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      canvas.drawPath(fillPath, fill);
    }

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(metric, stroke);

    // Endpoint dot on the fully-revealed line.
    if (progress > 0.98) {
      final last = pointAt(values.length - 1);
      canvas.drawCircle(last, 5, Paint()..color = color);
      canvas.drawCircle(
        last,
        5,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    // X-axis labels.
    for (var i = 0; i < labels.length && i < values.length; i++) {
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(color: labelColor, fontSize: 11),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final x = (stepX * i) - tp.width / 2;
      tp.paint(canvas, Offset(x.clamp(0, size.width - tp.width), size.height - 16));
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter old) =>
      old.progress != progress || old.values != values;
}

/// Vertical bar chart with rounded caps and an animated grow-in.
class BarChartCard extends StatelessWidget {
  final List<double> values;
  final List<String> labels;
  final Color color;
  final double height;

  const BarChartCard({
    super.key,
    required this.values,
    required this.labels,
    this.color = AppColors.secondary,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = Theme.of(context).textTheme.bodySmall?.color;
    return SizedBox(
      height: height,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        builder: (context, progress, _) {
          return CustomPaint(
            painter: _BarPainter(
              values: values,
              labels: labels,
              color: color,
              progress: progress,
              labelColor: labelColor ?? Colors.grey,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final Color color;
  final double progress;
  final Color labelColor;

  _BarPainter({
    required this.values,
    required this.labels,
    required this.color,
    required this.progress,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    const bottomPad = 24.0;
    final chartH = size.height - bottomPad;
    final maxV = values.reduce(math.max);
    final slot = size.width / values.length;
    final barW = slot * 0.5;

    for (var i = 0; i < values.length; i++) {
      final norm = maxV == 0 ? 0.0 : values[i] / maxV;
      final barH = norm * chartH * progress;
      final left = slot * i + (slot - barW) / 2;
      final top = chartH - barH;
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTWH(left, top, barW, barH),
        topLeft: const Radius.circular(8),
        topRight: const Radius.circular(8),
      );
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color, color.withValues(alpha: 0.55)],
        ).createShader(Rect.fromLTWH(left, top, barW, chartH));
      canvas.drawRRect(rect, paint);

      if (i < labels.length) {
        final tp = TextPainter(
          text: TextSpan(
            text: labels[i],
            style: TextStyle(color: labelColor, fontSize: 11),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(
          canvas,
          Offset(left + barW / 2 - tp.width / 2, size.height - 16),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BarPainter old) =>
      old.progress != progress || old.values != values;
}

/// Donut chart with a center label, used for distribution breakdowns. Renders a
/// color-coded legend beside the ring.
class DonutChartCard extends StatelessWidget {
  final List<DonutSlice> slices;
  final String centerLabel;
  final String centerValue;
  final double size;

  const DonutChartCard({
    super.key,
    required this.slices,
    required this.centerLabel,
    required this.centerValue,
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final total = slices.fold<double>(0, (sum, s) => sum + s.value);
    return Row(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, progress, _) {
              return CustomPaint(
                painter: _DonutPainter(slices: slices, progress: progress),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(centerValue, style: t.titleLarge),
                      Text(centerLabel, style: t.bodySmall),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final s in slices)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: s.color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(s.label, style: t.bodySmall, maxLines: 1),
                      ),
                      Text(
                        total == 0
                            ? '0%'
                            : '${(s.value / total * 100).round()}%',
                        style: t.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class DonutSlice {
  final String label;
  final double value;
  final Color color;
  const DonutSlice(this.label, this.value, this.color);
}

class _DonutPainter extends CustomPainter {
  final List<DonutSlice> slices;
  final double progress;

  _DonutPainter({required this.slices, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final total = slices.fold<double>(0, (sum, s) => sum + s.value);
    if (total == 0) return;
    final rect = Offset.zero & size;
    final stroke = size.width * 0.16;
    final inner = rect.deflate(stroke / 2);
    var start = -math.pi / 2;
    for (final s in slices) {
      final sweep = (s.value / total) * 2 * math.pi * progress;
      final paint = Paint()
        ..color = s.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(inner, start, sweep, false, paint);
      start += (s.value / total) * 2 * math.pi;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.progress != progress || old.slices != slices;
}
