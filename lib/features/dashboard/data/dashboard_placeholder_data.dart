import 'package:postflow/core/constants/social_platform.dart';

/// Lightweight view model for a post shown on the dashboard.
class ScheduledPostPreview {
  const ScheduledPostPreview({
    required this.caption,
    required this.platforms,
    required this.scheduledAt,
    this.hasMedia = false,
  });

  final String caption;
  final List<SocialPlatform> platforms;
  final DateTime scheduledAt;
  final bool hasMedia;
}

/// Lightweight view model for a social account shown on the dashboard.
class ConnectedAccountPreview {
  const ConnectedAccountPreview({required this.platform, this.handle});

  final SocialPlatform platform;
  final String? handle;

  bool get isConnected => handle != null;
}

/// Sample content for the Step 1 dashboard. Replaced by real data later.
abstract final class DashboardPlaceholderData {
  static List<ScheduledPostPreview> scheduledPosts(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return [
      ScheduledPostPreview(
        caption: 'Behind the scenes of our autumn product shoot 📸',
        platforms: const [SocialPlatform.instagram, SocialPlatform.facebook],
        scheduledAt: today.add(const Duration(days: 1, hours: 9, minutes: 30)),
        hasMedia: true,
      ),
      ScheduledPostPreview(
        caption: '5 lessons we learned shipping our first mobile app',
        platforms: const [SocialPlatform.linkedin, SocialPlatform.x],
        scheduledAt: today.add(const Duration(days: 2, hours: 13)),
      ),
      ScheduledPostPreview(
        caption: 'Quick tutorial: plan a full week of content in 10 minutes',
        platforms: const [SocialPlatform.tiktok, SocialPlatform.youtube],
        scheduledAt: today.add(const Duration(days: 4, hours: 18, minutes: 15)),
        hasMedia: true,
      ),
    ];
  }

  static const List<ConnectedAccountPreview> accounts = [
    ConnectedAccountPreview(
      platform: SocialPlatform.instagram,
      handle: '@postflow.studio',
    ),
    ConnectedAccountPreview(
      platform: SocialPlatform.facebook,
      handle: 'PostFlow Studio',
    ),
    ConnectedAccountPreview(platform: SocialPlatform.linkedin),
    ConnectedAccountPreview(platform: SocialPlatform.tiktok),
  ];
}
