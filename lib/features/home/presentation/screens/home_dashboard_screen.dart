import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/data/app_states.dart';
import '../../../../core/data/trip_repository.dart';
import '../../../../core/state/auth_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/cards/travel_card.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({
    super.key,
    this.onPlanTrip,
    this.onTripTap,
  });

  final VoidCallback? onPlanTrip;
  final VoidCallback? onTripTap;

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    final tripState = context.watch<TripState>();

    final displayName = _displayName(authState.displayName);
    final trips = tripState.trips;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.surfaceContainerLowest,
            surfaceTintColor: Colors.transparent,
            titleSpacing: AppSpacing.screenMargin,
            title: Image.asset(
              'assets/images/travelbuddy_horizontal.png',
              height: 30,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
            ),
            actions: [
              Semantics(
                label: 'Notifications',
                child: IconButton(
                  icon: const Icon(AppIcons.bell),
                  tooltip: 'Notifications',
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: AppSpacing.md,
                ),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primaryFixed,
                  child: Text(
                    _initial(displayName),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(
                AppSpacing.screenMargin,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning, $displayName',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    trips.isEmpty
                        ? 'Ready to plan your first adventure?'
                        : 'Ready for your next adventure?',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (trips.isNotEmpty) ...[
                    _ReadinessCard(
                      trip: trips.first,
                      onTap: onTripTap,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  _PlanTripBanner(
                    onTap: onPlanTrip,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Journeys',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      TextButton(
                        onPressed: trips.isEmpty ? null : onTripTap,
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (tripState.isLoading)
                    const SizedBox(
                      height: 220,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (tripState.errorMessage != null)
                    _ErrorCard(
                      message: tripState.errorMessage!,
                      onRetry: tripState.load,
                    )
                  else if (trips.isEmpty)
                    _EmptyTripsCard(
                      onPlanTrip: onPlanTrip,
                    )
                  else
                    SizedBox(
                      height: 220,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: trips.length,
                        separatorBuilder: (_, __) => const SizedBox(
                          width: AppSpacing.md,
                        ),
                        itemBuilder: (ctx, index) {
                          final trip = trips[index];

                          return SizedBox(
                            width: 220,
                            child: TravelCard(
                              title: trip.name,
                              subtitle: _tripSubtitle(trip),
                              imageUrl: _imageForDestination(
                                trip.destinationId,
                              ),
                              onTap: onTripTap,
                              footer: Row(
                                children: [
                                  const Icon(
                                    AppIcons.trips,
                                    size: 14,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${trip.travelers} '
                                    '${trip.travelers == 1 ? 'Traveler' : 'Travelers'}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Quick Access',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: AppSpacing.sm,
                    mainAxisSpacing: AppSpacing.sm,
                    children: const [
                      _QuickAction(
                        icon: AppIcons.explore,
                        label: 'Explore',
                      ),
                      _QuickAction(
                        icon: AppIcons.budget,
                        label: 'Budget',
                      ),
                      _QuickAction(
                        icon: AppIcons.gps,
                        label: 'Nearby',
                      ),
                      _QuickAction(
                        icon: AppIcons.check,
                        label: 'Readiness',
                      ),
                    ],
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

  static String _displayName(String? value) {
    final name = value?.trim();

    if (name == null || name.isEmpty) {
      return 'Traveler';
    }

    return name.split(' ').first;
  }

  static String _initial(String name) {
    if (name.trim().isEmpty) {
      return 'T';
    }

    return name.trim()[0].toUpperCase();
  }

  static String _tripSubtitle(Trip trip) {
    final start = _formatDate(trip.startDate);
    final end = _formatDate(trip.endDate);

    return '$start–$end · ${_statusLabel(trip.status)}';
  }

  static String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}';
  }

  static String _statusLabel(TripStatus status) {
    switch (status) {
      case TripStatus.planning:
        return 'Planning';
      case TripStatus.upcoming:
        return 'Upcoming';
      case TripStatus.active:
        return 'Active';
      case TripStatus.completed:
        return 'Completed';
    }
  }

  static String _imageForDestination(
    String destinationId,
  ) {
    switch (destinationId.toLowerCase()) {
      case 'goa':
        return 'https://picsum.photos/seed/goa/400/300';
      case 'jaipur':
      case 'rajasthan':
        return 'https://picsum.photos/seed/jaipur/400/300';
      case 'manali':
      default:
        return 'https://picsum.photos/seed/manali/400/300';
    }
  }
}

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({
    required this.trip,
    this.onTap,
  });

  final Trip trip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryContainer,
            ],
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusBanner),
          boxShadow: AppColors.level2Shadow,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Your next journey',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onPrimary.withOpacity(0.8),
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusPill,
                      ),
                    ),
                    child: Text(
                      'View Trip Details',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.onSecondaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            const Icon(
              AppIcons.chevronRight,
              color: AppColors.onPrimary,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanTripBanner extends StatelessWidget {
  const _PlanTripBanner({
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.secondaryFixed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        child: Row(
          children: [
            const Icon(
              AppIcons.add,
              color: AppColors.secondary,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plan New Trip',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    'Create a personalized itinerary',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSecondaryFixed,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(
              AppIcons.chevronRight,
              color: AppColors.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyTripsCard extends StatelessWidget {
  const _EmptyTripsCard({
    this.onPlanTrip,
  });

  final VoidCallback? onPlanTrip;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.luggage_outlined,
            size: 40,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'No trips yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Start planning your first journey.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton(
            onPressed: onPlanTrip,
            child: const Text('Plan a Trip'),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 36,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryFixed.withOpacity(0.5),
                borderRadius: BorderRadius.circular(
                  AppSpacing.radiusCard,
                ),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
