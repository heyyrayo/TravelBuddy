import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/cards/travel_card.dart';

class RecommendedForYouScreen extends StatelessWidget {
  const RecommendedForYouScreen({super.key, this.onDestinationTap});

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
            Text(
              'Tailored for your travel style',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Featured card (large)
            _FeaturedCard(
              title: 'Rishikesh',
              subtitle: 'Ideal for a spiritual retreat and thrilling river rapids',
              tags: const ['Perfect for Students', 'Adventure', 'Solo/Friends'],
              season: 'Sep–Nov',
              onTap: () => onDestinationTap?.call('Rishikesh'),
            ),
            const SizedBox(height: AppSpacing.md),

            // Grid of recommendation cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.85,
              children: [
                TravelCard(
                  title: 'Munnar',
                  subtitle: 'Kerala · Hill Stations',
                  imageUrl: 'https://picsum.photos/seed/munnar/400/300',
                  onTap: () => onDestinationTap?.call('Munnar'),
                  badge: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    ),
                    child: const Text(
                      'Family Friendly',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                TravelCard(
                  title: 'Jaisalmer',
                  subtitle: 'Rajasthan · Heritage',
                  imageUrl: 'https://picsum.photos/seed/jaisalmer/400/300',
                  onTap: () => onDestinationTap?.call('Jaisalmer'),
                  badge: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    ),
                    child: const Text(
                      'Heritage',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.onTertiaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                TravelCard(
                  title: 'Gokarna',
                  subtitle: 'Karnataka · Beaches',
                  imageUrl: 'https://picsum.photos/seed/gokarna/400/300',
                  onTap: () => onDestinationTap?.call('Gokarna'),
                ),
                TravelCard(
                  title: 'Coorg',
                  subtitle: 'Karnataka · Hill Stations',
                  imageUrl: 'https://picsum.photos/seed/coorg/400/300',
                  onTap: () => onDestinationTap?.call('Coorg'),
                  badge: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    ),
                    child: const Text(
                      'Budget',
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
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.season,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final List<String> tags;
  final String season;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusBanner),
          boxShadow: AppColors.level2Shadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 200,
              width: double.infinity,
              color: AppColors.primary,
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.landscape, size: 80, color: Colors.white24),
                  ),
                  Container(color: AppColors.primary.withOpacity(0.4)),
                  Positioned(
                    top: AppSpacing.md,
                    left: AppSpacing.md,
                    child: Wrap(
                      spacing: AppSpacing.xs,
                      children: tags
                          .map((t) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryContainer,
                                  borderRadius:
                                      BorderRadius.circular(AppSpacing.radiusPill),
                                ),
                                child: Text(
                                  t,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.onSecondaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.md,
                    right: AppSpacing.md,
                    child: Semantics(
                      label: 'Save to wishlist',
                      child: IconButton(
                        icon: const Icon(AppIcons.heartOutline,
                            color: AppColors.onPrimary),
                        tooltip: 'Save to wishlist',
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onPrimary.withOpacity(0.8),
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(AppIcons.calendar,
                          size: 14, color: AppColors.onPrimaryContainer),
                      const SizedBox(width: 4),
                      Text(
                        'Best Season: $season',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.onPrimaryContainer,
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
