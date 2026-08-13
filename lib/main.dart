import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_spacing.dart';
import 'core/state/auth_state.dart';
import 'core/state/onboarding_state.dart';
import 'core/state/connectivity_state.dart';
import 'core/data/destination_repository.dart';
import 'core/data/trip_repository.dart';
import 'core/data/app_states.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent states
  final authState = AuthState();
  final onboardingState = OnboardingState();
  final connectivityState = ConnectivityState();

  await authState.init();
  await onboardingState.init();
  await connectivityState.init();

  // Repositories
  final destRepo = InMemoryDestinationRepository();
  final tripRepo = InMemoryTripRepository();

  // Domain states
  final destinationState = DestinationState(destRepo);
  final tripState = TripState(tripRepo);
  final budgetState = BudgetState();
  final recommendationState = RecommendationState();
  final notificationState = AppNotificationState();

  // Pre-load destinations
  await destinationState.loadAll();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authState),
        ChangeNotifierProvider.value(value: onboardingState),
        ChangeNotifierProvider.value(value: connectivityState),
        ChangeNotifierProvider.value(value: destinationState),
        ChangeNotifierProvider.value(value: tripState),
        ChangeNotifierProvider.value(value: budgetState),
        ChangeNotifierProvider.value(value: recommendationState),
        ChangeNotifierProvider.value(value: notificationState),
      ],
      child: const TravelBuddyApp(),
    ),
  );
}

class TravelBuddyApp extends StatefulWidget {
  const TravelBuddyApp({super.key});

  @override
  State<TravelBuddyApp> createState() => _TravelBuddyAppState();
}

class _TravelBuddyAppState extends State<TravelBuddyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = buildRouter(context);
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = context.watch<ConnectivityState>().isOnline;

    return MaterialApp.router(
      title: 'TravelBuddy India',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      builder: (ctx, child) {
        // Full-screen offline overlay (shown on top of everything when offline)
        if (!isOnline) {
          return Stack(
            children: [
              if (child != null) child,
              Positioned.fill(
                child: Material(
                  color: AppColors.background,
                  child: SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusCard),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                'assets/images/empty_no_internet.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              'Off the Grid?',
                              style: Theme.of(ctx)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                    color: AppColors.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              "You're currently offline. Check your connection to continue exploring India",
                              style:
                                  Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
