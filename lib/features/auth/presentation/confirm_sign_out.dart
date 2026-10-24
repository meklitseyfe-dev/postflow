import 'package:flutter/material.dart';
import 'package:postflow/features/auth/domain/auth_failure.dart';
import 'package:postflow/features/auth/domain/auth_repository.dart';

/// Asks the user to confirm, then signs out.
///
/// On success the AuthGate returns the app to the login screen.
Future<void> confirmAndSignOut(
  BuildContext context,
  AuthRepository authRepository,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Log out?'),
      content: const Text("You'll need to log in again to manage your posts."),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Log out'),
        ),
      ],
    ),
  );
  if (confirmed != true) return;

  try {
    await authRepository.signOut();
  } on AuthFailure catch (failure) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(failure.message)));
  }
}
