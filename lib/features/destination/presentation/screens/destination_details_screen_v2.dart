import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/destination_detail.dart';

class DestinationDetailsScreen extends StatelessWidget {
  const DestinationDetailsScreen({
    super.key,
    required this.detail,
    this.onPlanTrip,
  });

  final DestinationDetail detail;
  final VoidCallback? onPlanTrip;

  @override
  Widget build(BuildContext context) {
    detail.validate();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _DestinationHero(detail: detail),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _QuickInfoBar(quickInfo: detail.quickInfo),
                  if (detail.quickInfo != null)
                    const SizedBox(height: AppSpacing.lg),
                  _SectionTitle(title: 'About ${detail.destinationName}'),
                  if (detail.description != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      detail.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                  ],
                  if (detail.galleryImageReferences.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _SectionTitle(title: 'Photo Gallery'),
                    const SizedBox(height: AppSpacing.sm),
                    _Gallery(references: detail.galleryImageReferences),
                  ],
                  if (detail.attractions.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _SectionTitle(title: 'Nearby Attractions'),
                    const SizedBox(height: AppSpacing.sm),
                    ...detail.attractions.map(
                      (attraction) => _AttractionTile(
                        attraction: attraction,
                      ),
                    ),
                  ],
                  if (detail.localFood.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _SectionTitle(title: 'Local Food'),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: detail.localFood
                          .map(
                            (food) => Chip(
                              label: Text(food),
                              backgroundColor:
                                  AppColors.tertiaryFixed.withOpacity(0.3),
                              labelStyle:
                                  Theme.of(context).textTheme.labelMedium,
                              side: BorderSide.none,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(AppSpacing.md),
        child: SizedBox(
          height: AppSpacing.buttonHeight,
          child: FilledButton(
            onPressed: onPlanTrip,
            child: Text(
              'Plan a Trip to ${detail.destinationName}',
            ),
          ),
        ),
      ),
    );
  }
}

class _DestinationHero extends StatelessWidget {
  const _DestinationHero({
    required this.detail,
  });

  final DestinationDetail detail;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detail.destinationName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.onPrimary,
                fontSize: 24,
                height: 1.1,
                fontWeight: FontWeight.w700,
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    offset: Offset(0, 2),
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
            if (detail.stateOrRegion != null)
              Text(
                detail.stateOrRegion!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 13,
                  height: 1.2,
                  fontWeight: FontWeight.w400,
                  shadows: [
                    Shadow(
                      blurRadius: 6,
                      offset: Offset(0, 1),
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
          ],
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (detail.heroImageReference != null)
              Image.network(
                detail.heroImageReference!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const _HeroFallback();
                },
              )
            else
              const _HeroFallback(),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.0,
                    0.38,
                    1.0,
                  ],
                  colors: [
                    Colors.black26,
                    Colors.transparent,
                    Colors.black87,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroFallback extends StatelessWidget {
  const _HeroFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryContainer,
      child: const Center(
        child: Icon(
          Icons.landscape,
          size: 100,
          color: AppColors.onPrimary,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class _QuickInfoBar extends StatelessWidget {
  const _QuickInfoBar({
    required this.quickInfo,
  });

  final DestinationQuickInfo? quickInfo;

  @override
  Widget build(BuildContext context) {
    final metrics = <(IconData, String, String)>[
      if (quickInfo?.weatherLabel != null)
        (AppIcons.weather, quickInfo!.weatherLabel!, 'Weather'),
      if (quickInfo?.travelPeriodLabel != null)
        (AppIcons.calendar, quickInfo!.travelPeriodLabel!, 'Best Time'),
      if (quickInfo?.budgetLabel != null)
        (AppIcons.currency, quickInfo!.budgetLabel!, 'Budget'),
      if (quickInfo?.durationLabel != null)
        (AppIcons.trips, quickInfo!.durationLabel!, 'Duration'),
    ];

    if (metrics.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: AppColors.outlineVariant,
        ),
      ),
      child: Row(
        children: List.generate(
          metrics.length,
          (index) {
            final metric = metrics[index];

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMd,
                            ),
                          ),
                          child: Icon(
                            metric.$1,
                            color: AppColors.onPrimaryContainer,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          metric.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: AppColors.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          metric.$3,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  if (index < metrics.length - 1)
                    Container(
                      width: 1,
                      height: 56,
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                      color: AppColors.outlineVariant,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({
    required this.references,
  });

  final List<String> references;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: references.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
            child: Image.network(
              references[index],
              width: 240,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 240,
                  height: 180,
                  color: AppColors.surfaceContainerLow,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.onSurfaceVariant,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _AttractionTile extends StatelessWidget {
  const _AttractionTile({
    required this.attraction,
  });

  final DestinationAttraction attraction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        backgroundColor: AppColors.primaryContainer,
        child: Icon(
          Icons.place_outlined,
          color: AppColors.onPrimaryContainer,
        ),
      ),
      title: Text(attraction.name),
      trailing: attraction.distanceLabel == null
          ? null
          : Text(
              attraction.distanceLabel!,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
    );
  }
}
