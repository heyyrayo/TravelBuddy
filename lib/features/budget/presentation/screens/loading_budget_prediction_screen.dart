import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/states/app_states.dart';

class LoadingBudgetPredictionScreen extends StatelessWidget {
  const LoadingBudgetPredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Image.asset('assets/images/travelbuddy_logo.png', height: 24, width: 24),
            const SizedBox(width: AppSpacing.sm),
            const Text('TravelBuddy'),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: LoadingStateWidget(
              icon: AppIcons.wallet,
              message: 'Calculating your budget...',
              subMessage: 'Analyzing travel styles and current Indian market rates',
            ),
          ),
          // Skeleton cards
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: ShimmerBox(height: 80, borderRadius: BorderRadius.circular(AppSpacing.radiusCard))),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: ShimmerBox(height: 80, borderRadius: BorderRadius.circular(AppSpacing.radiusCard))),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: ShimmerBox(height: 80, borderRadius: BorderRadius.circular(AppSpacing.radiusCard))),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ShimmerBox(height: 120, borderRadius: BorderRadius.circular(AppSpacing.radiusCard)),
                const SizedBox(height: AppSpacing.md),
                ShimmerBox(height: 80, borderRadius: BorderRadius.circular(AppSpacing.radiusCard)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
