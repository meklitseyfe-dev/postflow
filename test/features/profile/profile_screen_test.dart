import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postflow/features/profile/domain/user_profile.dart';
import 'package:postflow/features/profile/presentation/profile_screen.dart';
import 'package:postflow/features/settings/presentation/settings_screen.dart';

import '../../support/fakes.dart';
import '../../support/test_helpers.dart';

void main() {
  final user = userFor(testEmail);

  Future<void> openProfile(WidgetTester tester) async {
    await tapAndSettle(
      tester,
      find
          .descendant(
            of: find.byType(NavigationBar),
            matching: find.text('Settings'),
          )
          .first,
    );
    await tapAndSettle(tester, find.byKey(SettingsScreen.accountTileKey));
  }

  testWidgets('shows the profile and saves a new name', (tester) async {
    usePhoneScreen(tester);
    final profiles = FakeProfileRepository()
      ..profiles[user.id] = UserProfile(id: user.id, fullName: 'Ada Lovelace');
    await tester.pumpWidget(
      buildTestApp(
        auth: FakeAuthRepository(signedInAs: user),
        profiles: profiles,
      ),
    );

    await openProfile(tester);

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text(testEmail), findsWidgets);
    expect(find.text('AL'), findsOneWidget);
    expect(find.text('Ada Lovelace'), findsOneWidget);

    await enterField(
      tester,
      fieldWithKey(ProfileScreen.nameFieldKey),
      'Ada King',
    );
    await tapAndSettle(tester, find.byKey(ProfileScreen.saveButtonKey));

    expect(find.text('Profile updated'), findsOneWidget);
    expect(profiles.profiles[user.id]?.fullName, 'Ada King');
    expect(find.text('AK'), findsOneWidget);
  });

  testWidgets('works when no profile row exists yet', (tester) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(
      buildTestApp(auth: FakeAuthRepository(signedInAs: user)),
    );

    await openProfile(tester);

    expect(find.text('Personal details'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
  });

  testWidgets('logging out from the profile returns to the login screen', (
    tester,
  ) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(
      buildTestApp(auth: FakeAuthRepository(signedInAs: user)),
    );

    await openProfile(tester);
    await tapAndSettle(tester, find.byKey(ProfileScreen.signOutButtonKey));
    await tapAndSettle(tester, find.widgetWithText(FilledButton, 'Log out'));

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Profile'), findsNothing);
  });
}
