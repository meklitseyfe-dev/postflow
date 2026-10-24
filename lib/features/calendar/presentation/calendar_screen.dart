import 'package:flutter/material.dart';
import 'package:postflow/core/widgets/placeholder_view.dart';

/// Placeholder for the content calendar.
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: const PlaceholderView(
        icon: Icons.calendar_month_rounded,
        title: 'Content calendar',
        message:
            'See every scheduled, published and failed post by day, week or '
            'month, and reschedule with a tap.',
      ),
    );
  }
}
