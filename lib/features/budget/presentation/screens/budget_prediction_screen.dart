import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/buttons/app_buttons.dart';

class BudgetPredictionScreen extends StatelessWidget {
  const BudgetPredictionScreen({super.key, this.onSave, this.onRecalculate});

  final VoidCallback? onSave;
  final VoidCallback? onRecalculate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        leading: Semantics(
          label: 'Back',
          child: IconButton(
            icon: const Icon(AppIcons.back),
            tooltip: 'Back',
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        title: const Text('Budget Prediction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step indicator
            _BudgetStepIndicator(currentStep: 2),
            const SizedBox(height: AppSpacing.lg),

            // Total budget card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryContainer],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusBanner),
              ),
              child: Column(
                children: [
                  Text(
                    'Your Budget Prediction',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onPrimary,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '₹45,500',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Based on 5 days in Manali for 2 travelers',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onPrimary.withOpacity(0.8),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Breakdown
            Text(
              'Cost Breakdown',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            ..._breakdown.map((item) => _BudgetRow(
                  icon: item.$1,
                  label: item.$2,
                  amount: item.$3,
                  fraction: item.$4,
                  total: 45500,
                )),
            const SizedBox(height: AppSpacing.lg),

            // Savings suggestion card
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.secondaryFixed.withOpacity(0.5),
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              ),
              child: Row(
                children: [
                  const Icon(AppIcons.saveMoney, color: AppColors.secondary, size: 24),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Potential Savings: ₹3,200',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          'Book accommodation 2 weeks earlier to save on hotel rates',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.onSecondaryFixed,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // AI suggestion
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primaryFixed.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.primary, size: 24),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Suggestion',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          'Consider traveling mid-week — fares are typically 15% lower for Kullu–Manali route',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.onSurface,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Actions
            GhostButton(
              label: 'Recalculate',
              icon: AppIcons.refresh,
              onPressed: onRecalculate,
            ),
            const SizedBox(height: AppSpacing.sm),
            CtaButton(
              label: 'Save & Continue',
              onPressed: onSave,
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  static const _breakdown = [
    (AppIcons.hotel, 'Accommodation', 15000, 15000 / 45500),
    (AppIcons.flight, 'Transport', 12000, 12000 / 45500),
    (AppIcons.restaurant, 'Food', 8500, 8500 / 45500),
    (AppIcons.attraction, 'Activities', 6000, 6000 / 45500),
    (AppIcons.store, 'Shopping', 2000, 2000 / 45500),
    (AppIcons.emergency, 'Emergency Buffer', 2000, 2000 / 45500),
  ];
}

class _BudgetRow extends StatelessWidget {
  const _BudgetRow({
    required this.icon,
    required this.label,
    required this.amount,
    required this.fraction,
    required this.total,
  });

  final IconData icon;
  final String label;
  final int amount;
  final double fraction;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed.withOpacity(0.4),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: Theme.of(context).textTheme.labelLarge),
                    Text(
                      '₹${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  child: LinearProgressIndicator(
                    value: fraction,
                    backgroundColor: AppColors.surfaceContainerHigh,
                    color: AppColors.primary,
                    minHeight: 4,
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

class _BudgetStepIndicator extends StatelessWidget {
  const _BudgetStepIndicator({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        final isActive = i + 1 == currentStep;
        final isDone = i + 1 < currentStep;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDone || isActive
                        ? AppColors.primary
                        : AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                ),
              ),
              if (i < 2) const SizedBox(width: 4),
            ],
          ),
        );
      }),
    );
  }
}
