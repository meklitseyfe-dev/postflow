import 'package:postflow/features/auth/domain/app_user.dart';

/// What happened after a successful sign-up request.
enum SignUpResult {
  /// The user is signed in straight away.
  signedIn,

  /// The user must confirm their email before logging in.
  confirmationRequired,
}

/// Authentication operations used by the app.
///
/// Methods throw `AuthFailure` with a user-facing message on error.
abstract interface class AuthRepository {
  AppUser? get currentUser;

  /// Emits the current user whenever the auth state changes.
  Stream<AppUser?> authStateChanges();

  Future<void> signIn({required String email, required String password});

  Future<SignUpResult> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<void> signOut();
}
