import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/charts.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/stat_card.dart';
import '../../demo/demo_data.dart';

/// Premium analytics view: growth KPI cards, a six-month revenue line, weekly
/// attendance bars, a new-members trend and a membership-distribution donut —
/// all driven by demo data.
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Row(
                  children: [
                    Text('Analytics', style: context.text.headlineSmall),
                    const Spacer(),
                    _PeriodChip(),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              sliver: SliverList.list(
                children: [
                  const _GrowthCards(),
                  const SizedBox(height: 24),
                  const _ChartCard(
                    title: 'Revenue',
                    subtitle: 'Last 6 months (₹ thousands)',
                    child: LineChartCard(
                      values: DemoData.monthlyRevenue,
                      labels: DemoData.monthLabels,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _ChartCard(
                    title: 'Attendance',
                    subtitle: 'Check-ins this week',
                    child: BarChartCard(
                      values: DemoData.weeklyAttendance,
                      labels: DemoData.weekdayLabels,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _ChartCard(
                    title: 'New Members',
                    subtitle: 'Sign-ups over 6 months',
                    child: LineChartCard(
                      values: DemoData.newMembers,
                      labels: DemoData.monthLabels,
                      color: AppColors.info,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _ChartCard(
                    title: 'Membership Distribution',
                    subtitle: 'Active plans by type',
                    child: DonutChartCard(
                      centerLabel: 'Members',
                      centerValue: '${_distributionTotal()}',
                      slices: [
                        for (var i = 0;
                            i < DemoData.planDistribution.length;
                            i++)
                          DonutSlice(
                            DemoData.planDistribution[i].label,
                            DemoData.planDistribution[i].value.toDouble(),
                            AppColors.chartPalette[
                                i % AppColors.chartPalette.length],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static int _distributionTotal() =>
      DemoData.planDistribution.fold(0, (sum, d) => sum + d.value);
}

class _PeriodChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.calendar_today_rounded,
              size: 14, color: AppColors.primary),
          SizedBox(width: 6),
          Text(
            '2026',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthCards extends StatelessWidget {
  const _GrowthCards();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: StatCard(
            label: 'Monthly Growth',
            value: '+13.8%',
            icon: Icons.show_chart_rounded,
            color: AppColors.success,
            trend: '+2.1%',
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: StatCard(
            label: 'Retention Rate',
            value: '91%',
            icon: Icons.favorite_rounded,
            color: AppColors.primary,
            trend: '+4%',
          ),
        ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(subtitle, style: context.text.bodySmall),
          ),
          child,
        ],
      ),
    );
  }
}
