import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/router/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/auth_scaffold.dart';
import '../../../core/widgets/google_button.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../settings/providers/settings_providers.dart';
import '../data/auth_repository.dart';
import '../providers/auth_providers.dart';

/// Email/password login with validation, a loading state, Remember Me and
/// links out to signup and password reset. Signs in through the
/// [AuthRepository]; on success routes to the signed-in role's home.
/// Branding (logo + gym name) is read from the settings provider so the login
/// screen reflects the owner's identity.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  bool _rememberMe = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final user = await ref.read(authControllerProvider).signIn(
            email: _email.text,
            password: _password.text,
            rememberMe: _rememberMe,
          );
      if (!mounted) return;
      context.go(homeForRole(user.role));
    } on AuthException catch (e) {
      if (!mounted) return;
      context.showSnack(e.message, error: true);
    } catch (_) {
      if (!mounted) return;
      context.showSnack('Sign in failed. Please try again.', error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = ref.watch(gymInfoProvider);
    final appearance = ref.watch(appearanceProvider);
    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthHeader(
              title: 'Welcome back',
              subtitle: 'Sign in to manage ${info.gymName}',
              logoReference: appearance.appLogoUrl.isNotEmpty
                  ? appearance.appLogoUrl
                  : info.logoUrl,
            ),
            const SizedBox(height: 32),
            AppTextField(
              label: 'Email',
              hint: 'you@gym.com',
              icon: Icons.mail_outline_rounded,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: 18),
            AppTextField(
              label: 'Password',
              hint: 'Enter your password',
              icon: Icons.lock_outline_rounded,
              controller: _password,
              obscure: true,
              textInputAction: TextInputAction.done,
              validator: Validators.password,
              onSubmitted: (_) => _submit(),
            ),
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _rememberMe,
                    onChanged: (v) => setState(() => _rememberMe = v ?? true),
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _rememberMe = !_rememberMe),
                    child: Text('Remember me', style: context.text.bodyMedium),
                  ),
                ),
                TextButton(
                  onPressed: () => context.push(RoutePaths.forgotPassword),
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            GradientButton(
              label: 'Sign In',
              icon: Icons.arrow_forward_rounded,
              loading: _loading,
              onPressed: _submit,
            ),
            const SizedBox(height: 20),
            const _OrDivider(),
            const SizedBox(height: 20),
            GoogleButton(
              onPressed: () async {
                setState(() => _loading = true);

                try {
                  final user =
                      await ref.read(authControllerProvider).signInWithGoogle();

                  if (!mounted || user == null) return;

                  context.go(homeForRole(user.role));
                } on AuthException catch (e) {
                  if (!mounted) return;
                  context.showSnack(e.message, error: true);
                } catch (_) {
                  if (!mounted) return;
                  context.showSnack(
                    'Google sign-in failed.',
                    error: true,
                  );
                } finally {
                  if (mounted) setState(() => _loading = false);
                }
              },
            ),
            const SizedBox(height: 28),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: context.text.bodyMedium,
                ),
                TextButton(
                  onPressed: () => context.push(RoutePaths.signup),
                  child: const Text('Create Account'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// "or" separator with hairlines on each side, shared by the auth forms.
class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).dividerTheme.color;
    return Row(
      children: [
        Expanded(child: Divider(color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('or', style: context.text.bodySmall),
        ),
        Expanded(child: Divider(color: color)),
      ],
    );
  }
}
