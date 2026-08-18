import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.onComplete});

  final VoidCallback? onComplete;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: const Cubic(0.2, 0.0, 0.0, 1.0),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,
                  AppColors.primaryContainer,
                ],
              ),
            ),
          ),
          CustomPaint(
            painter: _TopoPainterSplash(),
          ),
          FadeTransition(
            opacity: _fadeIn,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TravelBuddy horizontal brand mark.
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: Image.asset(
                    'assets/images/travelbuddy_horizontal.png',
                    width: 260,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                Text(
                  'Explore India with Confidence.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onPrimary.withOpacity(0.8),
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.xxl),

                SizedBox(
                  width: 160,
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.onPrimary.withOpacity(0.2),
                    color: AppColors.secondaryContainer,
                    minHeight: 3,
                    borderRadius: BorderRadius.circular(
                      AppSpacing.radiusPill,
                    ),
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

class _TopoPainterSplash extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (var i = 0; i < 8; i++) {
      final path = Path();
      final y = size.height * (i / 8);

      path.moveTo(0, y);

      path.cubicTo(
        size.width * 0.25,
        y - 40,
        size.width * 0.5,
        y + 20,
        size.width * 0.75,
        y - 20,
      );

      path.cubicTo(
        size.width * 0.9,
        y - 30,
        size.width,
        y + 10,
        size.width,
        y,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

