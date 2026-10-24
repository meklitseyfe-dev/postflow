import 'package:postflow/features/auth/domain/app_user.dart';
import 'package:postflow/features/auth/domain/auth_failure.dart';
import 'package:postflow/features/auth/domain/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

/// [AuthRepository] backed by Supabase Auth (email + password).
class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final supa.SupabaseClient _client;

  supa.GoTrueClient get _auth => _client.auth;

  static const String _genericMessage =
      'Something went wrong. Check your connection and try again.';

  @override
  AppUser? get currentUser => _toAppUser(_auth.currentUser);

  @override
  Stream<AppUser?> authStateChanges() =>
      _auth.onAuthStateChange.map((state) => _toAppUser(state.session?.user));

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _guard(
      () => _auth.signInWithPassword(email: email, password: password),
    );
  }

  @override
  Future<SignUpResult> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final response = await _guard(
      () => _auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      ),
    );
    return response.session == null
        ? SignUpResult.confirmationRequired
        : SignUpResult.signedIn;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _guard(() => _auth.resetPasswordForEmail(email));
  }

  @override
  Future<void> signOut() async {
    await _guard(() => _auth.signOut());
  }

  static AppUser? _toAppUser(supa.User? user) =>
      user == null ? null : AppUser(id: user.id, email: user.email);

  static Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on supa.AuthException catch (error) {
      throw AuthFailure(_messageFor(error));
    } on Exception {
      throw const AuthFailure(_genericMessage);
    }
  }

  static String _messageFor(supa.AuthException error) => switch (error.code) {
    'invalid_credentials' => 'Incorrect email or password.',
    'email_not_confirmed' => 'Please confirm your email address, then log in.',
    'user_already_exists' => 'An account with this email already exists.',
    'weak_password' => 'Please choose a stronger password.',
    'over_email_send_rate_limit' =>
      'Too many emails sent. Please wait a few minutes and try again.',
    _ => error.message.isEmpty ? _genericMessage : error.message,
  };
}
