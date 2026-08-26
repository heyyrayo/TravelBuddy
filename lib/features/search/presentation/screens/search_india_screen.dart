import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/inputs/search_field.dart';
import '../../../../shared/widgets/states/app_states.dart';

class SearchIndiaScreen extends StatefulWidget {
  const SearchIndiaScreen({
    super.key,
    this.onDestinationTap,
  });

  final ValueChanged<String>? onDestinationTap;

  @override
  State<SearchIndiaScreen> createState() => _SearchIndiaScreenState();
}

class _SearchIndiaScreenState extends State<SearchIndiaScreen> {
  final TextEditingController _controller = TextEditingController();

  String _query = '';
  bool _hasSearched = false;

  static const _trending = [
    'Goa Beaches',
    'Jaipur Forts',
    'Manali Trekking',
    'Kerala Ayurvedic Retreats',
    'Leh Ladakh',
    'Hampi',
  ];

  static const _recent = [
    'Rishikesh',
    'Munnar',
    'Andaman Islands',
  ];

  static const _allDestinations = [
    'Manali',
    'Goa',
    'Jaipur',
    'Rishikesh',
    'Kerala Backwaters',
    'Ranthambore',
    'Varanasi',
    'Munnar',
    'Jaisalmer',
    'Gokarna',
    'Leh Ladakh',
    'Hampi',
    'Andaman Islands',
    'Coorg',
    'Darjeeling',
  ];

  static const _categories = [
    ('Hill Stations', AppIcons.hiking),
    ('Beaches', AppIcons.beach),
    ('Heritage', AppIcons.temple),
    ('Adventure', AppIcons.explore),
    ('Wildlife', AppIcons.forest),
    ('Religious', AppIcons.temple),
  ];

  List<String> get _results {
    final query = _query.trim().toLowerCase();

    if (query.isEmpty) {
      return [];
    }

    return _allDestinations
        .where(
          (destination) => destination.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setSearch(String value) {
    setState(() {
      _query = value;
      _hasSearched = value.trim().isNotEmpty;
    });
  }

  void _clearSearch() {
    _controller.clear();

    setState(() {
      _query = '';
      _hasSearched = false;
    });
  }

  void _selectSearch(String value) {
    _controller.text = value;

    setState(() {
      _query = value;
      _hasSearched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        title: SearchField(
          controller: _controller,
          autofocus: true,
          showMicButton: true,
          hintText: 'Search destinations in India...',
          onChanged: _setSearch,
          onSubmitted: (value) {
            setState(() {
              _query = value;
              _hasSearched = true;
            });
          },
        ),
        leading: Semantics(
          label: 'Back',
          child: IconButton(
            icon: const Icon(AppIcons.back),
            tooltip: 'Back',
            onPressed: () {
              Navigator.of(context).maybePop();
            },
          ),
        ),
        leadingWidth: 48,
      ),
      body: _buildBody(
        context,
        results,
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    List<String> results,
  ) {
    if (_hasSearched && results.isEmpty) {
      return EmptyStateWidget(
        illustrationAsset: 'assets/images/empty_no_search_results.png',
        headline: 'Unknown Territory',
        body: "We couldn't find anything matching your search. "
            "Try searching for 'Hill Stations' or 'Goa'",
        primaryActionLabel: 'Explore Trends',
        onPrimaryAction: _clearSearch,
        secondaryActionLabel: 'Search Again',
        onSecondaryAction: _clearSearch,
        useCta: true,
      );
    }

    if (_hasSearched) {
      return ListView.builder(
        padding: const EdgeInsets.all(
          AppSpacing.md,
        ),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final destination = results[index];

          return Container(
            margin: const EdgeInsets.only(
              bottom: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(
                AppSpacing.radiusMd,
              ),
            ),
            child: ListTile(
              leading: const Icon(
                AppIcons.location,
                color: AppColors.primary,
              ),
              title: Text(
                destination,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                widget.onDestinationTap?.call(
                  destination,
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppSpacing.radiusMd,
                ),
              ),
            ),
          );
        },
      );
    }

    return _buildInitialSearchView(context);
  }

  Widget _buildInitialSearchView(
    BuildContext context,
  ) {
    return CustomScrollView(
      slivers: [
        // ---------------------------------------------------------------------
        // Trending searches
        // ---------------------------------------------------------------------

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trending Searches',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                  children: _trending.map(
                    (trend) {
                      return ActionChip(
                        label: Text(
                          trend,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onPressed: () {
                          _selectSearch(trend);
                        },
                        backgroundColor: AppColors.surfaceContainerLow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusPill,
                          ),
                          side: BorderSide.none,
                        ),
                        labelStyle:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(
                  height: AppSpacing.lg,
                ),
                Text(
                  'Recent Searches',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),

        // ---------------------------------------------------------------------
        // Recent searches
        // ---------------------------------------------------------------------

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final recent = _recent[index];

              return ListTile(
                leading: const Icon(
                  AppIcons.back,
                  color: AppColors.onSurfaceVariant,
                ),
                title: Text(
                  recent,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(
                  AppIcons.chevronRight,
                ),
                onTap: () {
                  _selectSearch(recent);
                },
              );
            },
            childCount: _recent.length,
          ),
        ),

        // ---------------------------------------------------------------------
        // Category heading
        // ---------------------------------------------------------------------

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(
              AppSpacing.md,
            ),
            child: Text(
              'Browse by Category',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),

        // ---------------------------------------------------------------------
        // Category grid
        //
        // IMPORTANT:
        // The previous 1.5 aspect ratio made the cells too shallow.
        // We use mainAxisExtent so the tile has deterministic height.
        // ---------------------------------------------------------------------

        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
          ),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 88,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = _categories[index];

                return Semantics(
                  button: true,
                  label: 'Search ${category.$1}',
                  child: GestureDetector(
                    onTap: () {
                      _selectSearch(category.$1);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusCard,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            category.$2,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Flexible(
                            child: Text(
                              category.$1,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: _categories.length,
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(
            height: AppSpacing.xxl,
          ),
        ),
      ],
    );
  }
}
