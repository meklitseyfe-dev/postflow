import 'package:flutter_test/flutter_test.dart';
import 'package:postflow/core/utils/initials.dart';
import 'package:postflow/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('rejects empty and malformed addresses', () {
      expect(Validators.email(''), 'Enter your email address.');
      expect(Validators.email('   '), 'Enter your email address.');
      expect(Validators.email('ada'), 'Enter a valid email address.');
      expect(Validators.email('ada@example'), 'Enter a valid email address.');
    });

    test('accepts valid addresses, ignoring surrounding spaces', () {
      expect(Validators.email('ada@example.com'), isNull);
      expect(Validators.email('  ada@example.com '), isNull);
    });
  });

  group('Validators.newPassword', () {
    test('requires length, a letter and a number', () {
      expect(Validators.newPassword('abc1'), 'Use at least 8 characters.');
      expect(
        Validators.newPassword('abcdefgh'),
        'Include at least one letter and one number.',
      );
      expect(
        Validators.newPassword('12345678'),
        'Include at least one letter and one number.',
      );
      expect(Validators.newPassword('compiler42'), isNull);
    });
  });

  group('Validators.fullName', () {
    test('requires a name under the length limit', () {
      expect(Validators.fullName('  '), 'Enter your name.');
      expect(Validators.fullName('a' * 101), isNotNull);
      expect(Validators.fullName('Ada Lovelace'), isNull);
    });
  });

  group('Initials.from', () {
    test('uses first and last name', () {
      expect(Initials.from(name: 'ada lovelace'), 'AL');
      expect(Initials.from(name: 'Grace Brewster Hopper'), 'GH');
      expect(Initials.from(name: 'Ada'), 'A');
    });

    test('falls back to email, then a placeholder', () {
      expect(Initials.from(name: ' ', email: 'ada@example.com'), 'A');
      expect(Initials.from(), '?');
    });
  });
}
