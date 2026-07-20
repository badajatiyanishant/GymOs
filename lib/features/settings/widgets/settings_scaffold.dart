import 'package:flutter/material.dart';

import '../../../core/utils/extensions.dart';

/// Shared scaffold for a single settings section editor. Provides the app bar,
/// a scrollable, width-constrained body (readable on wide screens) and a pinned
/// "Save" bar. Children are laid out in a single column.
class SettingsSectionScaffold extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback onSave;
  final String saveLabel;

  const SettingsSectionScaffold({
    super.key,
    required this.title,
    required this.children,
    required this.onSave,
    this.saveLabel = 'Save changes',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                ...children,
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: () {
                    onSave();
                    context.showSnack('$title saved');
                    Navigator.of(context).maybePop();
                  },
                  icon: const Icon(Icons.check_rounded),
                  label: Text(saveLabel),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
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

/// A titled group card grouping related fields inside a section.
class SettingsGroup extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const SettingsGroup({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 10),
              child: Text(
                title!,
                style: context.text.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}

/// A labelled on/off row used across notification, membership and security
/// sections.
class SettingsSwitch extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;

  const SettingsSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      secondary: Icon(icon),
      title: Text(label, style: context.text.bodyLarge),
      subtitle: subtitle == null ? null : Text(subtitle!),
    );
  }
}
