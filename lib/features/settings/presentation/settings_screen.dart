import 'package:flutter/material.dart';
import 'package:postflow/core/constants/app_constants.dart';
import 'package:postflow/core/constants/app_spacing.dart';
import 'package:postflow/core/utils/initials.dart';
import 'package:postflow/core/widgets/section_header.dart';
import 'package:postflow/core/widgets/user_avatar.dart';
import 'package:postflow/features/auth/domain/app_user.dart';
import 'package:postflow/features/auth/domain/auth_repository.dart';
import 'package:postflow/features/auth/presentation/confirm_sign_out.dart';
import 'package:postflow/features/profile/domain/profile_repository.dart';
import 'package:postflow/features/profile/presentation/profile_screen.dart';

/// Account entry point (profile, log out) plus future app preferences.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.user,
    required this.authRepository,
    required this.profileRepository,
  });

  static const Key accountTileKey = Key('settings.account');
  static const Key signOutTileKey = Key('settings.signOut');

  final AppUser user;
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;

  void _openProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProfileScreen(
          user: user,
          profileRepository: profileRepository,
          authRepository: authRepository,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppConstants.maxContentWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionHeader(title: 'Account'),
                const SizedBox(height: AppSpacing.sm),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    key: accountTileKey,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.xs,
                    ),
                    leading: UserAvatar(
                      initials: Initials.from(email: user.email),
                      size: 40,
                    ),
                    title: Text(user.email ?? 'Your account'),
                    subtitle: const Text('View and edit your profile'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _openProfile(context),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const SectionHeader(title: 'Preferences'),
                const SizedBox(height: AppSpacing.sm),
                const Card(
                  child: ListTile(
                    enabled: false,
                    leading: Icon(Icons.tune_rounded),
                    title: Text('Notifications, appearance and time zone'),
                    subtitle: Text('Coming in an upcoming milestone'),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    key: signOutTileKey,
                    leading: Icon(Icons.logout_rounded, color: errorColor),
                    title: Text('Log out', style: TextStyle(color: errorColor)),
                    onTap: () => confirmAndSignOut(context, authRepository),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  '${AppConstants.appName} v${AppConstants.version}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
