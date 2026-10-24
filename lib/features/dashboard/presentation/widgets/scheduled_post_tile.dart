import 'package:flutter/material.dart';
import 'package:postflow/core/constants/app_spacing.dart';
import 'package:postflow/core/utils/date_formatters.dart';
import 'package:postflow/core/widgets/platform_badge.dart';
import 'package:postflow/features/dashboard/data/dashboard_placeholder_data.dart';

/// One upcoming post: media/text icon, caption, time and target platforms.
class ScheduledPostTile extends StatelessWidget {
  const ScheduledPostTile({super.key, required this.post, required this.now});

  final ScheduledPostPreview post;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(
              post.hasMedia ? Icons.image_outlined : Icons.notes_rounded,
              color: scheme.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 16,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        DateFormatters.schedule(post.scheduledAt, now: now),
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    for (final platform in post.platforms)
                      Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.xs),
                        child: PlatformBadge(platform: platform, size: 24),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
