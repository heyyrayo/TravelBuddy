import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/buttons/app_buttons.dart';

class ErrorGpsDisabledScreen extends StatelessWidget {
  const ErrorGpsDisabledScreen({super.key, this.onEnableGps, this.onManualEntry});

  final VoidCallback? onEnableGps;
  final VoidCallback? onManualEntry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    AppIcons.gpsOff,
                    size: 56,
                    color: AppColors.outline,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Where are you?',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'We need your location to find nearby essentials, local experiences, and hidden gems around you',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: 'Enable GPS',
                  icon: AppIcons.gps,
                  onPressed: onEnableGps,
                ),
                const SizedBox(height: AppSpacing.md),
                GhostButton(
                  label: 'Enter Location Manually',
                  onPressed: onManualEntry,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
