import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/constants/app_icons.dart';

/// Pill-shaped search field with topographic watermark element.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hintText = 'Search destinations...',
    this.readOnly = false,
    this.onTap,
    this.autofocus = false,
    this.showMicButton = false,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool autofocus;
  final bool showMicButton;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: hintText,
      textField: true,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(color: AppColors.outlineVariant),
          boxShadow: AppColors.level2Shadow,
        ),
        child: Row(
          children: [
            const SizedBox(width: AppSpacing.md),
            const Icon(AppIcons.search, color: AppColors.onSurfaceVariant, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                readOnly: readOnly,
                onTap: onTap,
                autofocus: autofocus,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.outline),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            // Topographic watermark — subtle brand element
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: _TopographicWatermark(),
            ),
            if (showMicButton) ...[
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(AppIcons.mic, color: AppColors.onSurfaceVariant),
                iconSize: 20,
                tooltip: 'Voice search',
                onPressed: () {},
                padding: const EdgeInsets.all(AppSpacing.sm),
                constraints: const BoxConstraints(),
              ),
            ],
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}

/// Subtle topographic contour watermark near the trailing edge.
class _TopographicWatermark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 36,
      child: CustomPaint(
        painter: _TopoPainter(),
      ),
    );
  }
}

class _TopoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw subtle contour lines
    for (var i = 0; i < 3; i++) {
      final path = Path();
      final yBase = size.height * (0.25 + i * 0.25);
      path.moveTo(0, yBase);
      path.cubicTo(
        size.width * 0.3,
        yBase - 8,
        size.width * 0.6,
        yBase + 6,
        size.width,
        yBase - 4,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Standard outlined text field with floating label.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.autofillHints,
    this.textInputAction,
    this.onFieldSubmitted,
    this.enabled = true,
  });

  final String label;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusInputButton),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
