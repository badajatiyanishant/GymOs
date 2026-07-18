import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/extensions.dart';
import '../utils/validators.dart';
import 'app_text_field.dart';
import 'gradient_button.dart';

/// Reusable, polished demo dialogs and sheets. They don't persist anything —
/// they exist so every button in the prototype leads somewhere that feels real
/// during a walkthrough.
class DemoDialogs {
  DemoDialogs._();

  /// Bottom sheet with a small "Add Member" form. On submit it closes and
  /// confirms with a snackbar (no data is stored).
  static Future<void> addMember(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => const _AddMemberSheet(),
    );
  }

  /// Notifications preview sheet with a few realistic demo items.
  static Future<void> notifications(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => const _NotificationsSheet(),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerTheme.color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _AddMemberSheet extends StatefulWidget {
  const _AddMemberSheet();

  @override
  State<_AddMemberSheet> createState() => _AddMemberSheetState();
}

class _AddMemberSheetState extends State<_AddMemberSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    final name = _name.text.trim();
    Navigator.of(context).pop();
    context.showSnack('$name added to members');
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: _SheetHandle()),
            Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person_add_alt_1_rounded,
                      color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Text('New Member', style: context.text.titleMedium),
              ],
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Full Name',
              hint: 'e.g. Rohan Sharma',
              icon: Icons.person_outline_rounded,
              controller: _name,
              textCapitalization: TextCapitalization.words,
              validator: (v) => Validators.requiredField(v, 'Name'),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Phone',
              hint: '+91 98765 43210',
              icon: Icons.phone_outlined,
              controller: _phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              validator: Validators.phone,
            ),
            const SizedBox(height: 24),
            GradientButton(
              label: 'Add Member',
              icon: Icons.check_rounded,
              loading: _saving,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsSheet extends StatelessWidget {
  const _NotificationsSheet();

  static const _items = [
    _Notif('Ananya Rao', 'Membership expires in 3 days',
        Icons.warning_amber_rounded, AppColors.warning),
    _Notif('Payment received', 'Rohan Sharma paid ₹4,500',
        Icons.payments_rounded, AppColors.success),
    _Notif('New sign-up', 'Divya Menon joined today',
        Icons.person_add_alt_1_rounded, AppColors.primary),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(child: _SheetHandle()),
            Text('Notifications', style: context.text.titleMedium),
            const SizedBox(height: 12),
            for (final n in _items)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: n.color.withValues(alpha: 0.14),
                  child: Icon(n.icon, color: n.color, size: 20),
                ),
                title: Text(n.title, style: context.text.bodyLarge),
                subtitle: Text(n.subtitle, style: context.text.bodySmall),
              ),
          ],
        ),
      ),
    );
  }
}

class _Notif {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  const _Notif(this.title, this.subtitle, this.icon, this.color);
}
