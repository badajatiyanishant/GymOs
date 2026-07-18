import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/charts.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/section_header.dart';
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
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: DashboardHeader()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              sliver: SliverList.list(
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
                    onAction: () {},
                  ),
                  const SizedBox(height: 4),
                  const _RecentPayments(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.35,
      children: [
        StatCard(
          label: "Today's Revenue",
          value: Formatters.currency(DemoData.todayRevenue),
          icon: Icons.payments_rounded,
          color: AppColors.primary,
          trend: '+12%',
        ),
        const StatCard(
          label: 'Active Members',
          value: '${DemoData.activeMembers}',
          icon: Icons.groups_rounded,
          color: AppColors.secondary,
          trend: '+5%',
        ),
        const StatCard(
          label: "Today's Attendance",
          value: '${DemoData.todayAttendance}',
          icon: Icons.how_to_reg_rounded,
          color: AppColors.info,
          trend: '+8%',
        ),
        const StatCard(
          label: 'Pending Renewals',
          value: '${DemoData.pendingRenewals}',
          icon: Icons.autorenew_rounded,
          color: AppColors.warning,
          trend: '-3%',
          trendUp: false,
        ),
      ],
    );
  }
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
