import 'package:flutter/material.dart';
import 'package:postflow/core/theme/app_colors.dart';

/// PostFlow logo mark with an optional "PostFlow" wordmark.
class PostFlowLogo extends StatelessWidget {
  const PostFlowLogo({super.key, this.size = 36, this.showWordmark = true});

  final double size;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final mark = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(Icons.send_rounded, color: Colors.white, size: size * 0.5),
    );

    if (!showWordmark) {
      return Semantics(label: 'PostFlow', child: mark);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        SizedBox(width: size * 0.3),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Post'),
              TextSpan(
                text: 'Flow',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ],
          ),
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: size * 0.62,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
      ],
    );
  }
}
