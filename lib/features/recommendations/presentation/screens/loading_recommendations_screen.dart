import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/states/app_states.dart';

class LoadingRecommendationsScreen extends StatelessWidget {
  const LoadingRecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        title: const Text('Recommendations'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: LoadingStateWidget(
              icon: AppIcons.star,
              message: 'Finding the perfect spot...',
              subMessage: 'Tailoring Indian destinations to your profile',
            ),
          ),
          // Skeleton bento grid
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                ShimmerBox(height: 180, borderRadius: BorderRadius.circular(AppSpacing.radiusBanner)),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(child: ShimmerBox(height: 120, borderRadius: BorderRadius.circular(AppSpacing.radiusCard))),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: ShimmerBox(height: 120, borderRadius: BorderRadius.circular(AppSpacing.radiusCard))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
