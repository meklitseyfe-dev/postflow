import 'package:flutter/material.dart';
import 'package:postflow/app/app_shell.dart';
import 'package:postflow/core/constants/app_constants.dart';
import 'package:postflow/core/theme/app_theme.dart';

/// Root widget for PostFlow.
class PostFlowApp extends StatelessWidget {
  const PostFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const AppShell(),
    );
  }
}
