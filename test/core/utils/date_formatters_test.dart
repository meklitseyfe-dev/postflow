import 'package:flutter_test/flutter_test.dart';
import 'package:postflow/core/utils/date_formatters.dart';

void main() {
  group('DateFormatters.time', () {
    test('formats 12-hour clock times', () {
      expect(DateFormatters.time(DateTime(2026, 10, 25, 9, 5)), '9:05 AM');
      expect(DateFormatters.time(DateTime(2026, 10, 25, 0, 0)), '12:00 AM');
      expect(DateFormatters.time(DateTime(2026, 10, 25, 12, 30)), '12:30 PM');
      expect(DateFormatters.time(DateTime(2026, 10, 25, 18, 45)), '6:45 PM');
    });
  });

  group('DateFormatters.relativeDay', () {
    final now = DateTime(2026, 10, 25, 14);

    test('uses relative words for nearby days', () {
      expect(
        DateFormatters.relativeDay(DateTime(2026, 10, 25, 23), now: now),
        'Today',
      );
      expect(
        DateFormatters.relativeDay(DateTime(2026, 10, 26, 1), now: now),
        'Tomorrow',
      );
      expect(
        DateFormatters.relativeDay(DateTime(2026, 10, 24, 8), now: now),
        'Yesterday',
      );
    });

    test('uses a short date for other days', () {
      expect(
        DateFormatters.relativeDay(DateTime(2026, 10, 28, 9), now: now),
        'Wed, Oct 28',
      );
    });

    test('schedule combines day and time', () {
      expect(
        DateFormatters.schedule(DateTime(2026, 10, 26, 9, 30), now: now),
        'Tomorrow · 9:30 AM',
      );
    });
  });

  group('DateFormatters.greeting', () {
    test('changes with the time of day', () {
      expect(DateFormatters.greeting(DateTime(2026, 1, 1, 8)), 'Good morning');
      expect(
        DateFormatters.greeting(DateTime(2026, 1, 1, 13)),
        'Good afternoon',
      );
      expect(DateFormatters.greeting(DateTime(2026, 1, 1, 20)), 'Good evening');
    });
  });
}
