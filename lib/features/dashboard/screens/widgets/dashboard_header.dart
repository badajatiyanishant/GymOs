import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/demo_dialogs.dart';
import '../../../settings/providers/settings_providers.dart';
import '../../../settings/widgets/image_field.dart';

/// Dashboard greeting header: gym logo mark, gym name, a welcome line and a
/// notifications action. Identity is read live from the settings provider.
class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(gymInfoProvider);
    final firstName =
        info.ownerName.trim().isEmpty ? '' : info.ownerName.trim().split(' ').first;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: BrandImage(
              reference: info.logoUrl,
              width: 46,
              height: 46,
              fallback: Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.fitness_center_rounded,
                    color: Colors.white, size: 24),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.gymName,
                  style: context.text.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  firstName.isEmpty
                      ? 'Welcome back 👋'
                      : 'Welcome back, $firstName 👋',
                  style: context.text.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _NotificationButton(onPressed: () => DemoDialogs.notifications(context)),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _NotificationButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton.filledTonal(
          onPressed: onPressed,
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            height: 9,
            width: 9,
            decoration: const BoxDecoration(
              color: AppColors.danger,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
