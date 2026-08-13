import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/buttons/app_buttons.dart';
import '../../../../shared/widgets/indicators/step_indicator.dart';

class TripDetailsManaliScreen extends StatelessWidget {
  const TripDetailsManaliScreen({
    super.key,
    this.onBudget,
    this.onReadiness,
    this.onNearby,
  });

  final VoidCallback? onBudget;
  final VoidCallback? onReadiness;
  final VoidCallback? onNearby;

  @override
  Widget build(BuildContext context) {
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
                icon: const Icon(AppIcons.back, color: AppColors.onPrimary),
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Manali Retreat',
                style: TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w700),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.tertiaryContainer],
                      ),
                    ),
                  ),
                  Center(
                    child: Icon(Icons.landscape, size: 100,
                        color: AppColors.onPrimary.withOpacity(0.1)),
                  ),
                  // Status badge
                  Positioned(
                    top: AppSpacing.xxl,
                    right: AppSpacing.md,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                      ),
                      child: const Text(
                        'Upcoming',
                        style: TextStyle(
                          color: AppColors.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
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
                  // Trip meta
                  Row(
                    children: [
                      const Icon(AppIcons.calendar, color: AppColors.primary, size: 16),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Oct 12–18, 2024',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      const Icon(AppIcons.group, color: AppColors.primary, size: 16),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '2 travelers',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Quick stats row
                  _StatsRow(onBudget: onBudget, onReadiness: onReadiness, onNearby: onNearby),
                  const SizedBox(height: AppSpacing.lg),

                  // Itinerary
                  Text(
                    'Itinerary',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  StepIndicator(
                    currentStep: 2,
                    steps: const [
                      StepData(title: 'Flight to Kullu Manali Airport', subtitle: 'Oct 12 · 06:30 AM'),
                      StepData(title: 'Check-in: The Himalayan', subtitle: 'Oct 12 · 12:00 PM'),
                      StepData(title: 'Solang Valley Adventure', subtitle: 'Oct 13 · All day'),
                      StepData(title: 'Rohtang Pass Excursion', subtitle: 'Oct 14 · 07:00 AM'),
                      StepData(title: 'Local Market & Hadimba Temple', subtitle: 'Oct 15'),
                      StepData(title: 'Departure to Delhi', subtitle: 'Oct 18 · 09:00 AM'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Weather widget
                  _WeatherWidget(),
                  const SizedBox(height: AppSpacing.lg),

                  // Budget progress
                  _BudgetWidget(onTap: onBudget),
                  const SizedBox(height: AppSpacing.lg),

                  // Packing list
                  _PackingWidget(),
                  const SizedBox(height: AppSpacing.lg),

                  // Local services
                  Text(
                    'Local Services',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(child: _ServiceCard(icon: AppIcons.hospital, label: 'Medical', onTap: onNearby)),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: _ServiceCard(icon: AppIcons.atm, label: 'ATM', onTap: onNearby)),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: _ServiceCard(icon: AppIcons.restaurant, label: 'Food', onTap: onNearby)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Emergency contacts button
                  GhostButton(
                    label: 'Emergency Contacts',
                    icon: AppIcons.emergency,
                    onPressed: () {},
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

class _StatsRow extends StatelessWidget {
  const _StatsRow({this.onBudget, this.onReadiness, this.onNearby});

  final VoidCallback? onBudget;
  final VoidCallback? onReadiness;
  final VoidCallback? onNearby;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          icon: AppIcons.check,
          value: '92%',
          label: 'Readiness',
          onTap: onReadiness,
        ),
        const SizedBox(width: AppSpacing.sm),
        _StatCard(
          icon: AppIcons.wallet,
          value: '₹38K',
          label: 'Budget',
          onTap: onBudget,
        ),
        const SizedBox(width: AppSpacing.sm),
        _StatCard(
          icon: AppIcons.trips,
          value: '12/15',
          label: 'Packing',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.tertiaryFixed.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Row(
        children: [
          const Icon(AppIcons.weather, color: AppColors.tertiary, size: 32),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '12°C · Sunny',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                'Manali forecast for Oct 12',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BudgetWidget extends StatelessWidget {
  const _BudgetWidget({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Budget',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '₹38,000 / ₹45,500',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              child: LinearProgressIndicator(
                value: 38000 / 45500,
                backgroundColor: AppColors.surfaceContainerHigh,
                color: AppColors.secondaryContainer,
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PackingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const items = [
      ('Warm Jacket', true),
      ('Hiking Boots', true),
      ('First Aid Kit', true),
      ('Travel Insurance', false),
      ('Power Bank', true),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Packing List',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                '12 / 15 items',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      item.$2 ? AppIcons.check : AppIcons.pending,
                      color: item.$2 ? AppColors.primary : AppColors.outline,
                      size: 18,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      item.$1,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurface,
                            decoration: item.$2 ? TextDecoration.none : null,
                          ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.icon, required this.label, this.onTap});

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
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
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
