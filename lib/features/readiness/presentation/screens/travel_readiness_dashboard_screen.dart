import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';

class TravelReadinessDashboardScreen extends StatefulWidget {
  const TravelReadinessDashboardScreen({super.key});

  @override
  State<TravelReadinessDashboardScreen> createState() =>
      _TravelReadinessDashboardScreenState();
}

class _TravelReadinessDashboardScreenState
    extends State<TravelReadinessDashboardScreen> {
  final _checkItems = [
    _CheckItem('Budget: Confirmed', AppIcons.wallet, CheckStatus.done),
    _CheckItem('Hotel: Booked', AppIcons.hotel, CheckStatus.done),
    _CheckItem('Transport: Ticketed', AppIcons.flight, CheckStatus.done),
    _CheckItem('Packing: 12/15 items', AppIcons.trips, CheckStatus.inProgress),
    _CheckItem('Offline Maps: Downloaded', AppIcons.map, CheckStatus.done),
    _CheckItem('Emergency Contacts: Saved', AppIcons.emergency, CheckStatus.done),
    _CheckItem('Documents: Missing Travel Insurance', AppIcons.document, CheckStatus.error),
  ];

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
        title: const Text('Travel Readiness'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip info
            Row(
              children: [
                const Icon(AppIcons.location, color: AppColors.primary, size: 16),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Manali Trip',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryFixed.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  child: const Text(
                    'Departs in 3 days',
                    style: TextStyle(
                      color: AppColors.tertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Readiness gauge
            Center(child: _ReadinessGauge(percent: 0.92)),
            const SizedBox(height: AppSpacing.lg),

            // Checklist
            Text(
              'Travel Checklist',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            ..._checkItems.map((item) => _ChecklistTile(item: item)),
            const SizedBox(height: AppSpacing.lg),

            // Suggestions
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.errorContainer.withOpacity(0.4),
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
              ),
              child: Row(
                children: [
                  const Icon(AppIcons.warning, color: AppColors.error, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload Travel Insurance Document',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: AppColors.onErrorContainer,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Required for international coverage in mountain regions',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.onErrorContainer,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(AppIcons.upload),
              label: const Text('Upload Document'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.onError,
                minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusInputButton),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _ReadinessGauge extends StatelessWidget {
  const _ReadinessGauge({required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: percent,
            strokeWidth: 12,
            backgroundColor: AppColors.surfaceContainerHigh,
            color: percent > 0.85 ? AppColors.primary : AppColors.secondary,
            strokeCap: StrokeCap.round,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(percent * 100).toInt()}%',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                'Ready',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum CheckStatus { done, inProgress, error }

class _CheckItem {
  const _CheckItem(this.label, this.icon, this.status);

  final String label;
  final IconData icon;
  final CheckStatus status;
}

class _ChecklistTile extends StatelessWidget {
  const _ChecklistTile({required this.item});

  final _CheckItem item;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (item.status) {
      CheckStatus.done => (AppColors.primary, AppIcons.check),
      CheckStatus.inProgress => (AppColors.secondary, AppIcons.pending),
      CheckStatus.error => (AppColors.error, AppIcons.warning),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              item.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: item.status == CheckStatus.error
                        ? AppColors.error
                        : AppColors.onSurface,
                  ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}
