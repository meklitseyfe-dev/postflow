import 'package:flutter/material.dart';
import 'package:postflow/app/app_shell.dart';
import 'package:postflow/core/constants/app_constants.dart';
import 'package:postflow/core/theme/app_theme.dart';
import 'package:postflow/features/auth/domain/auth_repository.dart';
import 'package:postflow/features/auth/presentation/auth_gate.dart';
import 'package:postflow/features/profile/domain/profile_repository.dart';

/// Root widget for PostFlow.
///
/// Repositories are injected so tests can run without Supabase.
class PostFlowApp extends StatelessWidget {
  const PostFlowApp({
    super.key,
    required this.authRepository,
    required this.profileRepository,
  });

  final AuthRepository authRepository;
  final ProfileRepository profileRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: AuthGate(
        authRepository: authRepository,
        signedInBuilder: (context, user) => AppShell(
          // A new user gets a fresh shell (tabs reset to Dashboard).
          key: ValueKey(user.id),
          user: user,
          authRepository: authRepository,
          profileRepository: profileRepository,
        ),
      ),
    );
  }
}
