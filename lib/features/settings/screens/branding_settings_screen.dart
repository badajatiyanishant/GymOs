import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/extensions.dart';
import '../domain/appearance_settings.dart';
import '../providers/settings_providers.dart';
import '../widgets/image_field.dart';
import '../widgets/settings_scaffold.dart';

/// Curated palette owners can pick brand colours from. Keeps choices tasteful
/// and avoids shipping a full colour-wheel dependency.
const _palette = <int>[
  0xFF6C4DFF, 0xFF7C3AED, 0xFF2563EB, 0xFF0EA5E9,
  0xFF00E5A0, 0xFF10B981, 0xFFF59E0B, 0xFFEF4444,
  0xFFEC4899, 0xFF8B5CF6, 0xFF14B8A6, 0xFFCCFF00,
];

class BrandingSettingsScreen extends ConsumerStatefulWidget {
  const BrandingSettingsScreen({super.key});

  @override
  ConsumerState<BrandingSettingsScreen> createState() =>
      _BrandingSettingsScreenState();
}

class _BrandingSettingsScreenState
    extends ConsumerState<BrandingSettingsScreen> {
  late final AppearanceSettings _initial =
      ref.read(settingsControllerProvider).appearance;

  late int _primary = _initial.primaryColorValue;
  late int _secondary = _initial.secondaryColorValue;
  late AppThemeChoice _theme = _initial.themeChoice;
  late String _logo = _initial.appLogoUrl;
  late String _loginBg = _initial.loginBackgroundUrl;
  late String _banner = _initial.dashboardBannerUrl;

  void _save() {
    ref.read(settingsControllerProvider.notifier).updateAppearance(
          _initial.copyWith(
            primaryColorValue: _primary,
            secondaryColorValue: _secondary,
            themeChoice: _theme,
            appLogoUrl: _logo,
            loginBackgroundUrl: _loginBg,
            dashboardBannerUrl: _banner,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSectionScaffold(
      title: 'Branding',
      onSave: _save,
      children: [
        SettingsGroup(
          title: 'Colours',
          children: [
            _ColorPicker(
              label: 'Primary Colour',
              value: _primary,
              onChanged: (v) => setState(() => _primary = v),
            ),
            const SizedBox(height: 18),
            _ColorPicker(
              label: 'Secondary Colour',
              value: _secondary,
              onChanged: (v) => setState(() => _secondary = v),
            ),
          ],
        ),
        SettingsGroup(
          title: 'Theme',
          children: [
            SegmentedButton<AppThemeChoice>(
              segments: const [
                ButtonSegment(
                  value: AppThemeChoice.light,
                  label: Text('Light'),
                  icon: Icon(Icons.light_mode_rounded),
                ),
                ButtonSegment(
                  value: AppThemeChoice.dark,
                  label: Text('Dark'),
                  icon: Icon(Icons.dark_mode_rounded),
                ),
                ButtonSegment(
                  value: AppThemeChoice.system,
                  label: Text('System'),
                  icon: Icon(Icons.brightness_auto_rounded),
                ),
              ],
              selected: {_theme},
              onSelectionChanged: (s) => setState(() => _theme = s.first),
            ),
          ],
        ),
        SettingsGroup(
          title: 'Images',
          children: [
            ImageField(
              label: 'App Logo',
              reference: _logo,
              storagePath: 'branding/app-logo',
              onChanged: (v) => setState(() => _logo = v),
            ),
            const SizedBox(height: 16),
            ImageField(
              label: 'Login Background',
              reference: _loginBg,
              storagePath: 'branding/login-bg',
              aspectRatio: 3 / 4,
              onChanged: (v) => setState(() => _loginBg = v),
            ),
            const SizedBox(height: 16),
            ImageField(
              label: 'Dashboard Banner',
              reference: _banner,
              storagePath: 'branding/dashboard-banner',
              aspectRatio: 16 / 9,
              onChanged: (v) => setState(() => _banner = v),
            ),
          ],
        ),
      ],
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const _ColorPicker({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            label,
            style: context.text.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final c in _palette)
              _Swatch(
                color: Color(c),
                selected: c == value,
                onTap: () => onChanged(c),
              ),
          ],
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _Swatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: color.withValues(alpha: 0.6),
                blurRadius: 10,
                spreadRadius: 1,
              ),
          ],
        ),
        child: selected
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
            : null,
      ),
    );
  }
}
