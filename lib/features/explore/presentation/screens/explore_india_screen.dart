import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/destination_images.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../models/accommodation.dart';
import '../../../../providers/accommodation_provider.dart';
import '../../../../shared/widgets/cards/accommodation_card.dart';
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
  bool _accommodationsLoaded = false;

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

  String _imageForDestination(String destination) {
    return DestinationImages.hero(destination);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAccommodations();
    });
  }

  Future<void> _loadAccommodations() async {
    if (_accommodationsLoaded || !mounted) {
      return;
    }

    _accommodationsLoaded = true;

    final provider = context.read<AccommodationProvider>();

    await Future.wait([
      provider.loadAccommodations(limit: 8),
      provider.loadFilters(),
    ]);
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
          // DESTINATIONS
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

          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
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
                    imageUrl: _imageForDestination(name),
                    onTap: () {
                      widget.onDestinationTap?.call(name);
                    },
                    badge: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color:
                            AppColors.secondaryContainer.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusPill,
                        ),
                      ),
                      child: Text(
                        destination.$3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.onSecondaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
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
          // NIDHI+ ACCOMMODATIONS
          // ===================================================================

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.xxl,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Verified Stays & Accommodations',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.push('/home/explore/accommodations');
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  ),
                  Consumer<AccommodationProvider>(
                    builder: (context, provider, _) {
                      if (provider.totalCount == 0) {
                        return const SizedBox.shrink();
                      }

                      return Text(
                        '${provider.totalCount} stays',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Consumer<AccommodationProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.accommodations.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(AppSpacing.xxl),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (provider.hasError && provider.accommodations.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: _AccommodationMessage(
                      icon: Icons.error_outline,
                      message: provider.errorMessage ??
                          'Unable to load accommodations.',
                    ),
                  );
                }

                if (provider.accommodations.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: _AccommodationMessage(
                      icon: Icons.hotel_outlined,
                      message: 'No accommodations found.',
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Column(
                    children: [
                      for (final accommodation in provider.accommodations)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.md,
                          ),
                          child: AccommodationCard(
                            accommodation: accommodation,
                            onTap: () {
                              _showAccommodationDetails(
                                context,
                                accommodation,
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                );
              },
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

  void _showAccommodationDetails(
    BuildContext context,
    Accommodation accommodation,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  accommodation.displayName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(
                  height: AppSpacing.sm,
                ),
                Text(
                  accommodation.typeLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                Text(
                  accommodation.address,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: AppSpacing.md,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(
                      width: AppSpacing.sm,
                    ),
                    Expanded(
                      child: Text(
                        accommodation.locationLabel,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                if (accommodation.isPincodeKnown) ...[
                  const SizedBox(
                    height: AppSpacing.sm,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.pin_drop_outlined,
                        size: 20,
                        color: AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(
                        width: AppSpacing.sm,
                      ),
                      Text(
                        accommodation.pincodeLabel,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AccommodationMessage extends StatelessWidget {
  const _AccommodationMessage({
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
      ),
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusCard,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.onSurfaceVariant,
          ),
          const SizedBox(
            width: AppSpacing.md,
          ),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}




