import 'package:flutter/material.dart';
import 'package:postflow/core/constants/app_spacing.dart';
import 'package:postflow/core/theme/app_input_decoration.dart';
import 'package:postflow/core/utils/validators.dart';
import 'package:postflow/features/auth/domain/auth_failure.dart';
import 'package:postflow/features/auth/domain/auth_repository.dart';
import 'package:postflow/features/auth/presentation/widgets/auth_layout.dart';
import 'package:postflow/features/auth/presentation/widgets/auth_message_banner.dart';
import 'package:postflow/features/auth/presentation/widgets/password_field.dart';
import 'package:postflow/features/auth/presentation/widgets/submit_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.authRepository});

  static const Key nameFieldKey = Key('signUp.name');
  static const Key emailFieldKey = Key('signUp.email');
  static const Key passwordFieldKey = Key('signUp.password');
  static const Key confirmPasswordFieldKey = Key('signUp.confirmPassword');
  static const Key submitButtonKey = Key('signUp.submit');

  final AuthRepository authRepository;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _submitting = false;
  String? _error;
  String? _confirmationSentTo;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  String? _validateConfirmation(String? value) {
    if ((value ?? '').isEmpty) return 'Re-enter your password.';
    if (value != _password.text) return 'Passwords do not match.';
    return null;
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _error = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = _email.text.trim();
    setState(() => _submitting = true);
    try {
      final result = await widget.authRepository.signUp(
        email: email,
        password: _password.text,
        fullName: _name.text.trim(),
      );
      // When signed in straight away, the AuthGate closes this screen.
      if (result == SignUpResult.confirmationRequired && mounted) {
        setState(() => _confirmationSentTo = email);
      }
    } on AuthFailure catch (failure) {
      if (mounted) setState(() => _error = failure.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sentTo = _confirmationSentTo;
    if (sentTo != null) {
      return AuthLayout(
        title: 'Check your inbox',
        subtitle: 'One last step to activate your account.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthMessageBanner.success(
              message:
                  'We sent a confirmation link to $sentTo. Open it, then log '
                  'in to PostFlow.',
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back to log in'),
            ),
          ],
        ),
      );
    }

    final error = _error;
    return AuthLayout(
      title: 'Create your account',
      subtitle: 'Start planning content across all your channels.',
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Already have an account?'),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Log in'),
          ),
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
                key: SignUpScreen.nameFieldKey,
                controller: _name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                validator: Validators.fullName,
                decoration: AppInputDecoration.of(
                  context,
                  label: 'Full name',
                  icon: Icons.person_outline_rounded,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                key: SignUpScreen.emailFieldKey,
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
                key: SignUpScreen.passwordFieldKey,
                controller: _password,
                textInputAction: TextInputAction.next,
                validator: Validators.newPassword,
                autofillHints: const [AutofillHints.newPassword],
              ),
              const SizedBox(height: AppSpacing.lg),
              PasswordField(
                key: SignUpScreen.confirmPasswordFieldKey,
                controller: _confirmPassword,
                label: 'Confirm password',
                validator: _validateConfirmation,
                autofillHints: const [AutofillHints.newPassword],
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: AppSpacing.xl),
              SubmitButton(
                key: SignUpScreen.submitButtonKey,
                label: 'Create account',
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
