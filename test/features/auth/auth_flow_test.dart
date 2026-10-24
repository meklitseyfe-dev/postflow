import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postflow/features/auth/presentation/forgot_password_screen.dart';
import 'package:postflow/features/auth/presentation/login_screen.dart';
import 'package:postflow/features/auth/presentation/sign_up_screen.dart';
import 'package:postflow/features/settings/presentation/settings_screen.dart';

import '../../support/fakes.dart';
import '../../support/test_helpers.dart';

void main() {
  Future<void> logIn(WidgetTester tester, String email, String password) async {
    await enterField(tester, fieldWithKey(LoginScreen.emailFieldKey), email);
    await enterField(
      tester,
      fieldWithKey(LoginScreen.passwordFieldKey),
      password,
    );
    await tapAndSettle(tester, find.byKey(LoginScreen.submitButtonKey));
  }

  group('Login', () {
    testWidgets('signed-out users see the login screen', (tester) async {
      usePhoneScreen(tester);
      await tester.pumpWidget(buildTestApp(auth: FakeAuthRepository()));

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Welcome to PostFlow'), findsNothing);
    });

    testWidgets('empty form shows validation errors', (tester) async {
      usePhoneScreen(tester);
      await tester.pumpWidget(buildTestApp(auth: FakeAuthRepository()));

      await tapAndSettle(tester, find.byKey(LoginScreen.submitButtonKey));

      expect(find.text('Enter your email address.'), findsOneWidget);
      expect(find.text('Enter your password.'), findsOneWidget);
    });

    testWidgets('wrong password shows an error', (tester) async {
      usePhoneScreen(tester);
      await tester.pumpWidget(buildTestApp(auth: FakeAuthRepository()));

      await logIn(tester, testEmail, 'wrong-password1');

      expect(find.text('Incorrect email or password.'), findsOneWidget);
      expect(find.text('Welcome back'), findsOneWidget);
    });

    testWidgets('valid credentials open the dashboard', (tester) async {
      usePhoneScreen(tester);
      await tester.pumpWidget(buildTestApp(auth: FakeAuthRepository()));

      await logIn(tester, testEmail, testPassword);

      expect(find.text('Welcome to PostFlow'), findsOneWidget);
      expect(find.text('Welcome back'), findsNothing);
    });
  });

  group('Sign up', () {
    Future<void> fillSignUp(WidgetTester tester, String email) async {
      await tapAndSettle(tester, find.text('Sign up'));
      expect(find.text('Create your account'), findsOneWidget);

      await enterField(
        tester,
        fieldWithKey(SignUpScreen.nameFieldKey),
        'Grace Hopper',
      );
      await enterField(tester, fieldWithKey(SignUpScreen.emailFieldKey), email);
      await enterField(
        tester,
        fieldWithKey(SignUpScreen.passwordFieldKey),
        'compiler42',
      );
      await enterField(
        tester,
        fieldWithKey(SignUpScreen.confirmPasswordFieldKey),
        'compiler42',
      );
      await tapAndSettle(tester, find.byKey(SignUpScreen.submitButtonKey));
    }

    testWidgets('weak and mismatched passwords are rejected', (tester) async {
      usePhoneScreen(tester);
      await tester.pumpWidget(buildTestApp(auth: FakeAuthRepository()));
      await tapAndSettle(tester, find.text('Sign up'));

      await enterField(
        tester,
        fieldWithKey(SignUpScreen.passwordFieldKey),
        'short',
      );
      await enterField(
        tester,
        fieldWithKey(SignUpScreen.confirmPasswordFieldKey),
        'different',
      );
      await tapAndSettle(tester, find.byKey(SignUpScreen.submitButtonKey));

      expect(find.text('Enter your name.'), findsOneWidget);
      expect(find.text('Use at least 8 characters.'), findsOneWidget);
      expect(find.text('Passwords do not match.'), findsOneWidget);
    });

    testWidgets('shows a confirmation message when email must be confirmed', (
      tester,
    ) async {
      usePhoneScreen(tester);
      final auth = FakeAuthRepository(requireEmailConfirmation: true);
      await tester.pumpWidget(buildTestApp(auth: auth));

      await fillSignUp(tester, 'grace@example.com');

      expect(find.text('Check your inbox'), findsOneWidget);
      expect(auth.passwords['grace@example.com'], 'compiler42');

      await tapAndSettle(tester, find.text('Back to log in'));
      expect(find.text('Welcome back'), findsOneWidget);
    });

    testWidgets('signs straight in when no confirmation is needed', (
      tester,
    ) async {
      usePhoneScreen(tester);
      await tester.pumpWidget(buildTestApp(auth: FakeAuthRepository()));

      await fillSignUp(tester, 'grace@example.com');

      expect(find.text('Welcome to PostFlow'), findsOneWidget);
      expect(find.text('Create your account'), findsNothing);
    });

    testWidgets('existing email shows an error', (tester) async {
      usePhoneScreen(tester);
      await tester.pumpWidget(buildTestApp(auth: FakeAuthRepository()));

      await fillSignUp(tester, testEmail);

      expect(
        find.text('An account with this email already exists.'),
        findsOneWidget,
      );
    });
  });

  testWidgets('forgot password sends a reset email', (tester) async {
    usePhoneScreen(tester);
    final auth = FakeAuthRepository();
    await tester.pumpWidget(buildTestApp(auth: auth));

    await tapAndSettle(tester, find.text('Forgot password?'));
    expect(find.text('Reset your password'), findsOneWidget);

    await enterField(
      tester,
      fieldWithKey(ForgotPasswordScreen.emailFieldKey),
      testEmail,
    );
    await tapAndSettle(
      tester,
      find.byKey(ForgotPasswordScreen.submitButtonKey),
    );

    expect(find.text('Check your email'), findsOneWidget);
    expect(auth.resetEmailsSent, [testEmail]);
  });

  testWidgets('logging out from settings returns to the login screen', (
    tester,
  ) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(
      buildTestApp(auth: FakeAuthRepository(signedInAs: userFor(testEmail))),
    );

    await tapAndSettle(
      tester,
      find
          .descendant(
            of: find.byType(NavigationBar),
            matching: find.text('Settings'),
          )
          .first,
    );
    await tapAndSettle(tester, find.byKey(SettingsScreen.signOutTileKey));
    expect(find.text('Log out?'), findsOneWidget);

    await tapAndSettle(tester, find.widgetWithText(FilledButton, 'Log out'));

    expect(find.text('Welcome back'), findsOneWidget);
  });
}
