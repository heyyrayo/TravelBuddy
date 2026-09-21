import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../models/accommodation.dart';
import '../../../../providers/accommodation_provider.dart';
import '../../../../shared/widgets/cards/accommodation_card.dart';

class AccommodationListScreen extends StatefulWidget {
  const AccommodationListScreen({
    super.key,
  });

  @override
  State<AccommodationListScreen> createState() =>
      _AccommodationListScreenState();
}

class _AccommodationListScreenState extends State<AccommodationListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  Future<void> _load() async {
    if (!mounted) {
      return;
    }

    final provider = context.read<AccommodationProvider>();

    await Future.wait([
      provider.loadAccommodations(limit: 20),
      provider.loadFilters(),
    ]);
  }

  Future<void> _search(String value) async {
    await context.read<AccommodationProvider>().search(
          value.trim(),
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Find a Stay'),
        backgroundColor: AppColors.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
      ),
      body: Consumer<AccommodationProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _search,
                  decoration: InputDecoration(
                    hintText: 'Search hotels, homestays, resorts...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              provider.clearFilters();
                              provider.loadAccommodations(limit: 20);
                              setState(() {});
                            },
                          ),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusInputButton,
                      ),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // State filter
              SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.states.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(
                    width: AppSpacing.sm,
                  ),
                  itemBuilder: (context, index) {
                    final isAll = index == 0;
                    final state = isAll ? null : provider.states[index - 1];

                    final selected = provider.selectedState == state;

                    return FilterChip(
                      label: Text(state ?? 'All India'),
                      selected: selected,
                      onSelected: (_) {
                        provider.setStateFilter(state);
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

              const SizedBox(
                height: AppSpacing.sm,
              ),

              // Accommodation type filter
              if (provider.accommodationTypes.isNotEmpty)
                SizedBox(
                  height: 44,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.accommodationTypes.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(
                      width: AppSpacing.sm,
                    ),
                    itemBuilder: (context, index) {
                      final isAll = index == 0;
                      final type =
                          isAll ? null : provider.accommodationTypes[index - 1];

                      final selected =
                          provider.selectedAccommodationType == type;

                      return FilterChip(
                        label: Text(type ?? 'All Types'),
                        selected: selected,
                        onSelected: (_) {
                          provider.setAccommodationTypeFilter(type);
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

              const SizedBox(
                height: AppSpacing.md,
              ),

              Expanded(
                child: _buildResults(
                  context,
                  provider,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResults(
    BuildContext context,
    AccommodationProvider provider,
  ) {
    if (provider.isLoading && provider.accommodations.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.hasError && provider.accommodations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            provider.errorMessage ?? 'Unable to load accommodations.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (provider.accommodations.isEmpty) {
      return const Center(
        child: Text('No accommodations found.'),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.refresh(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.xxl,
        ),
        itemCount: provider.accommodations.length,
        separatorBuilder: (_, __) => const SizedBox(
          height: AppSpacing.md,
        ),
        itemBuilder: (context, index) {
          final accommodation = provider.accommodations[index];

          return AccommodationCard(
            accommodation: accommodation,
            onTap: () {
              _showAccommodationDetails(
                context,
                accommodation,
              );
            },
          );
        },
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

