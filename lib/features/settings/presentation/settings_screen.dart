import 'package:flutter/material.dart';
import 'package:postflow/core/constants/app_constants.dart';
import 'package:postflow/core/widgets/placeholder_view.dart';

/// Placeholder for app and workspace settings.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const PlaceholderView(
        icon: Icons.tune_rounded,
        title: 'Preferences',
        message:
            'Workspace, notification, time zone and appearance settings will '
            'live here.',
        note: '${AppConstants.appName} v${AppConstants.version}',
      ),
    );
  }
}
