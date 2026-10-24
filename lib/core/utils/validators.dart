/// Form validators. Each returns an error message, or `null` when valid.
abstract final class Validators {
  static const int minPasswordLength = 8;
  static const int maxNameLength = 100;

  static final RegExp _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp _letter = RegExp(r'[A-Za-z]');
  static final RegExp _digit = RegExp(r'\d');

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Enter your email address.';
    if (!_email.hasMatch(email)) return 'Enter a valid email address.';
    return null;
  }

  /// For logging in: only checks that something was entered.
  static String? password(String? value) {
    if ((value ?? '').isEmpty) return 'Enter your password.';
    return null;
  }

  /// For creating a password: length plus a letter and a number.
  static String? newPassword(String? value) {
    final password = value ?? '';
    if (password.length < minPasswordLength) {
      return 'Use at least $minPasswordLength characters.';
    }
    if (!_letter.hasMatch(password) || !_digit.hasMatch(password)) {
      return 'Include at least one letter and one number.';
    }
    return null;
  }

  static String? fullName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Enter your name.';
    if (name.length > maxNameLength) {
      return 'Keep your name under $maxNameLength characters.';
    }
    return null;
  }
}
