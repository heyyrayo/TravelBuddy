import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/buttons/app_buttons.dart';
import '../../../../shared/widgets/inputs/search_field.dart';
import '../../../../shared/widgets/indicators/step_indicator.dart';

class TripPlannerStep1Screen extends StatefulWidget {
  const TripPlannerStep1Screen({super.key, this.onNext, this.onBack});

  final VoidCallback? onNext;
  final VoidCallback? onBack;

  @override
  State<TripPlannerStep1Screen> createState() => _TripPlannerStep1ScreenState();
}

class _TripPlannerStep1ScreenState extends State<TripPlannerStep1Screen> {
  final _destinationCtrl = TextEditingController(text: 'Manali, Himachal Pradesh');
  DateTime? _startDate = DateTime(2024, 10, 12);
  DateTime? _endDate = DateTime(2024, 10, 18);

  @override
  void dispose() {
    _destinationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now().add(const Duration(days: 7))),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        leading: Semantics(
          label: 'Close',
          child: IconButton(
            icon: const Icon(AppIcons.close),
            tooltip: 'Close',
            onPressed: widget.onBack,
          ),
        ),
        title: const Text('Plan Your Trip'),
      ),
      body: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: LinearStepIndicator(currentStep: 1, totalSteps: 8),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Map preview placeholder
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryFixed.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(AppIcons.map, size: 60, color: AppColors.tertiary),
                        // Location pin overlay
                        Positioned(
                          top: 40,
                          left: 100,
                          child: Icon(AppIcons.location, color: AppColors.primary, size: 32),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Where and when are you headed?',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    "Let's start building your itinerary",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Destination field
                  AppTextField(
                    label: 'Destination',
                    controller: _destinationCtrl,
                    prefixIcon: const Icon(AppIcons.location),
                    hintText: 'e.g. Manali, Goa, Jaipur...',
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Date fields
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickDate(true),
                          child: AbsorbPointer(
                            child: AppTextField(
                              label: 'Start Date',
                              controller: TextEditingController(
                                text: _startDate != null
                                    ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                                    : '',
                              ),
                              prefixIcon: const Icon(AppIcons.calendar),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickDate(false),
                          child: AbsorbPointer(
                            child: AppTextField(
                              label: 'End Date',
                              controller: TextEditingController(
                                text: _endDate != null
                                    ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                    : '',
                              ),
                              prefixIcon: const Icon(AppIcons.calendar),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Travelers picker
                  AppTextField(
                    label: 'Number of Travelers',
                    controller: TextEditingController(text: '2'),
                    prefixIcon: const Icon(AppIcons.group),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
          // Bottom actions
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              boxShadow: AppColors.level2Shadow,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: GhostButton(
                      label: 'Back',
                      onPressed: widget.onBack,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 2,
                    child: CtaButton(
                      label: 'Next: Travel Style',
                      onPressed: widget.onNext,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
