import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_text_field.dart';
import '../domain/business_settings.dart';
import '../providers/settings_providers.dart';
import '../widgets/settings_scaffold.dart';

class BusinessSettingsScreen extends ConsumerStatefulWidget {
  const BusinessSettingsScreen({super.key});

  @override
  ConsumerState<BusinessSettingsScreen> createState() =>
      _BusinessSettingsScreenState();
}

class _BusinessSettingsScreenState
    extends ConsumerState<BusinessSettingsScreen> {
  late final BusinessSettings _initial =
      ref.read(settingsControllerProvider).business;

  late final _gst = TextEditingController(text: _initial.gstNumber);
  late final _pan = TextEditingController(text: _initial.panNumber);
  late final _prefix = TextEditingController(text: _initial.invoicePrefix);
  late final _currency = TextEditingController(text: _initial.currencyCode);
  late final _timeZone = TextEditingController(text: _initial.timeZone);

  @override
  void dispose() {
    for (final c in [_gst, _pan, _prefix, _currency, _timeZone]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    ref.read(settingsControllerProvider.notifier).updateBusiness(
          _initial.copyWith(
            gstNumber: _gst.text.trim(),
            panNumber: _pan.text.trim(),
            invoicePrefix: _prefix.text.trim(),
            currencyCode: _currency.text.trim().toUpperCase(),
            timeZone: _timeZone.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSectionScaffold(
      title: 'Business',
      onSave: _save,
      children: [
        SettingsGroup(
          title: 'Legal',
          children: [
            AppTextField(
              label: 'GST Number',
              hint: '22AAAAA0000A1Z5',
              icon: Icons.receipt_long_outlined,
              controller: _gst,
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'PAN Number',
              hint: 'ABCDE1234F',
              icon: Icons.badge_outlined,
              controller: _pan,
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        SettingsGroup(
          title: 'Billing',
          children: [
            AppTextField(
              label: 'Invoice Prefix',
              hint: 'INV',
              icon: Icons.tag_rounded,
              controller: _prefix,
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Currency Code',
              hint: 'INR',
              icon: Icons.currency_rupee_rounded,
              controller: _currency,
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Time Zone',
              hint: 'Asia/Kolkata',
              icon: Icons.public_rounded,
              controller: _timeZone,
            ),
          ],
        ),
      ],
    );
  }
}
