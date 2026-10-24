import 'package:flutter/material.dart';
import 'package:postflow/core/constants/app_spacing.dart';
import 'package:postflow/core/theme/app_input_decoration.dart';
import 'package:postflow/core/utils/validators.dart';
import 'package:postflow/features/auth/domain/auth_failure.dart';
import 'package:postflow/features/auth/domain/auth_repository.dart';
import 'package:postflow/features/auth/presentation/forgot_password_screen.dart';
import 'package:postflow/features/auth/presentation/sign_up_screen.dart';
import 'package:postflow/features/auth/presentation/widgets/auth_layout.dart';
import 'package:postflow/features/auth/presentation/widgets/auth_message_banner.dart';
import 'package:postflow/features/auth/presentation/widgets/password_field.dart';
import 'package:postflow/features/auth/presentation/widgets/submit_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.authRepository});

  static const Key emailFieldKey = Key('login.email');
  static const Key passwordFieldKey = Key('login.password');
  static const Key submitButtonKey = Key('login.submit');

  final AuthRepository authRepository;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _error = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    try {
      // On success the AuthGate swaps this screen for the app.
      await widget.authRepository.signIn(
        email: _email.text.trim(),
        password: _password.text,
      );
    } on AuthFailure catch (failure) {
      if (mounted) setState(() => _error = failure.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _openSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SignUpScreen(authRepository: widget.authRepository),
      ),
    );
  }

  void _openForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ForgotPasswordScreen(
          authRepository: widget.authRepository,
          initialEmail: _email.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;

    return AuthLayout(
      title: 'Welcome back',
      subtitle: 'Log in to plan and schedule your posts.',
      footer: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text("Don't have an account?"),
          TextButton(onPressed: _openSignUp, child: const Text('Sign up')),
        ],
      ),
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (error != null) ...[
                AuthMessageBanner.error(message: error),
                const SizedBox(height: AppSpacing.lg),
              ],
              TextFormField(
                key: LoginScreen.emailFieldKey,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: Validators.email,
                decoration: AppInputDecoration.of(
                  context,
                  label: 'Email',
                  icon: Icons.mail_outline_rounded,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PasswordField(
                key: LoginScreen.passwordFieldKey,
                controller: _password,
                validator: Validators.password,
                onSubmitted: (_) => _submit(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _openForgotPassword,
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SubmitButton(
                key: LoginScreen.submitButtonKey,
                label: 'Log in',
                busy: _submitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
