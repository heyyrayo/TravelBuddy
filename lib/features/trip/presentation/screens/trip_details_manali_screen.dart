import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/data/app_states.dart';
import '../../../../core/data/itinerary_item.dart';
import '../../../../core/data/trip_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';

class TripDetailsManaliScreen extends StatefulWidget {
  const TripDetailsManaliScreen({
    super.key,
    required this.trip,
    this.onBudget,
    this.onReadiness,
    this.onNearby,
  });

  final Trip trip;
  final VoidCallback? onBudget;
  final VoidCallback? onReadiness;
  final VoidCallback? onNearby;

  @override
  State<TripDetailsManaliScreen> createState() =>
      _TripDetailsManaliScreenState();
}

class _TripDetailsManaliScreenState extends State<TripDetailsManaliScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context.read<TripState>().loadItinerary(widget.trip.id);
    });
  }

  @override
  void didUpdateWidget(covariant TripDetailsManaliScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.trip.id == widget.trip.id) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context.read<TripState>().loadItinerary(widget.trip.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final destinationName = _destinationName(widget.trip.destinationId);
    final tripState = context.watch<TripState>();
    final savedPlaces = tripState.savedPlaces
        .where(
          (place) =>
              _normalizeDestinationId(place.destinationId) ==
              _normalizeDestinationId(widget.trip.destinationId),
        )
        .toList();
    final durationLabel = _durationLabel(
      widget.trip.startDate,
      widget.trip.endDate,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
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
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.lg,
              ),
              title: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.trip.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      destinationName,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.onPrimary.withOpacity(0.8),
                          ),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.tertiary,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: -24,
                    bottom: -24,
                    child: Icon(
                      Icons.landscape,
                      size: 180,
                      color: AppColors.onPrimary.withOpacity(0.08),
                    ),
                  ),
                  Positioned(
                    left: AppSpacing.md,
                    top: 84,
                    child: _InfoPill(
                      icon: AppIcons.location,
                      label: destinationName,
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.xxl,
                    right: AppSpacing.md,
                    child: _StatusBadge(
                      status: widget.trip.status,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      _InfoPill(
                        icon: AppIcons.calendar,
                        label:
                            '${_formatDate(widget.trip.startDate)} - ${_formatDate(widget.trip.endDate)}',
                      ),
                      _InfoPill(
                        icon: AppIcons.group,
                        label:
                            '${widget.trip.travelers} ${widget.trip.travelers == 1 ? 'traveler' : 'travelers'}',
                      ),
                      _InfoPill(
                        icon: AppIcons.calendar,
                        label: durationLabel,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionHeader(title: 'Quick Actions'),
                  const SizedBox(height: AppSpacing.sm),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 1.32,
                    children: [
                      _QuickActionCard(
                        icon: AppIcons.wallet,
                        label: 'Budget',
                        caption: 'Manage spending',
                        onTap: widget.onBudget,
                      ),
                      _QuickActionCard(
                        icon: AppIcons.check,
                        label: 'Readiness',
                        caption: 'Trip checklist',
                        onTap: widget.onReadiness,
                      ),
                      _QuickActionCard(
                        icon: AppIcons.location,
                        label: 'Nearby',
                        caption: 'Essentials around you',
                        onTap: widget.onNearby,
                      ),
                      _QuickActionCard(
                        icon: AppIcons.explore,
                        label: 'Explore',
                        caption: 'Coming soon',
                        onTap: null,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionHeader(title: 'Trip Overview'),
                  const SizedBox(height: AppSpacing.sm),
                  _TripOverviewCard(
                    destinationName: destinationName,
                    trip: widget.trip,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionHeader(title: 'Itinerary'),
                  const SizedBox(height: AppSpacing.sm),
                  _buildItinerarySection(
                    context,
                    tripState,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionHeader(title: 'Saved Places'),
                  const SizedBox(height: AppSpacing.sm),
                  if (tripState.isLoadingSavedPlaces && savedPlaces.isEmpty)
                    const _SavedPlacesLoadingCard()
                  else if (savedPlaces.isNotEmpty)
                    _SavedPlacesList(places: savedPlaces)
                  else
                    _EmptyFeatureCard(
                      icon: AppIcons.heart,
                      title: 'No saved places yet',
                      subtitle:
                          'Saved destinations and favorite spots will appear here when available.',
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItinerarySection(
    BuildContext context,
    TripState tripState,
  ) {
    final tripId = widget.trip.id;
    final items = tripState.itineraryForTrip(tripId);
    final error = tripState.itineraryErrorForTrip(tripId);

    if (tripState.isLoadingItinerary(tripId) && items.isEmpty) {
      return const _ItineraryLoadingCard();
    }

    if (error != null && items.isEmpty) {
      return _ItineraryErrorCard(
        onRetry: () => tripState.loadItinerary(tripId),
      );
    }

    if (items.isEmpty) {
      return _ItineraryEmptyCard(
        onAdd: () => _showItineraryForm(context),
      );
    }

    final itemsByDay = <int, List<ItineraryItem>>{};
    for (final item in items) {
      itemsByDay.putIfAbsent(item.dayNumber, () => []).add(item);
    }

    final days = itemsByDay.keys.toList()..sort();

    return Column(
      children: [
        for (final dayNumber in days)
          _ItineraryDaySection(
            dayNumber: dayNumber,
            date: _dayDate(dayNumber),
            items: itemsByDay[dayNumber]!,
            onEdit: (item) => _showItineraryForm(
              context,
              item: item,
            ),
            onDelete: (item) => _confirmDeleteItineraryItem(
              context,
              item,
            ),
          ),
        const SizedBox(height: AppSpacing.xs),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: () => _showItineraryForm(context),
            icon: const Icon(AppIcons.add, size: 18),
            label: const Text('Add activity'),
          ),
        ),
      ],
    );
  }

  DateTime _dayDate(int dayNumber) {
    return widget.trip.startDate.add(
      Duration(days: dayNumber - 1),
    );
  }

  Future<void> _showItineraryForm(
    BuildContext context, {
    ItineraryItem? item,
  }) async {
    final tripState = context.read<TripState>();
    final duration = _tripDuration;
    final existingItems = tripState.itineraryForTrip(widget.trip.id);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.surfaceContainerLowest,
      builder: (sheetContext) {
        return _ItineraryForm(
          item: item,
          duration: duration,
          initialDay: item?.dayNumber ?? _defaultDay(existingItems),
          onSave: (draft) async {
            final savedItem = item == null
                ? await tripState.addItineraryItem(
                    _newItineraryItem(
                      draft,
                      _nextSortOrder(existingItems, draft.dayNumber),
                    ),
                  )
                : await tripState.updateItineraryItem(
                    item.copyWith(
                      dayNumber: draft.dayNumber,
                      title: draft.title,
                      category: draft.category,
                      location: draft.location,
                      description: draft.description,
                      sortOrder: draft.dayNumber == item.dayNumber
                          ? item.sortOrder
                          : _nextSortOrder(
                              existingItems
                                  .where((existing) => existing.id != item.id)
                                  .toList(),
                              draft.dayNumber,
                            ),
                    ),
                  );

            if (savedItem != null && sheetContext.mounted) {
              Navigator.of(sheetContext).pop();
              return null;
            }

            return 'Unable to save this activity. Please try again.';
          },
        );
      },
    );
  }

  Future<void> _confirmDeleteItineraryItem(
    BuildContext context,
    ItineraryItem item,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete this activity?'),
          content: Text(
            'Remove "${item.title}" from your itinerary?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    final tripState = context.read<TripState>();
    final deleted = await tripState.deleteItineraryItem(
      widget.trip.id,
      item.id,
    );

    if (!deleted && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to delete this activity. Please try again.'),
        ),
      );
    }
  }

  ItineraryItem _newItineraryItem(
    _ItineraryDraft draft,
    int sortOrder,
  ) {
    return ItineraryItem(
      id: '',
      tripId: widget.trip.id,
      dayNumber: draft.dayNumber,
      title: draft.title,
      category: draft.category,
      location: draft.location,
      description: draft.description,
      sortOrder: sortOrder,
    );
  }

  int get _tripDuration {
    final days =
        widget.trip.endDate.difference(widget.trip.startDate).inDays + 1;
    return days < 1 ? 1 : days;
  }

  static int _defaultDay(List<ItineraryItem> items) {
    if (items.isEmpty) {
      return 1;
    }

    return items.last.dayNumber;
  }

  static int _nextSortOrder(
    List<ItineraryItem> items,
    int dayNumber,
  ) {
    final dayItems = items.where((item) => item.dayNumber == dayNumber);
    if (dayItems.isEmpty) {
      return 0;
    }

    return dayItems
            .map((item) => item.sortOrder)
            .reduce((left, right) => left > right ? left : right) +
        1;
  }

  static String _destinationName(String destinationId) {
    if (destinationId.trim().isEmpty) {
      return 'Unknown destination';
    }

    return destinationId
        .replaceAll('-', ' ')
        .split(' ')
        .map(
          (part) => part.isEmpty
              ? part
              : '${part[0].toUpperCase()}${part.substring(1)}',
        )
        .join(' ');
  }

  static String _normalizeDestinationId(String destinationId) {
    return destinationId
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[\s_-]+'), '');
  }

  static String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  static String _durationLabel(DateTime startDate, DateTime endDate) {
    final days = endDate.difference(startDate).inDays + 1;
    if (days <= 0) {
      return '1 day';
    }
    return '$days ${days == 1 ? 'day' : 'days'}';
  }

  static String _statusLabel(TripStatus status) {
    switch (status) {
      case TripStatus.planning:
        return 'Planning';
      case TripStatus.upcoming:
        return 'Upcoming';
      case TripStatus.active:
        return 'Active';
      case TripStatus.completed:
        return 'Completed';
    }
  }

  static Color _statusColor(TripStatus status) {
    switch (status) {
      case TripStatus.planning:
        return AppColors.secondaryContainer;
      case TripStatus.upcoming:
        return AppColors.primary.withOpacity(0.12);
      case TripStatus.active:
        return AppColors.tertiaryContainer.withOpacity(0.5);
      case TripStatus.completed:
        return AppColors.surfaceContainerHigh;
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final TripStatus status;

  @override
  Widget build(BuildContext context) {
    final label = _TripDetailsManaliScreenState._statusLabel(status);
    final color = _TripDetailsManaliScreenState._statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.caption,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String caption;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: isEnabled
            ? AppColors.surfaceContainerLow
            : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              border: Border.all(
                color: isEnabled
                    ? AppColors.outlineVariant
                    : AppColors.surfaceContainer,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isEnabled
                        ? AppColors.primary.withOpacity(0.08)
                        : AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: isEnabled
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isEnabled
                            ? AppColors.onSurface
                            : AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TripOverviewCard extends StatelessWidget {
  const _TripOverviewCard({
    required this.destinationName,
    required this.trip,
  });

  final String destinationName;
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final details = [
      _OverviewItem(
        label: 'Destination',
        value: destinationName,
      ),
      _OverviewItem(
        label: 'Dates',
        value:
            '${_TripDetailsManaliScreenState._formatDate(trip.startDate)} - ${_TripDetailsManaliScreenState._formatDate(trip.endDate)}',
      ),
      _OverviewItem(
        label: 'Duration',
        value: _TripDetailsManaliScreenState._durationLabel(
          trip.startDate,
          trip.endDate,
        ),
      ),
      _OverviewItem(
        label: 'Travelers',
        value:
            '${trip.travelers} ${trip.travelers == 1 ? 'traveler' : 'travelers'}',
      ),
      _OverviewItem(
        label: 'Status',
        value: _TripDetailsManaliScreenState._statusLabel(trip.status),
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: Column(
        children: [
          for (int i = 0; i < details.length; i++) ...[
            details[i],
            if (i != details.length - 1) const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  const _OverviewItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 96,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}

class _EmptyFeatureCard extends StatelessWidget {
  const _EmptyFeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
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

class _ItineraryLoadingCard extends StatelessWidget {
  const _ItineraryLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _ItineraryErrorCard extends StatelessWidget {
  const _ItineraryErrorCard({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          const Icon(AppIcons.error, color: AppColors.error),
          const SizedBox(width: AppSpacing.sm),
          const Expanded(
            child: Text('Unable to load this itinerary.'),
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _ItineraryEmptyCard extends StatelessWidget {
  const _ItineraryEmptyCard({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(AppIcons.calendar, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              const Expanded(
                child: Text(
                  'No activities planned yet',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(AppIcons.add, size: 18),
            label: const Text('Add activity'),
          ),
        ],
      ),
    );
  }
}

class _ItineraryDaySection extends StatelessWidget {
  const _ItineraryDaySection({
    required this.dayNumber,
    required this.date,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  final int dayNumber;
  final DateTime date;
  final List<ItineraryItem> items;
  final ValueChanged<ItineraryItem> onEdit;
  final ValueChanged<ItineraryItem> onDelete;

  @override
  Widget build(BuildContext context) {
    final sortedItems = [...items]
      ..sort((left, right) => left.sortOrder.compareTo(right.sortOrder));

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Day $dayNumber',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                _TripDetailsManaliScreenState._formatDate(date),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final item in sortedItems)
            _ItineraryActivityCard(
              item: item,
              onEdit: () => onEdit(item),
              onDelete: () => onDelete(item),
            ),
        ],
      ),
    );
  }
}

class _ItineraryActivityCard extends StatelessWidget {
  const _ItineraryActivityCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final ItineraryItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final metadata = [
      if (item.category != null) item.category!,
      if (item.location != null) item.location!,
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      color: AppColors.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        side: const BorderSide(color: AppColors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.xs,
          AppSpacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(AppIcons.attraction, color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  if (metadata.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      metadata.join(' • '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                  ],
                  if (item.description != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      item.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: onEdit,
              icon: const Icon(AppIcons.edit, size: 18),
              tooltip: 'Edit activity',
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(AppIcons.close, size: 18),
              tooltip: 'Delete activity',
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}

class _ItineraryDraft {
  const _ItineraryDraft({
    required this.dayNumber,
    required this.title,
    required this.category,
    required this.location,
    required this.description,
  });

  final int dayNumber;
  final String title;
  final String? category;
  final String? location;
  final String? description;
}

class _ItineraryForm extends StatefulWidget {
  const _ItineraryForm({
    required this.duration,
    required this.initialDay,
    required this.onSave,
    this.item,
  });

  final ItineraryItem? item;
  final int duration;
  final int initialDay;
  final Future<String?> Function(_ItineraryDraft draft) onSave;

  @override
  State<_ItineraryForm> createState() => _ItineraryFormState();
}

class _ItineraryFormState extends State<_ItineraryForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _categoryController;
  late final TextEditingController _locationController;
  late final TextEditingController _descriptionController;
  late int _selectedDay;
  String? _validationError;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _titleController = TextEditingController(text: item?.title ?? '');
    _categoryController = TextEditingController(text: item?.category ?? '');
    _locationController = TextEditingController(text: item?.location ?? '');
    _descriptionController =
        TextEditingController(text: item?.description ?? '');
    _selectedDay = item?.dayNumber ?? widget.initialDay;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        bottomInset + AppSpacing.md,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.item == null ? 'Add activity' : 'Edit activity',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _titleController,
              autofocus: widget.item == null,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g. Visit Hadimba Temple',
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<int>(
              value: _selectedDay,
              decoration: const InputDecoration(labelText: 'Day'),
              items: [
                for (int day = 1; day <= widget.duration; day++)
                  DropdownMenuItem(
                    value: day,
                    child: Text('Day $day'),
                  ),
              ],
              onChanged: _isSaving
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() => _selectedDay = value);
                      }
                    },
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _categoryController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Category (optional)',
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _locationController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Location (optional)',
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _descriptionController,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
              ),
            ),
            if (_validationError != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                _validationError!,
                style: const TextStyle(color: AppColors.error),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(AppIcons.check),
                label:
                    Text(widget.item == null ? 'Add activity' : 'Save changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      setState(() => _validationError = 'Title is required.');
      return;
    }

    if (_selectedDay < 1 || _selectedDay > widget.duration) {
      setState(() => _validationError = 'Please select a valid trip day.');
      return;
    }

    setState(() {
      _isSaving = true;
      _validationError = null;
    });

    final error = await widget.onSave(
      _ItineraryDraft(
        dayNumber: _selectedDay,
        title: title,
        category: _optionalValue(_categoryController.text),
        location: _optionalValue(_locationController.text),
        description: _optionalValue(_descriptionController.text),
      ),
    );

    if (!mounted) {
      return;
    }

    if (error != null) {
      setState(() {
        _isSaving = false;
        _validationError = error;
      });
    }
  }

  static String? _optionalValue(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}

class _SavedPlacesLoadingCard extends StatelessWidget {
  const _SavedPlacesLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _SavedPlacesList extends StatelessWidget {
  const _SavedPlacesList({required this.places});

  final List<SavedPlace> places;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final place in places) _SavedPlaceCard(place: place),
      ],
    );
  }
}

class _SavedPlaceCard extends StatelessWidget {
  const _SavedPlaceCard({required this.place});

  final SavedPlace place;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      color: AppColors.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryFixed,
          child: const Icon(
            AppIcons.heart,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          place.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
