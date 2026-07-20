import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/notification_settings.dart';
import '../providers/settings_providers.dart';
import '../widgets/settings_scaffold.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  late final NotificationSettings _initial =
      ref.read(settingsControllerProvider).notification;

  late bool _sms = _initial.smsEnabled;
  late bool _whatsapp = _initial.whatsappEnabled;
  late bool _email = _initial.emailEnabled;
  late bool _push = _initial.pushEnabled;

  void _save() {
    ref.read(settingsControllerProvider.notifier).updateNotification(
          _initial.copyWith(
            smsEnabled: _sms,
            whatsappEnabled: _whatsapp,
            emailEnabled: _email,
            pushEnabled: _push,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSectionScaffold(
      title: 'Notifications',
      onSave: _save,
      children: [
        SettingsGroup(
          title: 'Channels',
          children: [
            SettingsSwitch(
              icon: Icons.sms_outlined,
              label: 'SMS',
              subtitle: 'Text-message alerts',
              value: _sms,
              onChanged: (v) => setState(() => _sms = v),
            ),
            SettingsSwitch(
              icon: Icons.chat_outlined,
              label: 'WhatsApp',
              subtitle: 'Reminders and receipts on WhatsApp',
              value: _whatsapp,
              onChanged: (v) => setState(() => _whatsapp = v),
            ),
            SettingsSwitch(
              icon: Icons.mail_outline_rounded,
              label: 'Email',
              subtitle: 'Invoices and updates by email',
              value: _email,
              onChanged: (v) => setState(() => _email = v),
            ),
            SettingsSwitch(
              icon: Icons.notifications_active_outlined,
              label: 'Push',
              subtitle: 'In-app push notifications',
              value: _push,
              onChanged: (v) => setState(() => _push = v),
            ),
          ],
        ),
      ],
    );
  }
}
