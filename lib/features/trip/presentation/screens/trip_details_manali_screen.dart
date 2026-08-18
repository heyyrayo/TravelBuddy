import 'package:flutter/material.dart';

import '../../../../core/data/trip_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/buttons/app_buttons.dart';
import '../../../../shared/widgets/indicators/step_indicator.dart';

class TripDetailsManaliScreen extends StatelessWidget {
  const TripDetailsManaliScreen({
    super.key,
    required this.trip,
    this.onBudget,
    this.onReadiness,
    this.onNearby,
  });

  final Trip trip;
  final VoidCallback? onBudget;
  final VoidCallback? onReadiness;
  final VoidCallback? onNearby;

  @override
  Widget build(BuildContext context) {
    final destinationName = _destinationName(
      trip.destinationId,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            surfaceTintColor: Colors.transparent,
            leading: Semantics(
              label: 'Back',
              child: IconButton(
                icon: const Icon(
                  AppIcons.back,
                  color: AppColors.onPrimary,
                ),
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                trip.name,
                style: const TextStyle(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.tertiaryContainer,
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Icon(
                      Icons.landscape,
                      size: 100,
                      color: AppColors.onPrimary.withOpacity(
                        0.1,
                      ),
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.xxl,
                    right: AppSpacing.md,
                    child: _StatusBadge(
                      status: trip.status,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        AppIcons.calendar,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(
                        width: AppSpacing.xs,
                      ),
                      Text(
                        '${_formatDate(trip.startDate)} – '
                        '${_formatDate(trip.endDate)}',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(
                        width: AppSpacing.md,
                      ),
                      const Icon(
                        AppIcons.group,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(
                        width: AppSpacing.xs,
                      ),
                      Text(
                        '${trip.travelers} '
                        '${trip.travelers == 1 ? 'traveler' : 'travelers'}',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSpacing.sm,
                  ),
                  Text(
                    destinationName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  _StatsRow(
                    trip: trip,
                    onBudget: onBudget,
                    onReadiness: onReadiness,
                    onNearby: onNearby,
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  Text(
                    'Trip Overview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(
                    height: AppSpacing.md,
                  ),
                  Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Destination',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          destinationName,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(
                          height: AppSpacing.md,
                        ),
                        Text(
                          'Trip Status',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _statusLabel(trip.status),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  Text(
                    'Itinerary',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(
                    height: AppSpacing.md,
                  ),
                  StepIndicator(
                    currentStep: 1,
                    steps: [
                      StepData(
                        title: 'Trip begins in $destinationName',
                        subtitle: _formatDate(trip.startDate),
                      ),
                      StepData(
                        title: 'Explore your destination',
                        subtitle: _formatDate(trip.startDate),
                      ),
                      StepData(
                        title: 'Activities and experiences',
                        subtitle: 'During your stay',
                      ),
                      StepData(
                        title: 'Return journey',
                        subtitle: _formatDate(trip.endDate),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  _BudgetWidget(
                    onTap: onBudget,
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  _PackingWidget(),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  Text(
                    'Local Services',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(
                    height: AppSpacing.sm,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _ServiceCard(
                          icon: AppIcons.hospital,
                          label: 'Medical',
                          onTap: onNearby,
                        ),
                      ),
                      const SizedBox(
                        width: AppSpacing.sm,
                      ),
                      Expanded(
                        child: _ServiceCard(
                          icon: AppIcons.atm,
                          label: 'ATM',
                          onTap: onNearby,
                        ),
                      ),
                      const SizedBox(
                        width: AppSpacing.sm,
                      ),
                      Expanded(
                        child: _ServiceCard(
                          icon: AppIcons.restaurant,
                          label: 'Food',
                          onTap: onNearby,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  GhostButton(
                    label: 'Emergency Contacts',
                    icon: AppIcons.emergency,
                    onPressed: () {},
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

  static String _destinationName(
    String destinationId,
  ) {
    if (destinationId.trim().isEmpty) {
      return 'Unknown destination';
    }

    return destinationId
        .replaceAll('-', ' ')
        .split(' ')
        .map(
          (part) => part.isEmpty
              ? part
              : '${part[0].toUpperCase()}${part.substring(1)}',
        )
        .join(' ');
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

    return '${months[date.month - 1]} ${date.day}, '
        '${date.year}';
  }

  static String _statusLabel(
    TripStatus status,
  ) {
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
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
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
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusPill,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.onSecondaryContainer,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.trip,
    this.onBudget,
    this.onReadiness,
    this.onNearby,
  });

  final Trip trip;
  final VoidCallback? onBudget;
  final VoidCallback? onReadiness;
  final VoidCallback? onNearby;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          icon: AppIcons.check,
          value: trip.status == TripStatus.completed ? '100%' : '—',
          label: 'Readiness',
          onTap: onReadiness,
        ),
        const SizedBox(
          width: AppSpacing.sm,
        ),
        _StatCard(
          icon: AppIcons.wallet,
          value: '—',
          label: 'Budget',
          onTap: onBudget,
        ),
        const SizedBox(
          width: AppSpacing.sm,
        ),
        _StatCard(
          icon: AppIcons.trips,
          value: '${trip.travelers}',
          label: 'Travelers',
          onTap: null,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BudgetWidget extends StatelessWidget {
  const _BudgetWidget({
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(
          AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(
            AppSpacing.radiusCard,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Budget',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Icon(
              AppIcons.chevronRight,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _PackingWidget extends StatelessWidget {
  const _PackingWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Packing List',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(
            height: AppSpacing.sm,
          ),
          Text(
            'Packing items will be generated '
            'from your destination and trip details.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
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
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
