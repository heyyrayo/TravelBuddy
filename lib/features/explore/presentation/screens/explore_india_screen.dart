import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/destination_images.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/cards/travel_card.dart';
import '../../../../shared/widgets/inputs/search_field.dart';

class ExploreIndiaScreen extends StatefulWidget {
  const ExploreIndiaScreen({
    super.key,
    this.onDestinationTap,
    this.onSearchTap,
  });

  final ValueChanged<String>? onDestinationTap;
  final VoidCallback? onSearchTap;

  @override
  State<ExploreIndiaScreen> createState() => _ExploreIndiaScreenState();
}

class _ExploreIndiaScreenState extends State<ExploreIndiaScreen> {
  int _selectedCategory = 0;

  static const _categories = [
    'All',
    'Hill Stations',
    'Beaches',
    'Heritage',
    'Adventure',
    'Wildlife',
    'Religious',
    'Road Trips',
    'Food',
  ];

  // ---------------------------------------------------------------------------
  // Destination catalogue
  //
  // Image URLs are NOT stored here.
  // DestinationImages is the single source of truth for destination images.
  // ---------------------------------------------------------------------------

  static const _destinations = [
    (
      'Manali',
      'Himachal Pradesh',
      '₹₹',
      'Hill Stations',
    ),
    (
      'Goa',
      'Goa',
      '₹₹',
      'Beaches',
    ),
    (
      'Jaipur',
      'Rajasthan',
      '₹₹',
      'Heritage',
    ),
    (
      'Rishikesh',
      'Uttarakhand',
      '₹',
      'Adventure',
    ),
    (
      'Kerala Backwaters',
      'Kerala',
      '₹₹₹',
      'Beaches',
    ),
    (
      'Ranthambore',
      'Rajasthan',
      '₹₹₹',
      'Wildlife',
    ),
    (
      'Varanasi',
      'Uttar Pradesh',
      '₹',
      'Religious',
    ),
    (
      'Munnar',
      'Kerala',
      '₹₹',
      'Hill Stations',
    ),
    (
      'Jaisalmer',
      'Rajasthan',
      '₹₹',
      'Heritage',
    ),
    (
      'Gokarna',
      'Karnataka',
      '₹',
      'Beaches',
    ),
  ];

  List<(String, String, String, String)> get _filteredDestinations {
    if (_selectedCategory == 0) {
      return _destinations;
    }

    final category = _categories[_selectedCategory];

    return _destinations
        .where(
          (destination) => destination.$4 == category,
        )
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Destination image
  // ---------------------------------------------------------------------------

  String _imageForDestination(
    String destination,
  ) {
    return DestinationImages.hero(destination);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ===================================================================
          // APP BAR
          // ===================================================================

          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: AppColors.surfaceContainerLowest,
            surfaceTintColor: Colors.transparent,
            title: const Text(
              'Explore India',
            ),
            actions: [
              Semantics(
                label: 'Search',
                child: IconButton(
                  icon: const Icon(
                    AppIcons.search,
                  ),
                  tooltip: 'Search',
                  onPressed: widget.onSearchTap,
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: GestureDetector(
                  onTap: widget.onSearchTap,
                  child: const SearchField(
                    hintText: 'Search destinations...',
                    readOnly: true,
                  ),
                ),
              ),
            ),
          ),

          // ===================================================================
          // CATEGORY CHIPS
          // ===================================================================

          SliverToBoxAdapter(
            child: SizedBox(
              height: 52,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) {
                  return const SizedBox(
                    width: AppSpacing.sm,
                  );
                },
                itemBuilder: (context, index) {
                  final selected = _selectedCategory == index;

                  return FilterChip(
                    label: Text(
                      _categories[index],
                    ),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = index;
                      });
                    },
                    backgroundColor: AppColors.surfaceContainerLow,
                    selectedColor: AppColors.primaryFixed,
                    checkmarkColor: AppColors.primary,
                    labelStyle:
                        Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant,
                            ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusPill,
                      ),
                      side: BorderSide.none,
                    ),
                  );
                },
              ),
            ),
          ),

          // ===================================================================
          // SECTION TITLE
          // ===================================================================

          SliverPadding(
            padding: const EdgeInsets.all(
              AppSpacing.md,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Trending Destinations',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),

          // ===================================================================
          // DESTINATION GRID
          // ===================================================================

          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,

                // Kept from the previous working fix.
                // Gives TravelCard enough vertical space.
                mainAxisExtent: 300,

                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final destination = _filteredDestinations[index];

                  final name = destination.$1;

                  return TravelCard(
                    title: name,
                    subtitle: destination.$2,

                    // =========================================================
                    // REAL DESTINATION IMAGE
                    // =========================================================
                    imageUrl: _imageForDestination(name),

                    onTap: () {
                      widget.onDestinationTap?.call(
                        name,
                      );
                    },

                    // =========================================================
                    // PRICE BADGE
                    // =========================================================

                    badge: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusPill,
                        ),
                      ),
                      child: Text(
                        destination.$3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.onSecondaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),

                    // =========================================================
                    // CATEGORY FOOTER
                    // =========================================================

                    footer: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          AppIcons.tag,
                          size: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Flexible(
                          child: Text(
                            destination.$4,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: _filteredDestinations.length,
              ),
            ),
          ),

          // ===================================================================
          // BOTTOM SPACING
          // ===================================================================

          const SliverToBoxAdapter(
            child: SizedBox(
              height: AppSpacing.xxl,
            ),
          ),
        ],
      ),
    );
  }
}
