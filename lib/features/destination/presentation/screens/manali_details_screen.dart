import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/buttons/app_buttons.dart';

class ManaliDetailsScreen extends StatelessWidget {
  const ManaliDetailsScreen({super.key, this.onPlanTrip, this.destinationName = 'Manali'});

  final VoidCallback? onPlanTrip;
  final String destinationName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero image app bar
          SliverAppBar(
            expandedHeight: 300,
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
            actions: [
              Semantics(
                label: 'Save to wishlist',
                child: IconButton(
                  icon: const Icon(AppIcons.heartOutline, color: AppColors.onPrimary),
                  tooltip: 'Save to wishlist',
                  onPressed: () {},
                ),
              ),
              Semantics(
                label: 'Share',
                child: IconButton(
                  icon: const Icon(AppIcons.share, color: AppColors.onPrimary),
                  tooltip: 'Share',
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destinationName,
                    style: const TextStyle(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Himachal Pradesh, India',
                    style: TextStyle(
                      color: AppColors.onPrimary.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, AppColors.primaryContainer],
                      ),
                    ),
                  ),
                  // Hero illustration placeholder
                  Center(
                    child: Icon(
                      Icons.landscape,
                      size: 120,
                      color: AppColors.onPrimary.withOpacity(0.15),
                    ),
                  ),
                  // Gradient overlay for text legibility
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.primary],
                        stops: [0.5, 1.0],
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
                  // Quick info metrics
                  _QuickInfoBar(),
                  const SizedBox(height: AppSpacing.lg),

                  // About section
                  Text(
                    'About $destinationName',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Nestled in the Kullu Valley of Himachal Pradesh, $destinationName is a high-altitude Himalayan resort town. Known for its breathtaking landscapes, adventure sports, and spiritual significance, it\'s a year-round destination loved by backpackers and luxury travelers alike.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Photo gallery
                  Text(
                    'Photo Gallery',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _PhotoGallery(),
                  const SizedBox(height: AppSpacing.lg),

                  // Nearby attractions
                  Text(
                    'Nearby Attractions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ..._attractions.map((a) => _AttractionTile(name: a.$1, distance: a.$2)),

                  const SizedBox(height: AppSpacing.lg),

                  // Local food
                  Text(
                    'Local Food',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: ['Siddu', 'Trout Fish', 'Dham', 'Babru', 'Aktori']
                        .map((f) => Chip(
                              label: Text(f),
                              backgroundColor: AppColors.tertiaryFixed.withOpacity(0.3),
                              labelStyle: Theme.of(context).textTheme.labelMedium,
                              side: BorderSide.none,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          boxShadow: AppColors.level2Shadow,
        ),
        child: SafeArea(
          child: CtaButton(
            label: 'Plan a Trip to $destinationName',
            onPressed: onPlanTrip,
            icon: AppIcons.add,
          ),
        ),
      ),
    );
  }

  static const _attractions = [
    ('Rohtang Pass', '51 km'),
    ('Solang Valley', '14 km'),
    ('Hadimba Temple', '3 km'),
    ('Beas River', '1 km'),
    ('Mall Road', '0.5 km'),
  ];
}

class _QuickInfoBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const metrics = [
      (AppIcons.weather, '12°C', 'Weather'),
      (AppIcons.calendar, 'Oct–Jun', 'Best Time'),
      (AppIcons.currency, '₹₹', 'Budget'),
      (AppIcons.trips, '5–7 days', 'Duration'),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Row(
        children: metrics
            .map((m) => Expanded(
                  child: Column(
                    children: [
                      Icon(m.$1, color: AppColors.primary, size: 20),
                      const SizedBox(height: 4),
                      Text(
                        m.$2,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        m.$3,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _PhotoGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: const Icon(Icons.landscape, color: AppColors.onPrimaryContainer, size: 40),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: const Icon(Icons.water, color: AppColors.onTertiaryContainer, size: 24),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: const Icon(Icons.ac_unit, color: AppColors.primary, size: 24),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AttractionTile extends StatelessWidget {
  const _AttractionTile({required this.name, required this.distance});

  final String name;
  final String distance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(AppIcons.location, color: AppColors.primary, size: 16),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurface,
                  ),
            ),
          ),
          Text(
            distance,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
