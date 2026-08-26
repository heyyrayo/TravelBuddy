import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/destination_images.dart';
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
          // ===================================================================
          // HERO / APP BAR
          // ===================================================================

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
              // ----------------------------------------------------------------
              // Wishlist
              // ----------------------------------------------------------------

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

              // ----------------------------------------------------------------
              // Share
              // ----------------------------------------------------------------

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

            // ------------------------------------------------------------------
            // Hero image
            // ------------------------------------------------------------------

            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destinationName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  const Text(
                    'Himachal Pradesh, India',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // ------------------------------------------------------------
                  // Real destination image
                  // ------------------------------------------------------------

                  Image.network(
                    DestinationImages.hero(destinationName),
                    fit: BoxFit.cover,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return _heroFallback();
                    },
                    loadingBuilder: (
                      context,
                      child,
                      progress,
                    ) {
                      if (progress == null) {
                        return child;
                      }

                      return _heroLoading();
                    },
                  ),

                  // ------------------------------------------------------------
                  // Dark overlay
                  // ------------------------------------------------------------

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.18),
                          Colors.transparent,
                          AppColors.primary.withOpacity(0.92),
                        ],
                        stops: const [
                          0.0,
                          0.45,
                          1.0,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===================================================================
          // MAIN CONTENT
          // ===================================================================

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ----------------------------------------------------------------
                  // Quick info
                  // ----------------------------------------------------------------

                  const _QuickInfoBar(),

                  const SizedBox(
                    height: AppSpacing.lg,
                  ),

                  // ----------------------------------------------------------------
                  // About
                  // ----------------------------------------------------------------

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

                  // ----------------------------------------------------------------
                  // Photo Gallery
                  // ----------------------------------------------------------------

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

                  _PhotoGallery(
                    destinationName: destinationName,
                  ),

                  const SizedBox(
                    height: AppSpacing.lg,
                  ),

                  // ----------------------------------------------------------------
                  // Nearby Attractions
                  // ----------------------------------------------------------------

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

                  // ----------------------------------------------------------------
                  // Local Food
                  // ----------------------------------------------------------------

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
                    ].map(
                      (food) {
                        return Chip(
                          label: Text(food),
                          backgroundColor:
                              AppColors.tertiaryFixed.withOpacity(0.3),
                          labelStyle: Theme.of(context).textTheme.labelMedium,
                          side: BorderSide.none,
                        );
                      },
                    ).toList(),
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

      // =======================================================================
      // BOTTOM CTA
      // =======================================================================

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

  String _destinationId(String name) {
    return name.trim().toLowerCase().replaceAll(
          RegExp(r'\s+'),
          '_',
        );
  }

  // ===========================================================================
  // Hero loading state
  // ===========================================================================

  static Widget _heroLoading() {
    return Container(
      color: AppColors.primaryContainer,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.onPrimary,
        ),
      ),
    );
  }

  // ===========================================================================
  // Hero fallback
  // ===========================================================================

  static Widget _heroFallback() {
    return Container(
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
      child: const Center(
        child: Icon(
          Icons.landscape,
          size: 100,
          color: AppColors.onPrimary,
        ),
      ),
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
        children: metrics.map(
          (metric) {
            return Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    metric.$3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}

// =============================================================================
// Photo Gallery
// =============================================================================

class _PhotoGallery extends StatelessWidget {
  const _PhotoGallery({
    required this.destinationName,
  });

  final String destinationName;

  @override
  Widget build(BuildContext context) {
    final images = DestinationImages.gallery(destinationName);

    return SizedBox(
      height: 180,
      child: Row(
        children: [
          // ---------------------------------------------------------------
          // Main image
          // ---------------------------------------------------------------

          Expanded(
            flex: 2,
            child: _GalleryImage(
              url: images[0],
              borderRadius: BorderRadius.circular(
                AppSpacing.radiusMd,
              ),
            ),
          ),

          const SizedBox(
            width: AppSpacing.sm,
          ),

          // ---------------------------------------------------------------
          // Side images
          // ---------------------------------------------------------------

          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _GalleryImage(
                    url: images[1],
                    borderRadius: BorderRadius.circular(
                      AppSpacing.radiusMd,
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                Expanded(
                  child: _GalleryImage(
                    url: images[2],
                    borderRadius: BorderRadius.circular(
                      AppSpacing.radiusMd,
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
// Gallery Image
// =============================================================================

class _GalleryImage extends StatelessWidget {
  const _GalleryImage({
    required this.url,
    required this.borderRadius,
  });

  final String url;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox.expand(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return Container(
              color: AppColors.primaryContainer,
              child: const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.onPrimaryContainer,
                  size: 32,
                ),
              ),
            );
          },
          loadingBuilder: (
            context,
            child,
            loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child;
            }

            return Container(
              color: AppColors.surfaceContainerLow,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            );
          },
        ),
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurface,
                  ),
            ),
          ),
          const SizedBox(
            width: AppSpacing.sm,
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
