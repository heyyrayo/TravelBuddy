import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/auth_state.dart';
import '../state/onboarding_state.dart';
import '../data/app_states.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_register_screen.dart';
import '../../features/home/presentation/screens/home_dashboard_screen.dart';
import '../../features/explore/presentation/screens/explore_india_screen.dart';
import '../../features/search/presentation/screens/search_india_screen.dart';
import '../../features/destination/presentation/screens/manali_details_screen.dart';
import '../../features/trip/presentation/screens/trip_details_manali_screen.dart';
import '../../features/trip/presentation/screens/trip_planner_step1_screen.dart';
import '../../features/budget/presentation/screens/budget_prediction_screen.dart';
import '../../features/budget/presentation/screens/loading_budget_prediction_screen.dart';
import '../../features/recommendations/presentation/screens/recommended_for_you_screen.dart';
import '../../features/recommendations/presentation/screens/loading_recommendations_screen.dart';
import '../../features/readiness/presentation/screens/travel_readiness_dashboard_screen.dart';
import '../../features/nearby/presentation/screens/nearby_essentials_screen.dart';
import '../../features/notifications/presentation/screens/notification_center_screen.dart';
import '../../features/profile/presentation/screens/profile_dashboard_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/errors/presentation/screens/error_gps_disabled_screen.dart';
import '../../features/errors/presentation/screens/error_server_issue_screen.dart';
import '../../features/errors/presentation/screens/empty_state_screens.dart';
import '../../shared/widgets/nav/app_nav.dart';

// ---------------------------------------------------------------------------
// Shell with bottom navigation
// ---------------------------------------------------------------------------

