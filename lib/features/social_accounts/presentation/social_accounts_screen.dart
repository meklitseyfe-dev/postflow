import 'package:flutter/material.dart';
import 'package:postflow/core/widgets/placeholder_view.dart';

/// Placeholder for managing connected social accounts.
class SocialAccountsScreen extends StatelessWidget {
  const SocialAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      body: const PlaceholderView(
        icon: Icons.hub_rounded,
        title: 'Your social channels',
        message:
            'Connect Instagram, Facebook, TikTok, YouTube, X and LinkedIn to '
            'publish everywhere from PostFlow.',
      ),
    );
  }
}
