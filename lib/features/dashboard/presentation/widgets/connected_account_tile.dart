import 'package:flutter/material.dart';
import 'package:postflow/core/constants/app_spacing.dart';
import 'package:postflow/core/theme/app_colors.dart';
import 'package:postflow/core/widgets/platform_badge.dart';
import 'package:postflow/core/widgets/status_pill.dart';
import 'package:postflow/features/dashboard/data/dashboard_placeholder_data.dart';

/// One social account row with its connection status.
class ConnectedAccountTile extends StatelessWidget {
  const ConnectedAccountTile({super.key, required this.account});

  final ConnectedAccountPreview account;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final connected = account.isConnected;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      leading: PlatformBadge(platform: account.platform, size: 40),
      title: Text(account.platform.label),
      subtitle: Text(account.handle ?? 'Connect to start publishing'),
      trailing: StatusPill(
        label: connected ? 'Connected' : 'Not connected',
        color: connected ? AppColors.success : scheme.onSurfaceVariant,
      ),
    );
  }
}
