import 'package:flutter/material.dart';
import 'package:postflow/core/widgets/placeholder_view.dart';

/// Placeholder for the post composer.
class ComposerScreen extends StatelessWidget {
  const ComposerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: const PlaceholderView(
        icon: Icons.edit_note_rounded,
        title: 'Post composer',
        message:
            'Write captions, attach images or videos, pick your channels and '
            'choose when each post goes live — all from one composer.',
      ),
    );
  }
}
