import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Uses a typical phone-sized screen (360 × 800 logical pixels).
void usePhoneScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
}

/// Scrolls [finder] into view, taps it and waits for animations.
Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Scrolls [finder] into view and types [text] into it.
Future<void> enterField(WidgetTester tester, Finder finder, String text) async {
  await tester.ensureVisible(finder);
  await tester.enterText(finder, text);
}

/// Finds the editable text inside a form field wrapper with [key].
Finder fieldWithKey(Key key) =>
    find.descendant(of: find.byKey(key), matching: find.byType(EditableText));
