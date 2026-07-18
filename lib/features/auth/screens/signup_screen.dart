import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/auth_scaffold.dart';
import '../../../core/widgets/gradient_button.dart';

/// Gym-owner registration form: full name, gym name, email, phone and a
/// matched password pair, gated behind a terms checkbox. Fully validated; the
/// demo submit routes straight to the dashboard.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _gymName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _loading = false;
  bool _agreed = false;

  @override
  void dispose() {
    _fullName.dispose();
    _gymName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? _confirmValidator(String? v) {
    if (v == null || v.isEmpty) return 'Confirm your password';
    if (v != _password.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreed) {
      context.showSnack('Please accept the Terms to continue', error: true);
      return;
    }
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _loading = false);
    context.go(RoutePaths.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBack: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const AuthHeader(
              title: 'Create your account',
              subtitle: 'Set up your gym in minutes',
            ),
            const SizedBox(height: 28),
            AppTextField(
              label: 'Full Name',
              hint: 'Arjun Mehta',
              icon: Icons.person_outline_rounded,
              controller: _fullName,
              textCapitalization: TextCapitalization.words,
              validator: (v) => Validators.requiredField(v, 'Full name'),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Gym Name',
              hint: 'Iron Forge Fitness',
              icon: Icons.fitness_center_rounded,
              controller: _gymName,
              textCapitalization: TextCapitalization.words,
              validator: (v) => Validators.requiredField(v, 'Gym name'),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Email',
              hint: 'you@gym.com',
              icon: Icons.mail_outline_rounded,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Phone',
              hint: '+91 98765 43210',
              icon: Icons.phone_outlined,
              controller: _phone,
              keyboardType: TextInputType.phone,
              validator: Validators.phone,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Password',
              hint: 'At least 6 characters',
              icon: Icons.lock_outline_rounded,
              controller: _password,
              obscure: true,
              validator: Validators.password,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Confirm Password',
              hint: 'Re-enter your password',
              icon: Icons.lock_outline_rounded,
              controller: _confirm,
              obscure: true,
              textInputAction: TextInputAction.done,
              validator: _confirmValidator,
            ),
            const SizedBox(height: 12),
            _TermsRow(
              value: _agreed,
              onChanged: (v) => setState(() => _agreed = v ?? false),
            ),
            const SizedBox(height: 16),
            GradientButton(
              label: 'Create Account',
              icon: Icons.check_rounded,
              loading: _loading,
              onPressed: _submit,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already registered?', style: context.text.bodyMedium),
                TextButton(
                  onPressed: () => context.go(RoutePaths.login),
                  child: const Text('Sign In'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _TermsRow({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: context.text.bodySmall,
              children: const [
                TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
