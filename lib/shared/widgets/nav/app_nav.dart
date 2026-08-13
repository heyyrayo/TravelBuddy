import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/constants/app_icons.dart';

/// Bottom navigation bar used across all main tabs.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        boxShadow: AppColors.level2Shadow,
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        indicatorColor: AppColors.primaryFixed,
        destinations: const [
          NavigationDestination(
            icon: Icon(AppIcons.home),
            selectedIcon: Icon(AppIcons.home, fill: 1),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(AppIcons.explore),
            selectedIcon: Icon(AppIcons.explore, fill: 1),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(AppIcons.trips),
            selectedIcon: Icon(AppIcons.trips, fill: 1),
            label: 'Trips',
          ),
          NavigationDestination(
            icon: Icon(AppIcons.budget),
            selectedIcon: Icon(AppIcons.budget, fill: 1),
            label: 'Budget',
          ),
          NavigationDestination(
            icon: Icon(AppIcons.profile),
            selectedIcon: Icon(AppIcons.profile, fill: 1),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// App bar used throughout the app.
class TravelAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TravelAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.bottom,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Size get preferredSize => Size.fromHeight(
        AppSpacing.appBarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: leading,
      actions: actions,
      bottom: bottom,
      backgroundColor: backgroundColor ?? AppColors.surfaceContainerLowest,
      foregroundColor: foregroundColor ?? AppColors.onSurface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    );
  }
}
