import 'package:flutter/material.dart';
import 'package:postflow/core/constants/app_constants.dart';
import 'package:postflow/core/constants/app_spacing.dart';
import 'package:postflow/core/theme/app_colors.dart';
import 'package:postflow/core/utils/date_formatters.dart';
import 'package:postflow/core/widgets/postflow_logo.dart';
import 'package:postflow/core/widgets/section_header.dart';
import 'package:postflow/features/dashboard/data/dashboard_placeholder_data.dart';
import 'package:postflow/features/dashboard/presentation/widgets/connected_account_tile.dart';
import 'package:postflow/features/dashboard/presentation/widgets/scheduled_post_tile.dart';

/// Home screen: welcome, quick "Create Post" action, upcoming posts and
/// connected accounts. Uses placeholder data in Step 1.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    this.onCreatePost,
    this.onOpenCalendar,
    this.onOpenAccounts,
  });

  static const Key createPostButtonKey = Key('dashboard.createPost');

  final VoidCallback? onCreatePost;
  final VoidCallback? onOpenCalendar;
  final VoidCallback? onOpenAccounts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final posts = DashboardPlaceholderData.scheduledPosts(now);
    const accounts = DashboardPlaceholderData.accounts;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppConstants.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: PostFlowLogo(),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _WelcomeCard(greetingTime: now, onCreatePost: onCreatePost),
                  const SizedBox(height: AppSpacing.xxl),
                  SectionHeader(
                    title: 'Scheduled Posts',
                    actionLabel: 'View calendar',
                    onAction: onOpenCalendar,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _ListCard(
                    children: [
                      for (final post in posts)
                        ScheduledPostTile(post: post, now: now),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  SectionHeader(
                    title: 'Connected Accounts',
                    actionLabel: 'Manage',
                    onAction: onOpenAccounts,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _ListCard(
                    children: [
                      for (final account in accounts)
                        ConnectedAccountTile(account: account),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Showing sample data. Real accounts and posts arrive in '
                    'later milestones.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.greetingTime, this.onCreatePost});

  final DateTime greetingTime;
  final VoidCallback? onCreatePost;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.brand.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormatters.greeting(greetingTime),
              style: textTheme.labelLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Welcome to PostFlow',
              style: textTheme.headlineSmall?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Plan, schedule and publish your content across every channel '
              '— all from one place.',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              key: DashboardScreen.createPostButtonKey,
              onPressed: onCreatePost,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.brandDeep,
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Post'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card that stacks rows with inset dividers between them.
class _ListCard extends StatelessWidget {
  const _ListCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              const Divider(indent: AppSpacing.lg, endIndent: AppSpacing.lg),
            children[i],
          ],
        ],
      ),
    );
  }
}
