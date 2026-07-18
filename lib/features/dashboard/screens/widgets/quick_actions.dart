import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/demo_dialogs.dart';
import '../../../../core/widgets/glass_card.dart';

/// The four primary owner shortcuts (Add Member, Scan QR, Collect Payment, Add
/// Trainer) rendered as a responsive grid of tappable tiles.
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  static const _actions = [
    _Action('Add Member', Icons.person_add_alt_1_rounded, AppColors.primary),
    _Action('Scan QR', Icons.qr_code_scanner_rounded, AppColors.secondary),
    _Action('Collect Payment', Icons.account_balance_wallet_rounded,
        AppColors.info),
    _Action('Add Trainer', Icons.sports_gymnastics_rounded, AppColors.warning),
  ];

  void _handle(BuildContext context, _Action action) {
    if (action.label == 'Add Member') {
      DemoDialogs.addMember(context);
    } else {
      context.showSnack('${action.label} — coming soon');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.82,
      children: [
        for (final a in _actions)
          _ActionTile(
            action: a,
            onTap: () => _handle(context, a),
          ),
      ],
    );
  }
}

class _Action {
  final String label;
  final IconData icon;
  final Color color;
  const _Action(this.label, this.icon, this.color);
}

class _ActionTile extends StatelessWidget {
  final _Action action;
  final VoidCallback onTap;

  const _ActionTile({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: action.color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(action.icon, color: action.color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            action.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.text.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
