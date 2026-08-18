import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/data/app_states.dart';
import '../../../../core/data/trip_repository.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class SavedPlacesScreen extends StatelessWidget {
  const SavedPlacesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tripState = context.watch<TripState>();
    final savedPlaces = tripState.savedPlaces;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Saved Places'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: _buildBody(
        context,
        tripState,
        savedPlaces,
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    TripState tripState,
    List<SavedPlace> savedPlaces,
  ) {
    if (tripState.isLoading && savedPlaces.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (tripState.errorMessage != null && savedPlaces.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
              const SizedBox(
                height: AppSpacing.md,
              ),
              Text(
                'Unable to load saved places',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(
                height: AppSpacing.sm,
              ),
              Text(
                tripState.errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(
                height: AppSpacing.md,
              ),
              FilledButton.icon(
                onPressed: tripState.loadSavedPlaces,
                icon: const Icon(
                  Icons.refresh,
                ),
                label: const Text(
                  'Retry',
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (savedPlaces.isEmpty) {
      return _EmptySavedPlaces(
        onExplore: () {
          Navigator.of(context).pop();
        },
      );
    }

    return RefreshIndicator(
      onRefresh: tripState.loadSavedPlaces,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(
          AppSpacing.md,
        ),
        children: [
          Text(
            '${savedPlaces.length} '
            '${savedPlaces.length == 1 ? 'saved place' : 'saved places'}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
          ),
          const SizedBox(
            height: AppSpacing.md,
          ),
          ...savedPlaces.map(
            (place) => _SavedPlaceCard(
              place: place,
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedPlaceCard extends StatelessWidget {
  const _SavedPlaceCard({
    required this.place,
  });

  final SavedPlace place;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: AppSpacing.sm,
      ),
      color: AppColors.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusCard,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryFixed,
          child: const Icon(
            Icons.favorite,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          place.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(
            top: 4,
          ),
          child: Text(
            place.destinationId,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
        ),
      ),
    );
  }
}

class _EmptySavedPlaces extends StatelessWidget {
  const _EmptySavedPlaces({
    required this.onExplore,
  });

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primaryFixed,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 42,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(
              height: AppSpacing.lg,
            ),
            Text(
              'No Saved Places Yet',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(
              height: AppSpacing.sm,
            ),
            Text(
              'Save your favorite destinations while exploring India. '
              'They will appear here automatically.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(
              height: AppSpacing.lg,
            ),
            FilledButton.icon(
              onPressed: onExplore,
              icon: const Icon(
                Icons.explore_outlined,
              ),
              label: const Text(
                'Explore Places',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
