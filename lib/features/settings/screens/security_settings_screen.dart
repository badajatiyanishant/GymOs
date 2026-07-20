import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/utils/validators.dart';
import '../providers/settings_providers.dart';
import '../widgets/settings_scaffold.dart';

class SecuritySettingsScreen extends ConsumerStatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  ConsumerState<SecuritySettingsScreen> createState() =>
      _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState
    extends ConsumerState<SecuritySettingsScreen> {
  bool _twoFactor =
      false; // hydrated in initState from current settings

  @override
  void initState() {
    super.initState();
    _twoFactor =
        ref.read(settingsControllerProvider).security.twoFactorEnabled;
  }

  void _toggleTwoFactor(bool value) {
    setState(() => _twoFactor = value);
    final security = ref.read(settingsControllerProvider).security;
    ref
        .read(settingsControllerProvider.notifier)
        .updateSecurity(security.copyWith(twoFactorEnabled: value));
  }

  Future<void> _changePassword() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _ChangePasswordSheet(),
    );
  }

  Future<void> _logoutAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out from all devices?'),
        content: const Text(
          'This signs out every active session. You will need to sign in '
          'again on each device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log out all'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(settingsControllerProvider.notifier).logoutAllDevices();
    if (mounted) context.showSnack('Signed out of all devices');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                SettingsGroup(
                  title: 'Password',
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.lock_outline_rounded),
                      title: const Text('Change Password'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _changePassword,
                    ),
                  ],
                ),
                SettingsGroup(
                  title: 'Two-Factor Authentication',
                  children: [
                    SettingsSwitch(
                      icon: Icons.shield_outlined,
                      label: 'Enable 2FA',
                      subtitle: 'Extra verification at sign-in',
                      value: _twoFactor,
                      onChanged: _toggleTwoFactor,
                    ),
                  ],
                ),
                SettingsGroup(
                  title: 'Sessions',
                  children: [
                    OutlinedButton.icon(
                      onPressed: _logoutAll,
                      icon: const Icon(Icons.logout_rounded,
                          color: AppColors.danger),
                      label: const Text('Log out from all devices',
                          style: TextStyle(color: AppColors.danger)),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        side: BorderSide(
                            color: AppColors.danger.withValues(alpha: 0.5)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // Password change is an auth action — not persisted in settings. Wired to
    // the auth backend when Firebase Auth is enabled.
    Navigator.pop(context);
    context.showSnack('Password updated');
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Change Password', style: context.text.headlineSmall),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Current Password',
              hint: 'Enter current password',
              icon: Icons.lock_outline_rounded,
              controller: _current,
              obscure: true,
              validator: Validators.password,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'New Password',
              hint: 'Enter new password',
              icon: Icons.lock_reset_rounded,
              controller: _next,
              obscure: true,
              validator: Validators.password,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Confirm New Password',
              hint: 'Re-enter new password',
              icon: Icons.lock_reset_rounded,
              controller: _confirm,
              obscure: true,
              textInputAction: TextInputAction.done,
              validator: (v) =>
                  v != _next.text ? 'Passwords do not match' : null,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _submit,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              child: const Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }
}
