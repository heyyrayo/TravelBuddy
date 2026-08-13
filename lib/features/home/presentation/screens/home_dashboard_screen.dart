import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/cards/travel_card.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key, this.onPlanTrip, this.onTripTap});

  final VoidCallback? onPlanTrip;
  final VoidCallback? onTripTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.surfaceContainerLowest,
            surfaceTintColor: Colors.transparent,
            title: Image.asset(
              'assets/images/travelbuddy_logo.png',
              height: 32,
              width: 32,
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
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primaryFixed,
                  child: const Text(
                    'A',
                    style: TextStyle(
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
              padding: const EdgeInsets.all(AppSpacing.screenMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting
                  Text(
                    'Good Morning, Amit',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Ready for your next adventure?',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Readiness card
                  _ReadinessCard(onTap: onTripTap),
                  const SizedBox(height: AppSpacing.lg),

                  // Plan new trip button
                  _PlanTripBanner(onTap: onPlanTrip),
                  const SizedBox(height: AppSpacing.lg),

                  // Upcoming trips
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Journeys',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    height: 220,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: AppSpacing.md),
                      itemBuilder: (ctx, i) {
                        final trips = [
                          ('Manali Retreat', 'Oct 12–18 · Upcoming in 4 days', '₹38,000', 'https://picsum.photos/seed/manali/400/300'),
                          ('Goa Beach Trip', 'Dec 1–7 · Planning', '₹25,000', 'https://picsum.photos/seed/goa/400/300'),
                          ('Rajasthan Tour', 'Jan 10–16 · Draft', '₹42,000', 'https://picsum.photos/seed/jaipur/400/300'),
                        ];
                        return SizedBox(
                          width: 200,
                          child: TravelCard(
                            title: trips[i].$1,
                            subtitle: trips[i].$2,
                            imageUrl: trips[i].$4,
                            onTap: onTripTap,
                            footer: Row(
                              children: [
                                const Icon(AppIcons.currency,
                                    size: 14, color: AppColors.onSurfaceVariant),
                                Text(
                                  trips[i].$3,
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

                  // Quick access
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
                      _QuickAction(icon: AppIcons.explore, label: 'Explore'),
                      _QuickAction(icon: AppIcons.budget, label: 'Budget'),
                      _QuickAction(icon: AppIcons.gps, label: 'Nearby'),
                      _QuickAction(icon: AppIcons.check, label: 'Readiness'),
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
}

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({this.onTap});

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
            colors: [AppColors.primary, AppColors.primaryContainer],
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
                    'Manali Retreat',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Departing in 4 days',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onPrimary.withOpacity(0.8),
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer.withOpacity(0.9),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusPill),
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
            // Circular readiness gauge
            SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: 0.92,
                    strokeWidth: 8,
                    backgroundColor: AppColors.onPrimary.withOpacity(0.2),
                    color: AppColors.secondaryContainer,
                    strokeCap: StrokeCap.round,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '92%',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Text(
                        'Ready',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.onPrimary.withOpacity(0.8),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanTripBanner extends StatelessWidget {
  const _PlanTripBanner({this.onTap});

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
            const Icon(AppIcons.add, color: AppColors.secondary, size: 24),
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
            const Icon(AppIcons.chevronRight, color: AppColors.secondary),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label});

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
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
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
