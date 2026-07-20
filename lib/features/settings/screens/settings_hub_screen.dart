import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../providers/settings_providers.dart';
import '../widgets/image_field.dart';
import 'branding_settings_screen.dart';
import 'business_settings_screen.dart';
import 'general_settings_screen.dart';
import 'membership_settings_screen.dart';
import 'notification_settings_screen.dart';
import 'payment_settings_screen.dart';
import 'security_settings_screen.dart';
import 'staff_settings_screen.dart';

/// Entry point for all gym settings. Lists the eight sections and shows a live
/// branding summary at the top sourced from the settings provider.
class SettingsHubScreen extends ConsumerWidget {
  const SettingsHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(gymInfoProvider);

    final sections = <_SectionEntry>[
      _SectionEntry(
        icon: Icons.store_mall_directory_outlined,
        title: 'General',
        subtitle: 'Name, logo, contact, location, hours',
        builder: () => const GeneralSettingsScreen(),
      ),
      _SectionEntry(
        icon: Icons.business_center_outlined,
        title: 'Business',
        subtitle: 'GST, PAN, invoicing, currency',
        builder: () => const BusinessSettingsScreen(),
      ),
      _SectionEntry(
        icon: Icons.palette_outlined,
        title: 'Branding',
        subtitle: 'Colours, theme, images',
        builder: () => const BrandingSettingsScreen(),
      ),
      _SectionEntry(
        icon: Icons.card_membership_outlined,
        title: 'Membership',
        subtitle: 'Trials, expiry, renewal reminders',
        builder: () => const MembershipSettingsScreen(),
      ),
      _SectionEntry(
        icon: Icons.payments_outlined,
        title: 'Payments',
        subtitle: 'Methods, UPI, bank, QR code',
        builder: () => const PaymentSettingsScreen(),
      ),
      _SectionEntry(
        icon: Icons.notifications_none_rounded,
        title: 'Notifications',
        subtitle: 'SMS, WhatsApp, email, push',
        builder: () => const NotificationSettingsScreen(),
      ),
      _SectionEntry(
        icon: Icons.people_alt_outlined,
        title: 'Staff',
        subtitle: 'Managers, trainers, roles, permissions',
        builder: () => const StaffSettingsScreen(),
      ),
      _SectionEntry(
        icon: Icons.security_rounded,
        title: 'Security',
        subtitle: 'Password, 2FA, sessions',
        builder: () => const SecuritySettingsScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                _BrandSummary(
                  gymName: info.gymName,
                  ownerName: info.ownerName,
                  logoUrl: info.logoUrl,
                ),
                const SizedBox(height: 20),
                for (final s in sections)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _SectionCard(
                      entry: s,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => s.builder()),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionEntry {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget Function() builder;

  const _SectionEntry({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.builder,
  });
}

class _BrandSummary extends StatelessWidget {
  final String gymName;
  final String ownerName;
  final String logoUrl;

  const _BrandSummary({
    required this.gymName,
    required this.ownerName,
    required this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BrandImage(
                reference: logoUrl,
                width: 56,
                height: 56,
                fallback: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.fitness_center_rounded,
                      color: Colors.white, size: 28),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gymName,
                    style: context.text.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ownerName,
                    style: context.text.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final _SectionEntry entry;
  final VoidCallback onTap;

  const _SectionCard({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(entry.icon, color: AppColors.primary),
        ),
        title: Text(entry.title, style: context.text.titleSmall),
        subtitle: Text(
          entry.subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
