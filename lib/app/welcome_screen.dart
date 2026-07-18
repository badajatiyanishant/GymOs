import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/theme_controller.dart';
import '../core/utils/extensions.dart';
import '../core/widgets/glass_card.dart';
import '../core/widgets/gradient_button.dart';

/// Core-stage landing screen.
///
/// It exists so Feature 1 is runnable and demonstrates the theme, glass
/// surfaces, gradient button and dark-mode toggle end to end. Feature 2 (Auth)
/// replaces this as the app's entry flow.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final isDarkMode = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && context.isDark);

    return Scaffold(
      body: Stack(
        children: [
          // Decorative brand glow behind the frosted glass.
          Positioned(
            top: -80,
            right: -60,
            child: _Blob(color: AppColors.primary.withValues(alpha: 0.45)),
          ),
          Positioned(
            bottom: -100,
            left: -70,
            child: _Blob(color: AppColors.secondary.withValues(alpha: 0.35)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton.filledTonal(
                      onPressed: () =>
                          ref.read(themeControllerProvider.notifier).toggle(),
                      icon: Icon(isDarkMode
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Container(
                      height: 96,
                      width: 96,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.fitness_center_rounded,
                          color: Colors.white, size: 50),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    AppConstants.appName,
                    textAlign: TextAlign.center,
                    style: context.text.displayLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppConstants.appTagline,
                    textAlign: TextAlign.center,
                    style: context.text.bodyLarge
                        ?.copyWith(color: context.colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 32),
                  const GlassCard(
                    child: Column(
                      children: [
                        _FeatureRow(
                          icon: Icons.groups_rounded,
                          text: 'Members, plans & payments in one place',
                        ),
                        SizedBox(height: 14),
                        _FeatureRow(
                          icon: Icons.qr_code_scanner_rounded,
                          text: 'QR attendance & smart check-ins',
                        ),
                        SizedBox(height: 14),
                        _FeatureRow(
                          icon: Icons.insights_rounded,
                          text: 'Revenue & growth analytics',
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GradientButton(
                    label: 'Get Started',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () => context
                        .showSnack('Authentication arrives in Feature 2'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'v1.0.0 • Core ready',
                    textAlign: TextAlign.center,
                    style: context.text.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(child: Text(text, style: context.text.bodyMedium)),
      ],
    );
  }
}

/// Soft blurred color blob used purely for background decoration.
class _Blob extends StatelessWidget {
  final Color color;
  const _Blob({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: 240,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}
