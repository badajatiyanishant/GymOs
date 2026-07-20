import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/membership_settings.dart';
import '../providers/settings_providers.dart';
import '../widgets/settings_scaffold.dart';

class MembershipSettingsScreen extends ConsumerStatefulWidget {
  const MembershipSettingsScreen({super.key});

  @override
  ConsumerState<MembershipSettingsScreen> createState() =>
      _MembershipSettingsScreenState();
}

class _MembershipSettingsScreenState
    extends ConsumerState<MembershipSettingsScreen> {
  late final MembershipSettings _initial =
      ref.read(settingsControllerProvider).membership;

  late bool _trialEnabled = _initial.trialEnabled;
  late int _trialDays = _initial.trialDurationDays;
  late bool _autoExpiry = _initial.autoExpiry;
  late int _reminderDays = _initial.renewalReminderDays;

  void _save() {
    ref.read(settingsControllerProvider.notifier).updateMembership(
          _initial.copyWith(
            trialEnabled: _trialEnabled,
            trialDurationDays: _trialDays,
            autoExpiry: _autoExpiry,
            renewalReminderDays: _reminderDays,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSectionScaffold(
      title: 'Membership',
      onSave: _save,
      children: [
        SettingsGroup(
          title: 'Trial',
          children: [
            SettingsSwitch(
              icon: Icons.card_giftcard_rounded,
              label: 'Enable Free Trial',
              subtitle: 'Let new members try before they pay',
              value: _trialEnabled,
              onChanged: (v) => setState(() => _trialEnabled = v),
            ),
            if (_trialEnabled)
              _Stepper(
                label: 'Trial Duration',
                unit: 'days',
                value: _trialDays,
                min: 1,
                max: 90,
                onChanged: (v) => setState(() => _trialDays = v),
              ),
          ],
        ),
        SettingsGroup(
          title: 'Renewals',
          children: [
            SettingsSwitch(
              icon: Icons.event_busy_rounded,
              label: 'Auto Expiry',
              subtitle: 'Expire memberships automatically on end date',
              value: _autoExpiry,
              onChanged: (v) => setState(() => _autoExpiry = v),
            ),
            _Stepper(
              label: 'Renewal Reminder',
              unit: 'days before',
              value: _reminderDays,
              min: 0,
              max: 30,
              onChanged: (v) => setState(() => _reminderDays = v),
            ),
          ],
        ),
      ],
    );
  }
}

class _Stepper extends StatelessWidget {
  final String label;
  final String unit;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _Stepper({
    required this.label,
    required this.unit,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label),
                Text(
                  '$value $unit',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton.filledTonal(
            onPressed: value > min ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove_rounded),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            onPressed: value < max ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}
