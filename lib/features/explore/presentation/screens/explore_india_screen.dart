import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/cards/travel_card.dart';
import '../../../../shared/widgets/inputs/search_field.dart';

class ExploreIndiaScreen extends StatefulWidget {
  const ExploreIndiaScreen({super.key, this.onDestinationTap, this.onSearchTap});

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

  static const _destinations = [
    ('Manali', 'Himachal Pradesh', '₹₹', 'Hill Stations', 'https://picsum.photos/seed/manali/400/300'),
    ('Goa', 'Goa', '₹₹', 'Beaches', 'https://picsum.photos/seed/goa/400/300'),
    ('Jaipur', 'Rajasthan', '₹₹', 'Heritage', 'https://picsum.photos/seed/jaipur/400/300'),
    ('Rishikesh', 'Uttarakhand', '₹', 'Adventure', 'https://picsum.photos/seed/rishikesh/400/300'),
    ('Kerala Backwaters', 'Kerala', '₹₹₹', 'Beaches', 'https://picsum.photos/seed/kerala/400/300'),
    ('Ranthambore', 'Rajasthan', '₹₹₹', 'Wildlife', 'https://picsum.photos/seed/ranthambore/400/300'),
    ('Varanasi', 'Uttar Pradesh', '₹', 'Religious', 'https://picsum.photos/seed/varanasi/400/300'),
    ('Munnar', 'Kerala', '₹₹', 'Hill Stations', 'https://picsum.photos/seed/munnar/400/300'),
    ('Jaisalmer', 'Rajasthan', '₹₹', 'Heritage', 'https://picsum.photos/seed/jaisalmer/400/300'),
    ('Gokarna', 'Karnataka', '₹', 'Beaches', 'https://picsum.photos/seed/gokarna/400/300'),
  ];

  List<(String, String, String, String, String)> get _filteredDestinations {
    if (_selectedCategory == 0) return _destinations;
    final cat = _categories[_selectedCategory];
    return _destinations.where((d) => d.$4 == cat).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: AppColors.surfaceContainerLowest,
            surfaceTintColor: Colors.transparent,
            title: const Text('Explore India'),
            actions: [
              Semantics(
                label: 'Search',
                child: IconButton(
                  icon: const Icon(AppIcons.search),
                  tooltip: 'Search',
                  onPressed: widget.onSearchTap,
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
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
          // Category chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 52,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (ctx, i) => FilterChip(
                  label: Text(_categories[i]),
                  selected: _selectedCategory == i,
                  onSelected: (_) => setState(() => _selectedCategory = i),
                  backgroundColor: AppColors.surfaceContainerLow,
                  selectedColor: AppColors.primaryFixed,
                  checkmarkColor: AppColors.primary,
                  labelStyle: Theme.of(ctx).textTheme.labelMedium?.copyWith(
                        color: _selectedCategory == i
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant,
                      ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                    side: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.md),
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
          // Destination grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
              ),
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  final d = _filteredDestinations[i];
                  return TravelCard(
                    title: d.$1,
                    subtitle: d.$2,
                    imageUrl: d.$5,
                    onTap: () => widget.onDestinationTap?.call(d.$1),
                    badge: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer.withOpacity(0.9),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusPill),
                      ),
                      child: Text(
                        d.$3,
                        style:
                            Theme.of(ctx).textTheme.labelSmall?.copyWith(
                                  color: AppColors.onSecondaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                    footer: Row(
                      children: [
                        const Icon(AppIcons.tag,
                            size: 12, color: AppColors.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          d.$4,
                          style: Theme.of(ctx)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  );
                },
                childCount: _filteredDestinations.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xxl),
          ),
        ],
      ),
    );
  }
}
