import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/enums.dart';
import '../../../core/widgets/app_text_field.dart';
import '../domain/payment_settings.dart';
import '../providers/settings_providers.dart';
import '../widgets/image_field.dart';
import '../widgets/settings_scaffold.dart';

class PaymentSettingsScreen extends ConsumerStatefulWidget {
  const PaymentSettingsScreen({super.key});

  @override
  ConsumerState<PaymentSettingsScreen> createState() =>
      _PaymentSettingsScreenState();
}

class _PaymentSettingsScreenState
    extends ConsumerState<PaymentSettingsScreen> {
  late final PaymentSettings _initial =
      ref.read(settingsControllerProvider).payment;

  late final Set<PaymentMethod> _methods = {..._initial.acceptedMethods};
  late final _upi = TextEditingController(text: _initial.upiId);
  late final _accName =
      TextEditingController(text: _initial.bankAccountName);
  late final _accNumber =
      TextEditingController(text: _initial.bankAccountNumber);
  late final _bankName = TextEditingController(text: _initial.bankName);
  late final _ifsc = TextEditingController(text: _initial.bankIfsc);
  late String _qr = _initial.qrImageUrl;

  @override
  void dispose() {
    for (final c in [_upi, _accName, _accNumber, _bankName, _ifsc]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    ref.read(settingsControllerProvider.notifier).updatePayment(
          _initial.copyWith(
            acceptedMethods: _methods,
            upiId: _upi.text.trim(),
            bankAccountName: _accName.text.trim(),
            bankAccountNumber: _accNumber.text.trim(),
            bankName: _bankName.text.trim(),
            bankIfsc: _ifsc.text.trim().toUpperCase(),
            qrImageUrl: _qr,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSectionScaffold(
      title: 'Payments',
      onSave: _save,
      children: [
        SettingsGroup(
          title: 'Accepted Methods',
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final m in PaymentMethod.values)
                  FilterChip(
                    label: Text(m.label),
                    selected: _methods.contains(m),
                    onSelected: (sel) => setState(() {
                      if (sel) {
                        _methods.add(m);
                      } else {
                        _methods.remove(m);
                      }
                    }),
                  ),
              ],
            ),
          ],
        ),
        SettingsGroup(
          title: 'UPI',
          children: [
            AppTextField(
              label: 'UPI ID',
              hint: 'name@bank',
              icon: Icons.qr_code_rounded,
              controller: _upi,
            ),
            const SizedBox(height: 16),
            ImageField(
              label: 'Payment QR Code',
              reference: _qr,
              storagePath: 'payments/qr',
              onChanged: (v) => setState(() => _qr = v),
            ),
          ],
        ),
        SettingsGroup(
          title: 'Bank Account',
          children: [
            AppTextField(
              label: 'Account Holder Name',
              hint: 'As per bank records',
              icon: Icons.account_balance_outlined,
              controller: _accName,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Account Number',
              hint: 'Bank account number',
              icon: Icons.numbers_rounded,
              controller: _accNumber,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Bank Name',
              hint: 'e.g. HDFC Bank',
              icon: Icons.account_balance_rounded,
              controller: _bankName,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'IFSC Code',
              hint: 'HDFC0001234',
              icon: Icons.tag_rounded,
              controller: _ifsc,
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
      ],
    );
  }
}
