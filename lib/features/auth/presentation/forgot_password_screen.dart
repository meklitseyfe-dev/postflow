import 'package:flutter/material.dart';
import 'package:postflow/core/constants/app_spacing.dart';
import 'package:postflow/core/theme/app_input_decoration.dart';
import 'package:postflow/core/utils/validators.dart';
import 'package:postflow/features/auth/domain/auth_failure.dart';
import 'package:postflow/features/auth/domain/auth_repository.dart';
import 'package:postflow/features/auth/presentation/widgets/auth_layout.dart';
import 'package:postflow/features/auth/presentation/widgets/auth_message_banner.dart';
import 'package:postflow/features/auth/presentation/widgets/submit_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
    required this.authRepository,
    this.initialEmail = '',
  });

  static const Key emailFieldKey = Key('forgotPassword.email');
  static const Key submitButtonKey = Key('forgotPassword.submit');

  final AuthRepository authRepository;
  final String initialEmail;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _email = TextEditingController(text: widget.initialEmail);
  bool _submitting = false;
  String? _error;
  String? _sentTo;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _error = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = _email.text.trim();
    setState(() => _submitting = true);
    try {
      await widget.authRepository.sendPasswordResetEmail(email);
      if (mounted) setState(() => _sentTo = email);
    } on AuthFailure catch (failure) {
      if (mounted) setState(() => _error = failure.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sentTo = _sentTo;
    if (sentTo != null) {
      return AuthLayout(
        title: 'Check your email',
        subtitle: 'Follow the link in the email to choose a new password.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthMessageBanner.success(
              message:
                  'If an account exists for $sentTo, a password reset link '
                  'is on its way.',
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
      title: 'Reset your password',
      subtitle: "Enter your account email and we'll send you a reset link.",
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (error != null) ...[
              AuthMessageBanner.error(message: error),
              const SizedBox(height: AppSpacing.lg),
            ],
            TextFormField(
              key: ForgotPasswordScreen.emailFieldKey,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              validator: Validators.email,
              onFieldSubmitted: (_) => _submit(),
              decoration: AppInputDecoration.of(
                context,
                label: 'Email',
                icon: Icons.mail_outline_rounded,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SubmitButton(
              key: ForgotPasswordScreen.submitButtonKey,
              label: 'Send reset link',
              busy: _submitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
