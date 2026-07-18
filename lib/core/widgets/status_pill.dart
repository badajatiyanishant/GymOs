import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../../core/constants/enums.dart';

/// Small rounded pill showing a colored status label. Centralizes the color
/// mapping for membership and payment states so it's consistent everywhere.
class StatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const StatusPill({super.key, required this.label, required this.color});

  factory StatusPill.membership(MembershipStatus status) {
    final color = switch (status) {
      MembershipStatus.active => AppColors.success,
      MembershipStatus.expiringSoon => AppColors.warning,
      MembershipStatus.expired => AppColors.danger,
      MembershipStatus.frozen => AppColors.info,
    };
    return StatusPill(label: status.label, color: color);
  }

  factory StatusPill.payment(PaymentStatus status) {
    final color = switch (status) {
      PaymentStatus.paid => AppColors.success,
      PaymentStatus.partial => AppColors.warning,
      PaymentStatus.pending => AppColors.danger,
    };
    return StatusPill(label: status.label, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
