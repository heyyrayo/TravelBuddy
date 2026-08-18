import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../shared/widgets/buttons/app_buttons.dart';
import '../../../../shared/widgets/inputs/search_field.dart';
import '../../../../shared/widgets/indicators/step_indicator.dart';

class TripPlannerStep1Screen extends StatefulWidget {
  const TripPlannerStep1Screen({
    super.key,
    this.onNext,
    this.onBack,
  });

  final void Function({
    required String destinationId,
    required String tripName,
    required DateTime startDate,
    required DateTime endDate,
    required int travelers,
  })? onNext;

  final VoidCallback? onBack;

  @override
  State<TripPlannerStep1Screen> createState() => _TripPlannerStep1ScreenState();
}

class _TripPlannerStep1ScreenState extends State<TripPlannerStep1Screen> {
  final _destinationController = TextEditingController();

  final _tripNameController = TextEditingController(
    text: 'My TravelBuddy Trip',
  );

  final _travelersController = TextEditingController(
    text: '1',
  );

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _destinationController.dispose();
    _tripNameController.dispose();
    _travelersController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(
    bool isStart,
  ) async {
    final now = DateTime.now();

    final initialDate = isStart
        ? (_startDate ?? now)
        : (_endDate ??
            (_startDate ?? now).add(
              const Duration(days: 7),
            ));

    final minimumDate = isStart ? now : (_startDate ?? now);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minimumDate,
      lastDate: now.add(
        const Duration(days: 730),
      ),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx),
        child: child!,
      ),
    );

    if (picked == null) {
      return;
    }

    setState(() {
      if (isStart) {
        _startDate = picked;

        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = null;
        }
      } else {
        _endDate = picked;
      }
    });
  }

  void _submit() {
    final destination = _destinationController.text.trim();

    final tripName = _tripNameController.text.trim();

    final travelers = int.tryParse(
          _travelersController.text.trim(),
        ) ??
        0;

    if (destination.isEmpty) {
      _showError(
        'Please enter a destination.',
      );
      return;
    }

    if (_startDate == null) {
      _showError(
        'Please select a start date.',
      );
      return;
    }

    if (_endDate == null) {
      _showError(
        'Please select an end date.',
      );
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      _showError(
        'End date must be after the start date.',
      );
      return;
    }

    if (travelers < 1 || travelers > 100) {
      _showError(
        'Travelers must be between 1 and 100.',
      );
      return;
    }

    final destinationId = _destinationToId(destination);

    widget.onNext?.call(
      destinationId: destinationId,
      tripName: tripName.isEmpty ? 'My TravelBuddy Trip' : tripName,
      startDate: _startDate!,
      endDate: _endDate!,
      travelers: travelers,
    );
  }

  String _destinationToId(
    String destination,
  ) {
    return destination.toLowerCase().trim().replaceAll(',', '').replaceAll(
          RegExp(r'\s+'),
          '-',
        );
  }

  void _showError(
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
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
            icon: const Icon(
              AppIcons.close,
            ),
            tooltip: 'Close',
            onPressed: widget.onBack,
          ),
        ),
        title: const Text(
          'Plan Your Trip',
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(
              AppSpacing.md,
            ),
            child: LinearStepIndicator(
              currentStep: 1,
              totalSteps: 8,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryFixed.withOpacity(
                        0.3,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusCard,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          AppIcons.map,
                          size: 60,
                          color: AppColors.tertiary,
                        ),
                        Positioned(
                          top: 40,
                          left: 100,
                          child: Icon(
                            AppIcons.location,
                            color: AppColors.primary,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.xl,
                  ),
                  Text(
                    'Where and when are you headed?',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(
                    height: AppSpacing.xs,
                  ),
                  Text(
                    'Let\'s start building your itinerary.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(
                    height: AppSpacing.lg,
                  ),
                  AppTextField(
                    label: 'Trip Name',
                    controller: _tripNameController,
                    prefixIcon: const Icon(
                      Icons.edit_outlined,
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.md,
                  ),
                  AppTextField(
                    label: 'Destination',
                    controller: _destinationController,
                    prefixIcon: const Icon(
                      AppIcons.location,
                    ),
                    hintText: 'e.g. Manali, Goa, Jaipur',
                  ),
                  const SizedBox(
                    height: AppSpacing.md,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickDate(true),
                          child: AbsorbPointer(
                            child: AppTextField(
                              label: 'Start Date',
                              controller: TextEditingController(
                                text: _startDate == null
                                    ? ''
                                    : _formatDate(
                                        _startDate!,
                                      ),
                              ),
                              prefixIcon: const Icon(
                                AppIcons.calendar,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: AppSpacing.md,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickDate(false),
                          child: AbsorbPointer(
                            child: AppTextField(
                              label: 'End Date',
                              controller: TextEditingController(
                                text: _endDate == null
                                    ? ''
                                    : _formatDate(
                                        _endDate!,
                                      ),
                              ),
                              prefixIcon: const Icon(
                                AppIcons.calendar,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSpacing.md,
                  ),
                  AppTextField(
                    label: 'Number of Travelers',
                    controller: _travelersController,
                    prefixIcon: const Icon(
                      AppIcons.group,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: AppSpacing.xxl,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(
              AppSpacing.md,
            ),
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
                  const SizedBox(
                    width: AppSpacing.md,
                  ),
                  Expanded(
                    flex: 2,
                    child: CtaButton(
                      label: 'Next: Travel Style',
                      onPressed: _submit,
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

  static String _formatDate(
    DateTime date,
  ) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
