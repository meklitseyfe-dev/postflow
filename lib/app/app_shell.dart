import 'package:flutter/material.dart';
import 'package:postflow/core/constants/app_constants.dart';
import 'package:postflow/core/constants/app_spacing.dart';
import 'package:postflow/core/widgets/postflow_logo.dart';
import 'package:postflow/features/calendar/presentation/calendar_screen.dart';
import 'package:postflow/features/composer/presentation/composer_screen.dart';
import 'package:postflow/features/dashboard/presentation/dashboard_screen.dart';
import 'package:postflow/features/settings/presentation/settings_screen.dart';
import 'package:postflow/features/social_accounts/presentation/social_accounts_screen.dart';

/// The top-level sections reachable from the main navigation.
enum AppSection {
  dashboard(
    'Dashboard',
    Icons.space_dashboard_outlined,
    Icons.space_dashboard_rounded,
  ),
  composer('Create', Icons.add_box_outlined, Icons.add_box_rounded),
  calendar(
    'Calendar',
    Icons.calendar_month_outlined,
    Icons.calendar_month_rounded,
  ),
  accounts('Accounts', Icons.hub_outlined, Icons.hub_rounded),
  settings('Settings', Icons.settings_outlined, Icons.settings_rounded);

  const AppSection(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// Hosts the main sections and switches between a bottom navigation bar
/// (phones) and a side rail (tablets, desktop and web).
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppSection _current = AppSection.dashboard;

  void _goTo(AppSection section) {
    if (section == _current) return;
    setState(() => _current = section);
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      DashboardScreen(
        onCreatePost: () => _goTo(AppSection.composer),
        onOpenCalendar: () => _goTo(AppSection.calendar),
        onOpenAccounts: () => _goTo(AppSection.accounts),
      ),
      const ComposerScreen(),
      const CalendarScreen(),
      const SocialAccountsScreen(),
      const SettingsScreen(),
    ];

    // IndexedStack keeps each section's state while switching tabs.
    final content = IndexedStack(index: _current.index, children: pages);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppConstants.railBreakpoint) {
          return Scaffold(
            body: Row(
              children: [
                _SideRail(current: _current, onSelected: _goTo),
                const VerticalDivider(width: 1),
                Expanded(child: content),
              ],
            ),
          );
        }
        return Scaffold(
          body: content,
          bottomNavigationBar: _BottomBar(
            current: _current,
            onSelected: _goTo,
          ),
        );
      },
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.current, required this.onSelected});

  final AppSection current;
  final ValueChanged<AppSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.outlineVariant;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: NavigationBar(
        selectedIndex: current.index,
        onDestinationSelected: (index) => onSelected(AppSection.values[index]),
        destinations: [
          for (final section in AppSection.values)
            NavigationDestination(
              icon: Icon(section.icon),
              selectedIcon: Icon(section.selectedIcon),
              label: section.label,
            ),
        ],
      ),
    );
  }
}

class _SideRail extends StatelessWidget {
  const _SideRail({required this.current, required this.onSelected});

  final AppSection current;
  final ValueChanged<AppSection> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      right: false,
      child: NavigationRail(
        selectedIndex: current.index,
        onDestinationSelected: (index) => onSelected(AppSection.values[index]),
        labelType: NavigationRailLabelType.all,
        leading: const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: PostFlowLogo(showWordmark: false),
        ),
        destinations: [
          for (final section in AppSection.values)
            NavigationRailDestination(
              icon: Icon(section.icon),
              selectedIcon: Icon(section.selectedIcon),
              label: Text(section.label),
            ),
        ],
      ),
    );
  }
}
