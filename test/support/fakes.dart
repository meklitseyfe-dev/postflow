import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:postflow/app/postflow_app.dart';
import 'package:postflow/features/auth/domain/app_user.dart';
import 'package:postflow/features/auth/domain/auth_failure.dart';
import 'package:postflow/features/auth/domain/auth_repository.dart';
import 'package:postflow/features/profile/domain/profile_repository.dart';
import 'package:postflow/features/profile/domain/user_profile.dart';

const testEmail = 'ada@example.com';
const testPassword = 'secret123';

AppUser userFor(String email) => AppUser(id: 'user-$email', email: email);

/// In-memory [AuthRepository] for tests.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({AppUser? signedInAs, this.requireEmailConfirmation = false})
    : _user = signedInAs;

  final bool requireEmailConfirmation;
  final Map<String, String> passwords = {testEmail: testPassword};
  final List<String> resetEmailsSent = [];
  final StreamController<AppUser?> _changes =
      StreamController<AppUser?>.broadcast();
  AppUser? _user;

  @override
  AppUser? get currentUser => _user;

  @override
  Stream<AppUser?> authStateChanges() => _changes.stream;

  void _emit(AppUser? user) {
    _user = user;
    _changes.add(user);
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    if (passwords[email] != password) {
      throw const AuthFailure('Incorrect email or password.');
    }
    _emit(userFor(email));
  }

  @override
  Future<SignUpResult> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    if (passwords.containsKey(email)) {
      throw const AuthFailure('An account with this email already exists.');
    }
    passwords[email] = password;
    if (requireEmailConfirmation) return SignUpResult.confirmationRequired;
    _emit(userFor(email));
    return SignUpResult.signedIn;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    resetEmailsSent.add(email);
  }

  @override
  Future<void> signOut() async => _emit(null);
}

/// In-memory [ProfileRepository] for tests.
class FakeProfileRepository implements ProfileRepository {
  final Map<String, UserProfile> profiles = {};

  @override
  Future<UserProfile?> fetchProfile(String userId) async => profiles[userId];

  @override
  Future<UserProfile> updateFullName(String userId, String fullName) async {
    final profile = UserProfile(id: userId, fullName: fullName);
    profiles[userId] = profile;
    return profile;
  }
}

Widget buildTestApp({
  required FakeAuthRepository auth,
  FakeProfileRepository? profiles,
}) => PostFlowApp(
  authRepository: auth,
  profileRepository: profiles ?? FakeProfileRepository(),
);
