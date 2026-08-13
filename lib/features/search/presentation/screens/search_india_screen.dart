import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/inputs/search_field.dart';
import '../../../../shared/widgets/states/app_states.dart';

class SearchIndiaScreen extends StatefulWidget {
  const SearchIndiaScreen({super.key, this.onDestinationTap});

  final ValueChanged<String>? onDestinationTap;

  @override
  State<SearchIndiaScreen> createState() => _SearchIndiaScreenState();
}

class _SearchIndiaScreenState extends State<SearchIndiaScreen> {
  final _controller = TextEditingController();
  String _query = '';
  bool _hasSearched = false;

  static const _trending = [
    'Goa Beaches', 'Jaipur Forts', 'Manali Trekking',
    'Kerala Ayurvedic Retreats', 'Leh Ladakh', 'Hampi'
  ];

  static const _recent = [
    'Rishikesh', 'Munnar', 'Andaman Islands',
  ];

  static const _allDestinations = [
    'Manali', 'Goa', 'Jaipur', 'Rishikesh', 'Kerala Backwaters',
    'Ranthambore', 'Varanasi', 'Munnar', 'Jaisalmer', 'Gokarna',
    'Leh Ladakh', 'Hampi', 'Andaman Islands', 'Coorg', 'Darjeeling',
  ];

  List<String> get _results {
    if (_query.isEmpty) return [];
    return _allDestinations
        .where((d) => d.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          onChanged: (v) => setState(() {
            _query = v;
            _hasSearched = v.isNotEmpty;
          }),
          onSubmitted: (v) => setState(() {
            _query = v;
            _hasSearched = true;
          }),
        ),
        leading: Semantics(
          label: 'Back',
          child: IconButton(
            icon: const Icon(AppIcons.back),
            tooltip: 'Back',
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        leadingWidth: 48,
      ),
      body: _hasSearched && results.isEmpty
          ? EmptyStateWidget(
              illustrationAsset: 'assets/images/empty_no_search_results.png',
              headline: 'Unknown Territory',
              body:
                  "We couldn't find anything matching your search. Try searching for 'Hill Stations' or 'Goa'",
              primaryActionLabel: 'Explore Trends',
              onPrimaryAction: () =>
                  setState(() { _controller.clear(); _query = ''; _hasSearched = false; }),
              secondaryActionLabel: 'Search Again',
              onSecondaryAction: () => setState(() { _query = ''; _hasSearched = false; }),
              useCta: true,
            )
          : _hasSearched
              ? ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: results.length,
                  itemBuilder: (ctx, i) => ListTile(
                    leading: const Icon(AppIcons.location, color: AppColors.primary),
                    title: Text(results[i]),
                    onTap: () => widget.onDestinationTap?.call(results[i]),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
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
                            const SizedBox(height: AppSpacing.sm),
                            Wrap(
                              spacing: AppSpacing.sm,
                              runSpacing: AppSpacing.sm,
                              children: _trending
                                  .map((t) => ActionChip(
                                        label: Text(t),
                                        onPressed: () {
                                          _controller.text = t;
                                          setState(() {
                                            _query = t;
                                            _hasSearched = true;
                                          });
                                        },
                                        backgroundColor:
                                            AppColors.surfaceContainerLow,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppSpacing.radiusPill),
                                          side: BorderSide.none,
                                        ),
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              color: AppColors.onSurfaceVariant,
                                            ),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: AppSpacing.lg),
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
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) => ListTile(
                          leading: const Icon(AppIcons.back,
                              color: AppColors.onSurfaceVariant),
                          title: Text(_recent[i]),
                          trailing: const Icon(AppIcons.chevronRight),
                          onTap: () {
                            _controller.text = _recent[i];
                            setState(() {
                              _query = _recent[i];
                              _hasSearched = true;
                            });
                          },
                        ),
                        childCount: _recent.length,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Text(
                          'Browse by Category',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppColors.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: AppSpacing.sm,
                          mainAxisSpacing: AppSpacing.sm,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (ctx, i) {
                            final cats = [
                              ('Hill Stations', AppIcons.hiking),
                              ('Beaches', AppIcons.beach),
                              ('Heritage', AppIcons.temple),
                              ('Adventure', AppIcons.explore),
                              ('Wildlife', AppIcons.forest),
                              ('Religious', AppIcons.temple),
                            ];
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusCard),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(cats[i].$2,
                                        color: AppColors.primary, size: 20),
                                    const SizedBox(height: 4),
                                    Text(
                                      cats[i].$1,
                                      style: Theme.of(ctx)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: 6,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                        child: SizedBox(height: AppSpacing.xxl)),
                  ],
                ),
    );
  }
}
