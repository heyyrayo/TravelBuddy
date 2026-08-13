import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/buttons/app_buttons.dart';

class ErrorServerIssueScreen extends StatelessWidget {
  const ErrorServerIssueScreen({super.key, this.onRetry, this.onHome});

  final VoidCallback? onRetry;
  final VoidCallback? onHome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusBanner),
                ),
                child: const Center(
                  child: Text(
                    '🐘',
                    style: TextStyle(fontSize: 72),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Our Elephant is Resting',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Something went wrong on our end. We are working on fixing it!',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Try Again',
                onPressed: onRetry,
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: onHome,
                child: Text(
                  'Return to Home',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
