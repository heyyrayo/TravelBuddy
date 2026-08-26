import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/cards/travel_card.dart';

class RecommendedForYouScreen extends StatelessWidget {
  const RecommendedForYouScreen({
    super.key,
    this.onDestinationTap,
  });

  final ValueChanged<String>? onDestinationTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        title: const Text('Recommended for You'),
        actions: [
          Semantics(
            label: 'Filter',
            child: IconButton(
              icon: const Icon(AppIcons.filter),
              tooltip: 'Filter',
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -----------------------------------------------------------------
            // Intro
            // -----------------------------------------------------------------

            Text(
              'Tailored for your travel style',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),

            const SizedBox(
              height: AppSpacing.md,
            ),

            // -----------------------------------------------------------------
            // Featured recommendation
            // -----------------------------------------------------------------

            _FeaturedCard(
              title: 'Rishikesh',
              subtitle:
                  'Ideal for a spiritual retreat and thrilling river rapids',
              tags: const [
                'Perfect for Students',
                'Adventure',
                'Solo/Friends',
              ],
              season: 'Sep–Nov',
              imageUrl: 'https://picsum.photos/seed/rishikesh-featured/900/500',
              onTap: () {
                onDestinationTap?.call('Rishikesh');
              },
            ),

            const SizedBox(
              height: AppSpacing.lg,
            ),

            // -----------------------------------------------------------------
            // Recommendation grid
            //
            // IMPORTANT:
            // Use a deterministic height instead of childAspectRatio.
            // This prevents fractional-pixel overflow on different devices.
            // -----------------------------------------------------------------

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              mainAxisExtent: 300,
              children: [
                // -------------------------------------------------------------
                // Munnar
                // -------------------------------------------------------------

                TravelCard(
                  title: 'Munnar',
                  subtitle: 'Kerala · Hill Stations',
                  imageUrl: 'https://picsum.photos/seed/munnar/400/300',
                  onTap: () {
                    onDestinationTap?.call('Munnar');
                  },
                  badge: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusPill,
                      ),
                    ),
                    child: const Text(
                      'Family Friendly',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // -------------------------------------------------------------
                // Jaisalmer
                // -------------------------------------------------------------

                TravelCard(
                  title: 'Jaisalmer',
                  subtitle: 'Rajasthan · Heritage',
                  imageUrl: 'https://picsum.photos/seed/jaisalmer/400/300',
                  onTap: () {
                    onDestinationTap?.call('Jaisalmer');
                  },
                  badge: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryContainer,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusPill,
                      ),
                    ),
                    child: const Text(
                      'Heritage',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.onTertiaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // -------------------------------------------------------------
                // Gokarna
                // -------------------------------------------------------------

                TravelCard(
                  title: 'Gokarna',
                  subtitle: 'Karnataka · Beaches',
                  imageUrl: 'https://picsum.photos/seed/gokarna/400/300',
                  onTap: () {
                    onDestinationTap?.call('Gokarna');
                  },
                ),

                // -------------------------------------------------------------
                // Coorg
                // -------------------------------------------------------------

                TravelCard(
                  title: 'Coorg',
                  subtitle: 'Karnataka · Hill Stations',
                  imageUrl: 'https://picsum.photos/seed/coorg/400/300',
                  onTap: () {
                    onDestinationTap?.call('Coorg');
                  },
                  badge: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusPill,
                      ),
                    ),
                    child: const Text(
                      'Budget',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: AppSpacing.xxl,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Featured Recommendation Card
// =============================================================================

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.season,
    required this.imageUrl,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final List<String> tags;
  final String season;
  final String imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(
            AppSpacing.radiusBanner,
          ),
          boxShadow: AppColors.level2Shadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -----------------------------------------------------------------
            // Featured image
            // -----------------------------------------------------------------

            SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Container(
                        color: AppColors.primary,
                        child: const Center(
                          child: Icon(
                            Icons.landscape,
                            size: 80,
                            color: Colors.white24,
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
                        color: AppColors.primary,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),

                  // Image overlay
                  Container(
                    color: AppColors.primary.withOpacity(0.28),
                  ),

                  // -----------------------------------------------------------------
                  // Tags
                  // -----------------------------------------------------------------

                  Positioned(
                    top: AppSpacing.md,
                    left: AppSpacing.md,
                    right: 56,
                    child: Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: tags.map(
                        (tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusPill,
                              ),
                            ),
                            child: Text(
                              tag,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.onSecondaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),

                  // -----------------------------------------------------------------
                  // Wishlist button
                  // -----------------------------------------------------------------

                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: Semantics(
                      label: 'Save to wishlist',
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: const Icon(
                            AppIcons.heartOutline,
                            color: AppColors.onPrimary,
                          ),
                          tooltip: 'Save to wishlist',
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // -----------------------------------------------------------------
            // Featured content
            // -----------------------------------------------------------------

            Padding(
              padding: const EdgeInsets.all(
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(
                    height: AppSpacing.xs,
                  ),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onPrimary.withOpacity(0.8),
                        ),
                  ),
                  const SizedBox(
                    height: AppSpacing.sm,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        AppIcons.calendar,
                        size: 14,
                        color: AppColors.onPrimaryContainer,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Flexible(
                        child: Text(
                          'Best Season: $season',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.onPrimaryContainer,
                                  ),
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
