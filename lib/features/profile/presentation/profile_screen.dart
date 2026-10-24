import 'package:flutter/material.dart';
import 'package:postflow/core/constants/app_spacing.dart';
import 'package:postflow/core/theme/app_input_decoration.dart';
import 'package:postflow/core/utils/initials.dart';
import 'package:postflow/core/utils/validators.dart';
import 'package:postflow/core/widgets/user_avatar.dart';
import 'package:postflow/features/auth/domain/app_user.dart';
import 'package:postflow/features/auth/domain/auth_repository.dart';
import 'package:postflow/features/auth/presentation/confirm_sign_out.dart';
import 'package:postflow/features/profile/domain/profile_repository.dart';
import 'package:postflow/features/profile/domain/user_profile.dart';

/// Shows the signed-in user's profile and lets them edit their name.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.user,
    required this.profileRepository,
    required this.authRepository,
  });

  static const Key nameFieldKey = Key('profile.name');
  static const Key saveButtonKey = Key('profile.save');
  static const Key signOutButtonKey = Key('profile.signOut');

  final AppUser user;
  final ProfileRepository profileRepository;
  final AuthRepository authRepository;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  UserProfile? _profile;
  bool _loading = true;
  bool _saving = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final profile = await widget.profileRepository.fetchProfile(
        widget.user.id,
      );
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _name.text = profile?.fullName ?? '';
        _loading = false;
      });
    } on ProfileFailure catch (failure) {
      if (!mounted) return;
      setState(() {
        _loadError = failure.message;
        _loading = false;
      });
    }
  }

  void _retry() {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    _load();
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);
    try {
      final updated = await widget.profileRepository.updateFullName(
        widget.user.id,
        _name.text.trim(),
      );
      if (!mounted) return;
      setState(() => _profile = updated);
      _showMessage('Profile updated');
    } on ProfileFailure catch (failure) {
      if (!mounted) return;
      _showMessage(failure.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final theme = Theme.of(context);
    final loadError = _loadError;
    if (loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loadError,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton(onPressed: _retry, child: const Text('Try again')),
            ],
          ),
        ),
      );
    }

    final email = widget.user.email;
    final initials = Initials.from(name: _profile?.fullName, email: email);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              Center(child: UserAvatar(initials: initials, size: 80)),
              const SizedBox(height: AppSpacing.md),
              if (email != null)
                Text(
                  email,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Personal details',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextFormField(
                          key: ProfileScreen.nameFieldKey,
                          controller: _name,
                          textCapitalization: TextCapitalization.words,
                          validator: Validators.fullName,
                          onFieldSubmitted: (_) => _save(),
                          decoration: AppInputDecoration.of(
                            context,
                            label: 'Full name',
                            icon: Icons.person_outline_rounded,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        FilledButton(
                          key: ProfileScreen.saveButtonKey,
                          onPressed: _saving ? null : _save,
                          child: Text(_saving ? 'Saving…' : 'Save changes'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                key: ProfileScreen.signOutButtonKey,
                onPressed: () =>
                    confirmAndSignOut(context, widget.authRepository),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Log out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
