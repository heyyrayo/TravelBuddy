import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/data/app_states.dart';
import '../../../../core/data/trip_repository.dart';
import '../../../../core/state/auth_state.dart';
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
    final authState = context.watch<AuthState>();
    final tripState = context.watch<TripState>();

    final name = _displayName(authState.displayName);
    final email = authState.email ?? '';

    final trips = tripState.trips;
    final totalTrips = trips.length;

    final completedTrips = trips
        .where(
          (trip) => trip.status == TripStatus.completed,
        )
        .length;

    final upcomingTrips = trips
        .where(
          (trip) =>
              trip.status == TripStatus.upcoming ||
              trip.status == TripStatus.planning,
        )
        .length;

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
                  icon: const Icon(
                    AppIcons.edit,
                    color: AppColors.onPrimary,
                  ),
                  tooltip: 'Edit profile',
                  onPressed: () {},
                ),
              ),
              Semantics(
                label: 'Share profile',
                child: IconButton(
                  icon: const Icon(
                    AppIcons.share,
                    color: AppColors.onPrimary,
                  ),
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
                    colors: [
                      AppColors.primary,
                      AppColors.primaryContainer,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: AppSpacing.xxl,
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primaryFixed,
                      child: Text(
                        _initials(name),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.sm,
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (email.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 4,
                          left: AppSpacing.lg,
                          right: AppSpacing.lg,
                        ),
                        child: Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.onPrimary.withOpacity(0.75),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: AppSpacing.sm,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusPill,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            AppIcons.trophy,
                            size: 14,
                            color: AppColors.onSecondaryContainer,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Traveler',
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
              padding: const EdgeInsets.all(
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Travel Statistics',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(
                    height: AppSpacing.md,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          value: '$completedTrips',
                          label: 'Trips Completed',
                          icon: AppIcons.trips,
                        ),
                      ),
                      const SizedBox(
                        width: AppSpacing.sm,
                      ),
                      Expanded(
                        child: _StatCard(
                          value: '$totalTrips',
                          label: 'Total Trips',
                          icon: AppIcons.trips,
                        ),
                      ),
                      const SizedBox(
                        width: AppSpacing.sm,
                      ),
                      Expanded(
                        child: _StatCard(
                          value: '$upcomingTrips',
                          label: 'Upcoming',
                          icon: AppIcons.calendar,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  Text(
                    'Your Trips',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(
                    height: AppSpacing.sm,
                  ),
                  if (tripState.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(
                        AppSpacing.xl,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (tripState.errorMessage != null)
                    _EmptyState(
                      icon: Icons.error_outline,
                      title: 'Unable to load trips',
                      subtitle: tripState.errorMessage!,
                      actionLabel: 'Retry',
                      onAction: tripState.load,
                    )
                  else if (trips.isEmpty)
                    _EmptyState(
                      icon: Icons.luggage_outlined,
                      title: 'No trips yet',
                      subtitle: 'Your trips will appear here '
                          'once you start planning.',
                    )
                  else
                    ...trips.map(
                      (trip) => Card(
                        color: AppColors.surfaceContainerLow,
                        margin: const EdgeInsets.only(
                          bottom: AppSpacing.sm,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryFixed,
                            child: const Icon(
                              AppIcons.trips,
                              color: AppColors.primary,
                            ),
                          ),
                          title: Text(
                            trip.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${trip.destinationId} · '
                            '${trip.travelers} '
                            '${trip.travelers == 1 ? 'traveler' : 'travelers'}',
                          ),
                          trailing: _StatusChip(
                            status: trip.status,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: AppSpacing.sm,
                  ),
                  _MenuTile(
                    icon: AppIcons.gear,
                    label: 'Settings',
                    onTap: onSettings,
                  ),
                  _MenuTile(
                    icon: AppIcons.trips,
                    label: 'Trip History',
                    onTap: () {},
                  ),
                  _MenuTile(
                    icon: AppIcons.heart,
                    label: 'Saved Places',
                    onTap: () {},
                  ),
                  const SizedBox(
                    height: AppSpacing.sm,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: AppSpacing.sm,
                  ),
                  _MenuTile(
                    icon: AppIcons.logout,
                    label: 'Logout',
                    onTap: onLogout,
                    color: AppColors.error,
                  ),
                  const SizedBox(
                    height: AppSpacing.xxl,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _displayName(String? value) {
    final name = value?.trim();

    if (name == null || name.isEmpty) {
      return 'Traveler';
    }

    return name;
  }

  static String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where(
          (part) => part.isNotEmpty,
        )
        .toList();

    if (parts.isEmpty) {
      return 'T';
    }

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.status,
  });

  final TripStatus status;

  @override
  Widget build(BuildContext context) {
    String label;

    switch (status) {
      case TripStatus.planning:
        label = 'Planning';
      case TripStatus.upcoming:
        label = 'Upcoming';
      case TripStatus.active:
        label = 'Active';
      case TripStatus.completed:
        label = 'Completed';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryFixed,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusPill,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusCard,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 36,
          ),
          const SizedBox(
            height: AppSpacing.sm,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: AppSpacing.xs,
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(
              height: AppSpacing.sm,
            ),
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusCard,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
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
    final effectiveColor = color ?? AppColors.onSurface;

    return Semantics(
      button: true,
      label: label,
      child: ListTile(
        leading: Icon(
          icon,
          color: effectiveColor,
        ),
        title: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: effectiveColor,
              ),
        ),
        trailing: Icon(
          AppIcons.chevronRight,
          color: AppColors.outlineVariant,
        ),
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppSpacing.radiusMd,
          ),
        ),
      ),
    );
  }
}
