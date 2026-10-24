import 'package:flutter/material.dart';
import 'package:postflow/core/constants/social_platform.dart';

/// Circular brand-coloured badge identifying a social platform.
class PlatformBadge extends StatelessWidget {
  const PlatformBadge({super.key, required this.platform, this.size = 32});

  final SocialPlatform platform;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: platform.label,
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: platform.brandColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.surface,
            width: 2,
          ),
        ),
        child: Text(
          platform.initial,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
