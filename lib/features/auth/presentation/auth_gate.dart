import 'dart:async';

import 'package:flutter/material.dart';
import 'package:postflow/features/auth/domain/app_user.dart';
import 'package:postflow/features/auth/domain/auth_repository.dart';
import 'package:postflow/features/auth/presentation/login_screen.dart';

/// Shows the login flow when signed out and [signedInBuilder] when signed in.
///
/// When the user signs in or out, any screens pushed on top (sign-up,
/// forgot password, profile) are closed so the right root screen shows.
class AuthGate extends StatefulWidget {
  const AuthGate({
    super.key,
    required this.authRepository,
    required this.signedInBuilder,
  });

  final AuthRepository authRepository;
  final Widget Function(BuildContext context, AppUser user) signedInBuilder;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late AppUser? _user = widget.authRepository.currentUser;
  StreamSubscription<AppUser?>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.authRepository.authStateChanges().listen(
      _onAuthChanged,
    );
  }

  void _onAuthChanged(AppUser? user) {
    if (!mounted) return;
    final signedInChanged = (user == null) != (_user == null);
    setState(() => _user = user);
    if (signedInChanged) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    if (user == null) {
      return LoginScreen(authRepository: widget.authRepository);
    }
    return widget.signedInBuilder(context, user);
  }
}
