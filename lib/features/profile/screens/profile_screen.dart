import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../demo/demo_data.dart';

/// Owner profile: identity header, a grouped settings list, a dark-mode toggle
/// wired to the real theme controller, and logout (routes back to login).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && context.isDark);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            Text('Profile', style: context.text.headlineSmall),
            const SizedBox(height: 20),
            _ProfileCard(),
            const SizedBox(height: 20),
            _Group(
              title: 'Account',
              children: [
                _SettingsTile(
                  icon: Icons.business_rounded,
                  label: 'Gym Details',
                  onTap: () => context.showSnack('Gym Details — coming soon'),
                ),
                _SettingsTile(
                  icon: Icons.card_membership_rounded,
                  label: 'Membership Plans',
                  onTap: () => context.showSnack('Plans — coming soon'),
                ),
                _SettingsTile(
                  icon: Icons.people_alt_rounded,
                  label: 'Staff & Trainers',
                  onTap: () => context.showSnack('Staff — coming soon'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _Group(
              title: 'Preferences',
              children: [
                _SettingsTile(
                  icon: isDark
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  label: 'Dark Mode',
                  trailing: Switch(
                    value: isDark,
                    activeThumbColor: AppColors.primary,
                    onChanged: (_) =>
                        ref.read(themeControllerProvider.notifier).toggle(),
                  ),
                ),
                _SettingsTile(
                  icon: Icons.notifications_none_rounded,
                  label: 'Notifications',
                  onTap: () =>
                      context.showSnack('Notifications — coming soon'),
                ),
                _SettingsTile(
                  icon: Icons.help_outline_rounded,
                  label: 'Help & Support',
                  onTap: () => context.showSnack('Support — coming soon'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => context.go(RoutePaths.login),
              icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
              label: const Text('Logout',
                  style: TextStyle(color: AppColors.danger)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color: AppColors.danger.withValues(alpha: 0.5)),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text('GymPro v1.0.0', style: context.text.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          const UserAvatar(name: DemoData.ownerName, radius: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DemoData.ownerName, style: context.text.titleMedium),
                const SizedBox(height: 2),
                Text(DemoData.ownerEmail, style: context.text.bodySmall),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Gym Owner',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Group({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title,
            style: context.text.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1)
                  Divider(
                    height: 1,
                    indent: 56,
                    color: Theme.of(context).dividerTheme.color,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(label, style: context.text.bodyLarge),
      trailing: trailing ??
          (onTap != null
              ? Icon(Icons.chevron_right_rounded,
                  color: context.text.bodySmall?.color)
              : null),
    );
  }
}
