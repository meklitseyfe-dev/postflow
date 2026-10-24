/// Lightweight, dependency-free date formatting helpers.
abstract final class DateFormatters {
  static const List<String> _weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// 12-hour clock time, e.g. `9:05 AM`.
  static String time(DateTime value) {
    final hour12 = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minutes = value.minute.toString().padLeft(2, '0');
    final period = value.hour < 12 ? 'AM' : 'PM';
    return '$hour12:$minutes $period';
  }

  /// `Today`, `Tomorrow`, `Yesterday`, or a short date such as `Wed, Oct 28`.
  static String relativeDay(DateTime value, {required DateTime now}) {
    // Compare calendar days in UTC so DST changes don't skew the difference.
    final today = DateTime.utc(now.year, now.month, now.day);
    final day = DateTime.utc(value.year, value.month, value.day);
    final difference = day.difference(today).inDays;

    return switch (difference) {
      0 => 'Today',
      1 => 'Tomorrow',
      -1 => 'Yesterday',
      _ =>
        '${_weekdays[value.weekday - 1]}, '
            '${_months[value.month - 1]} ${value.day}',
    };
  }

  /// Day and time together, e.g. `Tomorrow · 9:30 AM`.
  static String schedule(DateTime value, {required DateTime now}) =>
      '${relativeDay(value, now: now)} · ${time(value)}';

  /// Time-of-day greeting.
  static String greeting(DateTime value) => switch (value.hour) {
    < 12 => 'Good morning',
    < 17 => 'Good afternoon',
    _ => 'Good evening',
  };
}
