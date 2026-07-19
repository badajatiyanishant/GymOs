import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/charts.dart';
import '../../../core/widgets/demo_load.dart';
import '../../../core/widgets/fade_in_up.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/responsive_center.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/status_pill.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../demo/demo_data.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/quick_actions.dart';

/// Gym-owner home. A scrollable dashboard: greeting header, KPI grid, weekly
/// revenue chart, quick actions and a recent-payments feed — all populated with
/// realistic demo data for the walkthrough.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => Future<void>.delayed(
            const Duration(milliseconds: 700),
          ),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ResponsiveCenter(
              child: Column(
                children: [
                  const DashboardHeader(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                    child: DemoLoad(
                      skeleton: const _DashboardSkeleton(),
                      builder: (context) => StaggeredColumn(
                        children: [
                          const _StatGrid(),
                          const SizedBox(height: 24),
                          const _RevenueCard(),
                          const SizedBox(height: 24),
                          const SectionHeader(title: 'Quick Actions'),
                          const SizedBox(height: 4),
                          const QuickActions(),
                          const SizedBox(height: 20),
                          SectionHeader(
                            title: 'Recent Payments',
                            actionLabel: 'See all',
                            onAction: () => context.showSnack(
                                'Payments — full history coming soon'),
                          ),
                          const SizedBox(height: 4),
                          const _RecentPayments(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid();

  @override
  Widget build(BuildContext context) {
    const cards = [
      _StatData("Today's Revenue", null, Icons.payments_rounded,
          AppColors.primary, '+12%', true),
      _StatData('Active Members', '${DemoData.activeMembers}',
          Icons.groups_rounded, AppColors.secondary, '+5%', true),
      _StatData("Today's Attendance", '${DemoData.todayAttendance}',
          Icons.how_to_reg_rounded, AppColors.info, '+8%', true),
      _StatData('Pending Renewals', '${DemoData.pendingRenewals}',
          Icons.autorenew_rounded, AppColors.warning, '-3%', false),
    ];

    // Compute a card height from the actual available width so the two-column
    // grid always gives the content enough vertical room on 360–430px phones,
    // instead of relying on a fixed aspect ratio that clips text.
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 14.0;
        final cardWidth = (constraints.maxWidth - spacing) / 2;
        final cardHeight = (cardWidth * 0.98).clamp(150.0, 182.0);
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          mainAxisExtent: cardHeight,
          children: [
            for (final c in cards)
              StatCard(
                label: c.label,
                value: c.value ??
                    Formatters.currency(DemoData.todayRevenue),
                icon: c.icon,
                color: c.color,
                trend: c.trend,
                trendUp: c.trendUp,
              ),
          ],
        );
      },
    );
  }
}

/// Lightweight holder so the KPI grid can be declared once and laid out inside
/// a [LayoutBuilder] without repeating each card's constructor.
class _StatData {
  final String label;
  final String? value; // null = computed (currency-formatted) at build
  final IconData icon;
  final Color color;
  final String trend;
  final bool trendUp;
  const _StatData(
    this.label,
    this.value,
    this.icon,
    this.color,
    this.trend,
    this.trendUp,
  );
}

class _RevenueCard extends StatelessWidget {
  const _RevenueCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weekly Revenue', style: context.text.titleMedium),
                    const SizedBox(height: 2),
                    Text('Last 7 days', style: context.text.bodySmall),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up_rounded,
                        size: 16, color: AppColors.success),
                    SizedBox(width: 4),
                    Text(
                      '+18%',
                      style: TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const LineChartCard(
            values: DemoData.weeklyRevenue,
            labels: DemoData.weekdayLabels,
          ),
        ],
      ),
    );
  }
}

class _RecentPayments extends StatelessWidget {
  const _RecentPayments();

  @override
  Widget build(BuildContext context) {
    const payments = DemoData.recentPayments;
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          for (var i = 0; i < payments.length; i++) ...[
            _PaymentTile(payment: payments[i]),
            if (i != payments.length - 1)
              Divider(
                height: 1,
                indent: 68,
                color: Theme.of(context).dividerTheme.color,
              ),
          ],
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final DemoPayment payment;
  const _PaymentTile({required this.payment});

  String get _dateLabel {
    if (payment.daysAgo == 0) return 'Today';
    if (payment.daysAgo == 1) return 'Yesterday';
    return '${payment.daysAgo} days ago';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          UserAvatar(name: payment.name, radius: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.name,
                  style: context.text.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text('${payment.plan} • $_dateLabel',
                    style: context.text.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.currency(payment.amount),
                style: context.text.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              StatusPill.payment(payment.status),
            ],
          ),
        ],
      ),
    );
  }
}

/// Loading placeholder mirroring the dashboard's rough shape (KPI grid, chart,
/// list) so the transition to real content feels seamless.
class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 14.0;
            final cardWidth = (constraints.maxWidth - spacing) / 2;
            final cardHeight = (cardWidth * 0.98).clamp(150.0, 182.0);
            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              mainAxisExtent: cardHeight,
              children: const [
                _SkeletonCard(),
                _SkeletonCard(),
                _SkeletonCard(),
                _SkeletonCard(),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        const Skeleton(height: 220, radius: 18),
        const SizedBox(height: 24),
        const Skeleton(height: 96, radius: 18),
        const SizedBox(height: 24),
        const Skeleton(height: 260, radius: 18),
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerTheme.color ?? Colors.grey),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(height: 42, width: 42, radius: 12),
          Spacer(),
          Skeleton(height: 22, width: 80),
          SizedBox(height: 8),
          Skeleton(height: 12, width: 60),
        ],
      ),
    );
  }
}