class _HomeShell extends StatelessWidget {
  const _HomeShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------

GoRouter buildRouter(BuildContext context) {
  final authState = context.read<AuthState>();
  final onboardingState = context.read<OnboardingState>();

  return GoRouter(
    initialLocation: '/splash',
    redirect: (ctx, state) {
      final splashRoutes = {'/splash'};
      final publicRoutes = {'/onboarding', '/auth'};
      final path = state.matchedLocation;

      if (splashRoutes.contains(path)) return null;
      if (!onboardingState.hasSeenOnboarding && !publicRoutes.contains(path)) {
        return '/onboarding';
      }
      if (onboardingState.hasSeenOnboarding &&
          !authState.isAuthenticated &&
          !publicRoutes.contains(path)) {
        return '/auth';
      }
      if (authState.isAuthenticated && publicRoutes.contains(path)) {
        return '/home';
      }
      return null;
    },
    routes: [
      // Splash
      GoRoute(
        path: '/splash',
        builder: (ctx, state) => SplashScreen(
          onComplete: () async {
            if (!onboardingState.hasSeenOnboarding) {
              ctx.go('/onboarding');
            } else if (!authState.isAuthenticated) {
              ctx.go('/auth');
            } else {
              ctx.go('/home');
            }
          },
        ),
      ),
      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (ctx, state) => OnboardingScreen(
          onComplete: () {
            onboardingState.markSeen().then((_) {
              if (ctx.mounted) ctx.go('/auth');
            });
          },
        ),
      ),
      // Auth
      GoRoute(
        path: '/auth',
        builder: (ctx, state) => LoginRegisterScreen(
          onLogin: () async {
            await ctx.read<AuthState>().login('guest@travelbuddy.app', 'guest');
            if (ctx.mounted) ctx.go('/home');
          },
        ),
      ),
      // Notifications (standalone, outside shell)
      GoRoute(
        path: '/notifications',
        builder: (ctx, state) => const NotificationCenterScreen(),
      ),
      // Settings (standalone)
      GoRoute(
        path: '/settings',
        builder: (ctx, state) => SettingsScreen(
          onLogout: () {
            ctx.read<AuthState>().logout().then((_) {
              if (ctx.mounted) ctx.go('/auth');
            });
          },
        ),
      ),
      // GPS error (full-screen)
      GoRoute(
        path: '/error/gps',
        builder: (ctx, state) => ErrorGpsDisabledScreen(
          onEnableGps: () => ctx.pop(),
          onManualEntry: () => ctx.pop(),
        ),
      ),
      // Server error (full-screen)
      GoRoute(
        path: '/error/server',
        builder: (ctx, state) => ErrorServerIssueScreen(
          onRetry: () => ctx.pop(),
          onHome: () => ctx.go('/home'),
        ),
      ),
      // Main shell with bottom nav
      StatefulShellRoute.indexedStack(
        builder: (ctx, state, shell) => _HomeShell(navigationShell: shell),
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (ctx, state) => HomeDashboardScreen(
                  onPlanTrip: () => ctx.push('/home/trips/new/planner'),
                  onTripTap: () => ctx.push('/home/trips/manali'),
                ),
              ),
            ],
          ),
          // Branch 1: Explore
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/explore',
                builder: (ctx, state) => ExploreIndiaScreen(
                  onDestinationTap: (id) => ctx.push('/home/explore/destination/$id'),
                  onSearchTap: () => ctx.push('/home/explore/search'),
                ),
                routes: [
                  GoRoute(
                    path: 'search',
                    builder: (ctx, state) => SearchIndiaScreen(
                      onDestinationTap: (id) => ctx.push('/home/explore/destination/$id'),
                    ),
                  ),
                  GoRoute(
                    path: 'destination/:id',
                    builder: (ctx, state) {
                      final id = state.pathParameters['id'] ?? 'manali';
                      return ManaliDetailsScreen(
                        destinationName: id.replaceAll('-', ' '),
                        onPlanTrip: () => ctx.push('/home/trips/new/planner'),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // Branch 2: Trips
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/trips',
                builder: (ctx, state) {
                  final tripState = ctx.watch<TripState>();
                  if (!tripState.hasTrips) {
                    return Scaffold(
                      body: EmptyNoTripsScreen(
                        onPlanTrip: () => ctx.push('/home/trips/new/planner'),
                      ),
                    );
                  }
                  // Show first trip as default
                  return TripDetailsManaliScreen(
                    onBudget: () => ctx.push('/home/trips/manali/budget'),
                    onReadiness: () => ctx.push('/home/trips/manali/readiness'),
                    onNearby: () => ctx.push('/home/trips/manali/nearby'),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'new/planner',
                    builder: (ctx, state) => TripPlannerStep1Screen(
                      onNext: () {
                        ctx.read<TripState>().createTrip(
                              name: 'Manali Retreat',
                              destinationId: 'manali',
                              startDate: DateTime(2024, 10, 12),
                              endDate: DateTime(2024, 10, 18),
                              travelers: 2,
                            ).then((_) {
                          if (ctx.mounted) ctx.go('/home/trips/manali');
                        });
                      },
                      onBack: () => ctx.pop(),
                    ),
                  ),
                  GoRoute(
                    path: ':tripId',
                    builder: (ctx, state) => TripDetailsManaliScreen(
                      onBudget: () => ctx.push('/home/trips/${state.pathParameters['tripId']}/budget'),
                      onReadiness: () => ctx.push('/home/trips/${state.pathParameters['tripId']}/readiness'),
                      onNearby: () => ctx.push('/home/trips/${state.pathParameters['tripId']}/nearby'),
                    ),
                    routes: [
                      GoRoute(
                        path: 'planner',
                        builder: (ctx, state) => TripPlannerStep1Screen(
                          onNext: () => ctx.pop(),
                          onBack: () => ctx.pop(),
                        ),
                      ),
                      GoRoute(
                        path: 'budget',
                        builder: (ctx, state) {
                          final budgetState = ctx.watch<BudgetState>();
                          if (budgetState.status == AsyncStatus.idle) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ctx.read<BudgetState>().calculateBudget(
                                    destination: 'manali',
                                    days: 5,
                                    travelers: 2,
                                  );
                            });
                            return const LoadingBudgetPredictionScreen();
                          }
                          if (budgetState.status == AsyncStatus.loading) {
                            return const LoadingBudgetPredictionScreen();
                          }
                          if (budgetState.status == AsyncStatus.error) {
                            return ErrorServerIssueScreen(
                              onRetry: () {
                                ctx.read<BudgetState>().reset();
                              },
                              onHome: () => ctx.go('/home'),
                            );
                          }
                          return BudgetPredictionScreen(
                            onSave: () => ctx.pop(),
                            onRecalculate: () => ctx.read<BudgetState>().reset(),
                          );
                        },
                      ),
                      GoRoute(
                        path: 'readiness',
                        builder: (ctx, state) => const TravelReadinessDashboardScreen(),
                      ),
                      GoRoute(
                        path: 'nearby',
                        builder: (ctx, state) => const NearbyEssentialsScreen(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Branch 3: Budget/Recommendations
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/recommendations',
                builder: (ctx, state) {
                  final recState = ctx.watch<RecommendationState>();
                  if (recState.status == AsyncStatus.idle) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ctx.read<RecommendationState>().load();
                    });
                    return const LoadingRecommendationsScreen();
                  }
                  if (recState.status == AsyncStatus.loading) {
                    return const LoadingRecommendationsScreen();
                  }
                  if (recState.status == AsyncStatus.error) {
                    return ErrorServerIssueScreen(
                      onRetry: () => ctx.read<RecommendationState>().load(),
                      onHome: () => ctx.go('/home'),
                    );
                  }
                  if (!recState.hasRecommendations) {
                    return Scaffold(
                      body: EmptyNoRecommendationsScreen(
                        onSetPreferences: () {},
                        onExplore: () => ctx.go('/home/explore'),
                      ),
                    );
                  }
                  return RecommendedForYouScreen(
                    onDestinationTap: (id) => ctx.push('/home/explore/destination/$id'),
                  );
                },
              ),
            ],
          ),
          // Branch 4: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/profile',
                builder: (ctx, state) => ProfileDashboardScreen(
                  onSettings: () => ctx.push('/settings'),
                  onLogout: () {
                    ctx.read<AuthState>().logout().then((_) {
                      if (ctx.mounted) ctx.go('/auth');
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
