import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postflow/core/widgets/postflow_logo.dart';
import 'package:postflow/features/dashboard/presentation/dashboard_screen.dart';

import 'support/fakes.dart';

void main() {
  Widget signedInApp() =>
      buildTestApp(auth: FakeAuthRepository(signedInAs: userFor(testEmail)));

  NavigationBar navigationBar(WidgetTester tester) =>
      tester.widget<NavigationBar>(find.byType(NavigationBar));

  Future<void> tapTab(WidgetTester tester, String label) async {
    await tester.tap(
      find
          .descendant(
            of: find.byType(NavigationBar),
            matching: find.text(label),
          )
          .first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('dashboard shows branding, welcome and main sections', (
    tester,
  ) async {
    await tester.pumpWidget(signedInApp());

    expect(find.byType(PostFlowLogo), findsWidgets);
    expect(find.text('Welcome to PostFlow'), findsOneWidget);
    expect(find.byKey(DashboardScreen.createPostButtonKey), findsOneWidget);
    expect(find.text('Scheduled Posts'), findsOneWidget);
    expect(find.text('Connected Accounts'), findsOneWidget);
  });

  testWidgets('bottom navigation switches between all sections', (
    tester,
  ) async {
    await tester.pumpWidget(signedInApp());
    expect(navigationBar(tester).selectedIndex, 0);

    await tapTab(tester, 'Create');
    expect(navigationBar(tester).selectedIndex, 1);
    expect(find.text('Post composer'), findsOneWidget);

    await tapTab(tester, 'Calendar');
    expect(navigationBar(tester).selectedIndex, 2);
    expect(find.text('Content calendar'), findsOneWidget);

    await tapTab(tester, 'Accounts');
    expect(navigationBar(tester).selectedIndex, 3);
    expect(find.text('Your social channels'), findsOneWidget);

    await tapTab(tester, 'Settings');
    expect(navigationBar(tester).selectedIndex, 4);
    expect(find.text('Preferences'), findsOneWidget);

    await tapTab(tester, 'Dashboard');
    expect(navigationBar(tester).selectedIndex, 0);
  });

  testWidgets('Create Post button opens the composer', (tester) async {
    await tester.pumpWidget(signedInApp());

    await tester.tap(find.byKey(DashboardScreen.createPostButtonKey));
    await tester.pumpAndSettle();

    expect(navigationBar(tester).selectedIndex, 1);
    expect(find.text('Post composer'), findsOneWidget);
  });

  testWidgets('wide windows use a navigation rail', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(signedInApp());

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
}
