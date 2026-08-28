import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/travelbuddy_ai_service.dart';

class TravelBuddyAiButton extends StatelessWidget {
  const TravelBuddyAiButton({
    super.key,
    this.context,
    this.showLabel = false,
  });

  final TravelBuddyAiContext? context;
  final bool showLabel;

  void _openAi(BuildContext context) {
    context.push(
      '/travelbuddy-ai',
      extra: this.context,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showLabel) {
      return FilledButton.icon(
        onPressed: () => _openAi(context),
        icon: const Icon(
          Icons.auto_awesome_rounded,
        ),
        label: const Text(
          'TravelBuddy AI',
        ),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(
            0,
            AppSpacing.buttonHeight,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppSpacing.radiusInputButton,
            ),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openAi(context),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(
                  alpha: 0.24,
                ),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.onPrimary,
            size: 25,
          ),
        ),
      ),
    );
  }
}
