import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/data/app_states.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/buttons/app_buttons.dart';

class ManaliDetailsScreen extends StatelessWidget {
  const ManaliDetailsScreen({
    super.key,
    this.onPlanTrip,
    this.destinationName = 'Manali',
  });

  final VoidCallback? onPlanTrip;
  final String destinationName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // -------------------------------------------------------------------
          // Hero / App Bar
          // -------------------------------------------------------------------

          SliverAppBar(
            expandedHeight: 300,
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
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              ),
            ),
            actions: [
              // ---------------------------------------------------------------
              // Save to Wishlist
              // ---------------------------------------------------------------

              Consumer<TripState>(
                builder: (context, tripState, _) {
                  final destinationId = _destinationId(destinationName);

                  final isSaved = tripState.savedPlaces.any(
                    (place) => place.destinationId == destinationId,
                  );

                  return IconButton(
                    icon: Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                      color: AppColors.onPrimary,
                    ),
                    tooltip: isSaved ? 'Saved to wishlist' : 'Save to wishlist',
                    onPressed: () async {
                      debugPrint(
                        'SAVE BUTTON PRESSED: '
                        '$destinationName ($destinationId)',
                      );

                      if (isSaved) {
                        debugPrint(
                          'PLACE ALREADY SAVED: $destinationId',
                        );

                        if (!context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '$destinationName is already saved.',
                            ),
                          ),
                        );

                        return;
                      }

                      debugPrint(
                        'CALLING TripState.savePlace()',
                      );

                      await tripState.savePlace(
                        destinationId,
                        destinationName,
                      );

                      debugPrint(
                        'TripState.savePlace() COMPLETED',
                      );

                      if (!context.mounted) {
                        return;
                      }

                      if (tripState.errorMessage != null) {
                        debugPrint(
                          'SAVE ERROR: '
                          '${tripState.errorMessage}',
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              tripState.errorMessage!,
                            ),
                          ),
                        );

                        return;
                      }

                      debugPrint(
                        'SAVE SUCCESS: $destinationName',
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '$destinationName saved to your wishlist.',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              // ---------------------------------------------------------------
              // Share
              // ---------------------------------------------------------------

              Semantics(
                label: 'Share',
                child: IconButton(
                  icon: const Icon(
                    AppIcons.share,
                    color: AppColors.onPrimary,
                  ),
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
                        colors: [
                          AppColors.primary,
                          AppColors.primaryContainer,
                        ],
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
                        colors: [
                          Colors.transparent,
                          AppColors.primary,
                        ],
                        stops: [
                          0.5,
                          1.0,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // -------------------------------------------------------------------
          // Main Content
          // -------------------------------------------------------------------

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _QuickInfoBar(),

                  const SizedBox(
                    height: AppSpacing.lg,
                  ),

                  // About
                  Text(
                    'About $destinationName',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  const SizedBox(
                    height: AppSpacing.sm,
                  ),

                  Text(
                    'Nestled in the Kullu Valley of Himachal Pradesh, '
                    '$destinationName is a high-altitude Himalayan resort '
                    'town. Known for its breathtaking landscapes, adventure '
                    'sports, and spiritual significance, it\'s a year-round '
                    'destination loved by backpackers and luxury travelers alike.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),

                  const SizedBox(
                    height: AppSpacing.lg,
                  ),

                  // Photo Gallery
                  Text(
                    'Photo Gallery',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  const SizedBox(
                    height: AppSpacing.sm,
                  ),

                  const _PhotoGallery(),

                  const SizedBox(
                    height: AppSpacing.lg,
                  ),

                  // Nearby Attractions
                  Text(
                    'Nearby Attractions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  const SizedBox(
                    height: AppSpacing.sm,
                  ),

                  ..._attractions.map(
                    (attraction) => _AttractionTile(
                      name: attraction.$1,
                      distance: attraction.$2,
                    ),
                  ),

                  const SizedBox(
                    height: AppSpacing.lg,
                  ),

                  // Local Food
                  Text(
                    'Local Food',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),

                  const SizedBox(
                    height: AppSpacing.sm,
                  ),

                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      'Siddu',
                      'Trout Fish',
                      'Dham',
                      'Babru',
                      'Aktori',
                    ]
                        .map(
                          (food) => Chip(
                            label: Text(food),
                            backgroundColor:
                                AppColors.tertiaryFixed.withOpacity(0.3),
                            labelStyle: Theme.of(context).textTheme.labelMedium,
                            side: BorderSide.none,
                          ),
                        )
                        .toList(),
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

      // -----------------------------------------------------------------------
      // Bottom CTA
      // -----------------------------------------------------------------------

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(
          AppSpacing.md,
        ),
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

  // ===========================================================================
  // Destination ID
  // ===========================================================================

  String _destinationId(
    String name,
  ) {
    return name.trim().toLowerCase().replaceAll(
          RegExp(r'\s+'),
          '_',
        );
  }

  // ===========================================================================
  // Attractions
  // ===========================================================================

  static const _attractions = [
    ('Rohtang Pass', '51 km'),
    ('Solang Valley', '14 km'),
    ('Hadimba Temple', '3 km'),
    ('Beas River', '1 km'),
    ('Mall Road', '0.5 km'),
  ];
}

// =============================================================================
// Quick Info Bar
// =============================================================================

class _QuickInfoBar extends StatelessWidget {
  const _QuickInfoBar();

  @override
  Widget build(BuildContext context) {
    const metrics = [
      (
        AppIcons.weather,
        '12°C',
        'Weather',
      ),
      (
        AppIcons.calendar,
        'Oct–Jun',
        'Best Time',
      ),
      (
        AppIcons.currency,
        '₹₹',
        'Budget',
      ),
      (
        AppIcons.trips,
        '5–7 days',
        'Duration',
      ),
    ];

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
      child: Row(
        children: metrics
            .map(
              (metric) => Expanded(
                child: Column(
                  children: [
                    Icon(
                      metric.$1,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      metric.$2,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      metric.$3,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

// =============================================================================
// Photo Gallery
// =============================================================================

class _PhotoGallery extends StatelessWidget {
  const _PhotoGallery();

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
                borderRadius: BorderRadius.circular(
                  AppSpacing.radiusMd,
                ),
              ),
              child: const Icon(
                Icons.landscape,
                color: AppColors.onPrimaryContainer,
                size: 40,
              ),
            ),
          ),
          const SizedBox(
            width: AppSpacing.sm,
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryContainer,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusMd,
                      ),
                    ),
                    child: const Icon(
                      Icons.water,
                      color: AppColors.onTertiaryContainer,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusMd,
                      ),
                    ),
                    child: const Icon(
                      Icons.ac_unit,
                      color: AppColors.primary,
                      size: 24,
                    ),
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

// =============================================================================
// Attraction Tile
// =============================================================================

class _AttractionTile extends StatelessWidget {
  const _AttractionTile({
    required this.name,
    required this.distance,
  });

  final String name;
  final String distance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        children: [
          const Icon(
            AppIcons.location,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(
            width: AppSpacing.sm,
          ),
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
