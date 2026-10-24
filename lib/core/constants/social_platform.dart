import 'package:flutter/painting.dart';

/// Social platforms PostFlow will support.
///
/// Display metadata only — no platform integration exists yet.
enum SocialPlatform {
  instagram('Instagram', Color(0xFFE1306C)),
  facebook('Facebook', Color(0xFF1877F2)),
  tiktok('TikTok', Color(0xFF111111)),
  youtube('YouTube', Color(0xFFFF0000)),
  x('X', Color(0xFF14171A)),
  linkedin('LinkedIn', Color(0xFF0A66C2));

  const SocialPlatform(this.label, this.brandColor);

  final String label;
  final Color brandColor;

  /// Single-letter mark used in compact badges.
  String get initial => label.substring(0, 1);
}
