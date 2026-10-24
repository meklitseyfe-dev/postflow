import 'package:flutter/material.dart';
import 'package:postflow/core/constants/app_constants.dart';
import 'package:postflow/core/theme/app_theme.dart';
import 'package:postflow/core/widgets/placeholder_view.dart';

/// Shown instead of the app when Supabase settings were not provided.
class MissingConfigApp extends StatelessWidget {
  const MissingConfigApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const Scaffold(
        body: SafeArea(
          child: PlaceholderView(
            icon: Icons.vpn_key_rounded,
            title: 'Supabase is not configured',
            message:
                'Copy env.example.json to env.json, add your Supabase URL and '
                'anon key, then run: flutter run --dart-define-from-file=env.json',
            note: 'Setup required',
          ),
        ),
      ),
    );
  }
}
