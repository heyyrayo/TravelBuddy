import 'package:flutter/material.dart';

import '../../domain/recommendation_presentation.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/cards/travel_card.dart';

class RecommendedForYouScreen extends StatelessWidget {
  const RecommendedForYouScreen({
    super.key,
    required this.recommendations,
    this.onDestinationTap,
  });

  final List<RecommendationPresentation> recommendations;
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
              onPressed: null,
            ),
          ),
        ],
      ),
      body: recommendations.isEmpty
          ? _EmptyRecommendations()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommendations based on available travel evidence',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _RecommendationGrid(
                    recommendations: recommendations,
                    onDestinationTap: onDestinationTap,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
    );
  }
}

class _RecommendationGrid extends StatelessWidget {
  const _RecommendationGrid({
    required this.recommendations,
    this.onDestinationTap,
  });

  final List<RecommendationPresentation> recommendations;
  final ValueChanged<String>? onDestinationTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: recommendations.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        mainAxisExtent: 300,
      ),
      itemBuilder: (context, index) {
        final recommendation = recommendations[index];

        return TravelCard(
          title: recommendation.destinationName,
          subtitle: recommendation.stateOrRegion,
          imageUrl: recommendation.imageReference,
          onTap: () {
            onDestinationTap?.call(recommendation.destinationId);
          },
          footer: _RecommendationEvidence(
            explanation: recommendation.explanation,
            signals: recommendation.supportedSignals,
          ),
        );
      },
    );
  }
}

class _RecommendationEvidence extends StatelessWidget {
  const _RecommendationEvidence({
    required this.explanation,
    required this.signals,
  });

  final String explanation;
  final List<String> signals;

  @override
  Widget build(BuildContext context) {
    final visibleSignals = signals
        .map((signal) => signal.trim())
        .where((signal) => signal.isNotEmpty)
        .take(3)
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          explanation,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
        if (visibleSignals.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: visibleSignals.map((signal) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(
                    AppSpacing.radiusPill,
                  ),
                ),
                child: Text(
                  signal,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class _EmptyRecommendations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.travel_explore,
              size: 56,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No recommendations available',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Recommendations will appear when validated recommendation data is available.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
