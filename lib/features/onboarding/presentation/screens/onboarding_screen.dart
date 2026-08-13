import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/buttons/app_buttons.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.onComplete});

  final VoidCallback? onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
      title: 'Plan your trip confidently\nacross India',
      body: 'Discover hidden gems and seamless itineraries tailored just for you',
      color: AppColors.primary,
    ),
    _OnboardingPage(
      title: 'AI-powered budget\nplanning',
      body: 'Smart recommendations and nearby essentials for every budget',
      color: AppColors.primaryContainer,
    ),
    _OnboardingPage(
      title: 'Everything you need\nin one place',
      body: 'Peace of mind before and during your journey across India',
      color: AppColors.tertiaryContainer,
    ),
  ];

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: const Cubic(0.2, 0.0, 0.0, 1.0),
    );
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _goToPage(_currentPage + 1);
    } else {
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: TextButton(
                  onPressed: () => _goToPage(_pages.length - 1),
                  child: Text(
                    'Skip',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ),
              ),
            ),
            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (ctx, i) => _OnboardingPageView(
                  page: _pages[i],
                  index: i,
                ),
              ),
            ),
            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == i
                        ? AppColors.primary
                        : AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
              child: Column(
                children: [
                  _currentPage == _pages.length - 1
                      ? CtaButton(
                          label: 'Get Started',
                          onPressed: widget.onComplete,
                        )
                      : PrimaryButton(
                          label: 'Next',
                          onPressed: _next,
                        ),
                  if (_currentPage > 0) ...[
                    const SizedBox(height: AppSpacing.sm),
                    GhostButton(
                      label: 'Back',
                      onPressed: () => _goToPage(_currentPage - 1),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.title,
    required this.body,
    required this.color,
  });

  final String title;
  final String body;
  final Color color;
}

class _OnboardingPageView extends StatelessWidget {
  const _OnboardingPageView({required this.page, required this.index});

  final _OnboardingPage page;
  final int index;

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.explore_outlined,
      Icons.account_balance_wallet_outlined,
      Icons.dashboard_outlined,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusBanner),
            ),
            child: Icon(
              icons[index],
              size: 80,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            page.body,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
