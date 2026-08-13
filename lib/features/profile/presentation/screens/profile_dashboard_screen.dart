import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';

class ProfileDashboardScreen extends StatelessWidget {
  const ProfileDashboardScreen({
    super.key,
    this.onSettings,
    this.onLogout,
  });

  final VoidCallback? onSettings;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.primary,
            surfaceTintColor: Colors.transparent,
            expandedHeight: 220,
            pinned: true,
            actions: [
              Semantics(
                label: 'Edit profile',
                child: IconButton(
                  icon: const Icon(AppIcons.edit, color: AppColors.onPrimary),
                  tooltip: 'Edit profile',
                  onPressed: () {},
                ),
              ),
              Semantics(
                label: 'Share profile',
                child: IconButton(
                  icon: const Icon(AppIcons.share, color: AppColors.onPrimary),
                  tooltip: 'Share profile',
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryContainer],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppSpacing.xxl),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primaryFixed,
                      child: Text(
                        'A',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      'Amit',
                      style: TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Passionate about discovering hidden gems...',
                      style: TextStyle(
                        color: AppColors.onPrimary.withOpacity(0.75),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(AppIcons.trophy,
                              size: 14, color: AppColors.onSecondaryContainer),
                          const SizedBox(width: 4),
                          const Text(
                            'Explorer Level',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.onSecondaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats grid
                  Text(
                    'Travel Statistics',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(child: _StatCard(value: '12', label: 'Trips Completed', icon: AppIcons.trips)),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: _StatCard(value: '₹14.5K', label: 'Money Saved', icon: AppIcons.saveMoney)),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: _StatCard(value: '3', label: 'Countries', icon: AppIcons.explore)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Achievements
                  Text(
                    'Achievements',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    height: 96,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _AchievementBadge(label: 'Mountain Nomad', icon: AppIcons.hiking),
                        _AchievementBadge(label: 'Budget Guru', icon: AppIcons.saveMoney),
                        _AchievementBadge(label: 'City Slicker', icon: AppIcons.explore),
                        _AchievementBadge(label: 'Beach Bum', icon: AppIcons.beach),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Favorite destinations
                  Text(
                    'Favorite Destinations',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: ['Manali', 'Goa', 'Jaipur']
                        .map((d) => Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer,
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.landscape,
                                          color: AppColors.onPrimaryContainer, size: 24),
                                      const SizedBox(height: 4),
                                      Text(
                                        d,
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                              color: AppColors.onPrimaryContainer,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Divider(),
                  const SizedBox(height: AppSpacing.sm),

                  // Menu items
                  _MenuTile(icon: AppIcons.gear, label: 'Settings', onTap: onSettings),
                  _MenuTile(icon: AppIcons.trips, label: 'Trip History', onTap: () {}),
                  _MenuTile(icon: AppIcons.heart, label: 'Saved Places', onTap: () {}),
                  const SizedBox(height: AppSpacing.sm),
                  const Divider(),
                  const SizedBox(height: AppSpacing.sm),
                  _MenuTile(
                    icon: AppIcons.logout,
                    label: 'Logout',
                    onTap: onLogout,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label, required this.icon});

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  const _AchievementBadge({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.secondaryFixed.withOpacity(0.4),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.secondary, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.secondary,
                ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.onSurface;
    return Semantics(
      button: true,
      label: label,
      child: ListTile(
        leading: Icon(icon, color: c),
        title: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: c),
        ),
        trailing: Icon(AppIcons.chevronRight, color: AppColors.outlineVariant),
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    );
  }
}
