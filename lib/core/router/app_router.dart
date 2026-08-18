import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/auth_state.dart';
import '../state/onboarding_state.dart';
import '../data/app_states.dart';
import '../data/trip_repository.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_register_screen.dart';
import '../../features/auth/presentation/screens/email_confirmation_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
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
// Main application shell
// ---------------------------------------------------------------------------

class _HomeShell extends StatelessWidget {
  const _HomeShell({
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
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
      final path = state.matchedLocation;

      const publicRoutes = {
        '/splash',
        '/onboarding',
        '/auth',
        '/auth/confirmation',
        '/auth/forgot-password',
        '/auth/reset-password',
      };

      if (path == '/splash') {
        return null;
      }

      if (!onboardingState.hasSeenOnboarding && path != '/onboarding') {
        return '/onboarding';
      }

      if (onboardingState.hasSeenOnboarding &&
          !authState.isAuthenticated &&
          !publicRoutes.contains(path)) {
        return '/auth';
      }

      if (authState.isAuthenticated &&
          (path == '/auth' ||
              path == '/auth/confirmation' ||
              path == '/auth/forgot-password' ||
              path == '/auth/reset-password' ||
              path == '/onboarding')) {
        return '/home';
      }

      return null;
    },
    routes: [
      // ---------------------------------------------------------------------
      // Splash
      // ---------------------------------------------------------------------

      GoRoute(
        path: '/splash',
        builder: (ctx, state) {
          return SplashScreen(
            onComplete: () {
              if (!ctx.mounted) {
                return;
              }

              if (!onboardingState.hasSeenOnboarding) {
                ctx.go('/onboarding');
              } else if (!authState.isAuthenticated) {
                ctx.go('/auth');
              } else {
                ctx.go('/home');
              }
            },
          );
        },
      ),

      // ---------------------------------------------------------------------
      // Onboarding
      // ---------------------------------------------------------------------

      GoRoute(
        path: '/onboarding',
        builder: (ctx, state) {
          return OnboardingScreen(
            onComplete: () async {
              await onboardingState.markSeen();

              if (!ctx.mounted) {
                return;
              }

              ctx.go('/auth');
            },
          );
        },
      ),

      // ---------------------------------------------------------------------
      // Authentication
      // ---------------------------------------------------------------------

      GoRoute(
        path: '/auth',
        builder: (ctx, state) {
          return LoginRegisterScreen(
            onLogin: () async {
              await ctx.read<TripState>().load();

              if (!ctx.mounted) {
                return;
              }

              ctx.go('/home');
            },
            onEmailConfirmationRequired: (email) {
              if (!ctx.mounted) {
                return;
              }

              ctx.push(
                '/auth/confirmation'
                '?email=${Uri.encodeComponent(email)}',
              );
            },
          );
        },
        routes: [
          // -------------------------------------------------------------------
          // Email confirmation
          // -------------------------------------------------------------------

          GoRoute(
            path: 'confirmation',
            builder: (ctx, state) {
              final email = state.uri.queryParameters['email'] ?? '';

              return EmailConfirmationScreen(
                email: email,
                onBackToLogin: () {
                  if (!ctx.mounted) {
                    return;
                  }

                  ctx.go('/auth');
                },
              );
            },
          ),

          // -------------------------------------------------------------------
          // Forgot password
          // -------------------------------------------------------------------

          GoRoute(
            path: 'forgot-password',
            builder: (ctx, state) {
              return ForgotPasswordScreen(
                onBackToLogin: () {
                  if (!ctx.mounted) {
                    return;
                  }

                  ctx.go('/auth');
                },
              );
            },
          ),

          // -------------------------------------------------------------------
          // Reset password
          // -------------------------------------------------------------------

          GoRoute(
            path: 'reset-password',
            builder: (ctx, state) {
              return ResetPasswordScreen(
                onPasswordUpdated: () {
                  if (!ctx.mounted) {
                    return;
                  }

                  ctx.go('/auth');
                },
              );
            },
          ),
        ],
      ),

      // ---------------------------------------------------------------------
      // Notifications
      // ---------------------------------------------------------------------

      GoRoute(
        path: '/notifications',
        builder: (ctx, state) {
          return const NotificationCenterScreen();
        },
      ),

      // ---------------------------------------------------------------------
      // Settings
      // ---------------------------------------------------------------------

      GoRoute(
        path: '/settings',
        builder: (ctx, state) {
          return SettingsScreen(
            onLogout: () async {
              await ctx.read<AuthState>().logout();

              if (!ctx.mounted) {
                return;
              }

              ctx.go('/auth');
            },
          );
        },
      ),

      // ---------------------------------------------------------------------
      // GPS error
      // ---------------------------------------------------------------------

      GoRoute(
        path: '/error/gps',
        builder: (ctx, state) {
          return ErrorGpsDisabledScreen(
            onEnableGps: () => ctx.pop(),
            onManualEntry: () => ctx.pop(),
          );
        },
      ),

      // ---------------------------------------------------------------------
      // Server error
      // ---------------------------------------------------------------------

      GoRoute(
        path: '/error/server',
        builder: (ctx, state) {
          return ErrorServerIssueScreen(
            onRetry: () => ctx.pop(),
            onHome: () => ctx.go('/home'),
          );
        },
      ),

      // ---------------------------------------------------------------------
      // Main shell
      // ---------------------------------------------------------------------

      StatefulShellRoute.indexedStack(
        builder: (ctx, state, shell) {
          return _HomeShell(
            navigationShell: shell,
          );
        },
        branches: [
          // -------------------------------------------------------------------
          // Branch 0 — Home
          // -------------------------------------------------------------------

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (ctx, state) {
                  return HomeDashboardScreen(
                    onPlanTrip: () {
                      ctx.push(
                        '/home/trips/new/planner',
                      );
                    },
                    onTripTap: () async {
                      final tripState = ctx.read<TripState>();

                      await tripState.load();

                      if (!ctx.mounted) {
                        return;
                      }

                      if (tripState.trips.isNotEmpty) {
                        final trip = tripState.trips.first;

                        ctx.push(
                          '/home/trips/${trip.id}',
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),

          // -------------------------------------------------------------------
          // Branch 1 — Explore
          // -------------------------------------------------------------------

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/explore',
                builder: (ctx, state) {
                  return ExploreIndiaScreen(
                    onDestinationTap: (id) {
                      ctx.push(
                        '/home/explore/destination/$id',
                      );
                    },
                    onSearchTap: () {
                      ctx.push(
                        '/home/explore/search',
                      );
                    },
                  );
                },
                routes: [
                  GoRoute(
                    path: 'search',
                    builder: (ctx, state) {
                      return SearchIndiaScreen(
                        onDestinationTap: (id) {
                          ctx.push(
                            '/home/explore/destination/$id',
                          );
                        },
                      );
                    },
                  ),
                  GoRoute(
                    path: 'destination/:id',
                    builder: (ctx, state) {
                      final id = state.pathParameters['id'] ?? 'manali';

                      return ManaliDetailsScreen(
                        destinationName: id.replaceAll('-', ' '),
                        onPlanTrip: () {
                          ctx.push(
                            '/home/trips/new/planner',
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // -------------------------------------------------------------------
          // Branch 2 — Trips
          // -------------------------------------------------------------------

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/trips',
                builder: (ctx, state) {
                  final tripState = ctx.watch<TripState>();

                  if (tripState.isLoading) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (tripState.errorMessage != null) {
                    return Scaffold(
                      body: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(
                            AppSpacing.xl,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 40,
                                color: AppColors.error,
                              ),
                              const SizedBox(
                                height: AppSpacing.md,
                              ),
                              Text(
                                tripState.errorMessage!,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: AppSpacing.md,
                              ),
                              TextButton(
                                onPressed: tripState.load,
                                child: const Text(
                                  'Retry',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  if (!tripState.hasTrips) {
                    return Scaffold(
                      body: EmptyNoTripsScreen(
                        onPlanTrip: () {
                          ctx.push(
                            '/home/trips/new/planner',
                          );
                        },
                      ),
                    );
                  }

                  final firstTrip = tripState.trips.first;

                  return TripDetailsManaliScreen(
                    trip: firstTrip,
                    onBudget: () {
                      ctx.push(
                        '/home/trips/${firstTrip.id}/budget',
                      );
                    },
                    onReadiness: () {
                      ctx.push(
                        '/home/trips/${firstTrip.id}/readiness',
                      );
                    },
                    onNearby: () {
                      ctx.push(
                        '/home/trips/${firstTrip.id}/nearby',
                      );
                    },
                  );
                },
                routes: [
                  // -----------------------------------------------------------
                  // New trip planner
                  // -----------------------------------------------------------

                  GoRoute(
                    path: 'new/planner',
                    builder: (ctx, state) {
                      return TripPlannerStep1Screen(
                        onNext: ({
                          required String destinationId,
                          required String tripName,
                          required DateTime startDate,
                          required DateTime endDate,
                          required int travelers,
                        }) async {
                          final trip = await ctx.read<TripState>().createTrip(
                                name: tripName,
                                destinationId: destinationId,
                                startDate: startDate,
                                endDate: endDate,
                                travelers: travelers,
                              );

                          if (!ctx.mounted) {
                            return;
                          }

                          if (trip != null) {
                            ctx.go(
                              '/home/trips/${trip.id}',
                            );
                            return;
                          }

                          final error = ctx.read<TripState>().errorMessage;

                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                              content: Text(
                                error ?? 'Unable to create trip.',
                              ),
                            ),
                          );
                        },
                        onBack: () => ctx.pop(),
                      );
                    },
                  ),

                  // -----------------------------------------------------------
                  // Individual trip
                  // -----------------------------------------------------------

                  GoRoute(
                    path: ':tripId',
                    builder: (ctx, state) {
                      final tripId = state.pathParameters['tripId'];

                      final tripState = ctx.watch<TripState>();

                      Trip? trip;

                      for (final item in tripState.trips) {
                        if (item.id == tripId) {
                          trip = item;
                          break;
                        }
                      }

                      if (trip == null) {
                        return Scaffold(
                          body: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(
                                AppSpacing.xl,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.travel_explore_outlined,
                                    size: 48,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(
                                    height: AppSpacing.md,
                                  ),
                                  const Text(
                                    'Trip not found',
                                  ),
                                  const SizedBox(
                                    height: AppSpacing.md,
                                  ),
                                  TextButton(
                                    onPressed: () => ctx.go(
                                      '/home/trips',
                                    ),
                                    child: const Text(
                                      'Back to Trips',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return TripDetailsManaliScreen(
                        trip: trip,
                        onBudget: () {
                          ctx.push(
                            '/home/trips/$tripId/budget',
                          );
                        },
                        onReadiness: () {
                          ctx.push(
                            '/home/trips/$tripId/readiness',
                          );
                        },
                        onNearby: () {
                          ctx.push(
                            '/home/trips/$tripId/nearby',
                          );
                        },
                      );
                    },
                    routes: [
                      // ---------------------------------------------------------
                      // Planner
                      // ---------------------------------------------------------

                      GoRoute(
                        path: 'planner',
                        builder: (ctx, state) {
                          return TripPlannerStep1Screen(
                            onNext: ({
                              required String destinationId,
                              required String tripName,
                              required DateTime startDate,
                              required DateTime endDate,
                              required int travelers,
                            }) async {
                              final trip =
                                  await ctx.read<TripState>().createTrip(
                                        name: tripName,
                                        destinationId: destinationId,
                                        startDate: startDate,
                                        endDate: endDate,
                                        travelers: travelers,
                                      );

                              if (!ctx.mounted) {
                                return;
                              }

                              if (trip != null) {
                                ctx.go(
                                  '/home/trips/${trip.id}',
                                );
                              }
                            },
                            onBack: () => ctx.pop(),
                          );
                        },
                      ),

                      // ---------------------------------------------------------
                      // Budget
                      // ---------------------------------------------------------

                      GoRoute(
                        path: 'budget',
                        builder: (ctx, state) {
                          final budgetState = ctx.watch<BudgetState>();

                          if (budgetState.status == AsyncStatus.idle) {
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) {
                                ctx.read<BudgetState>().calculateBudget(
                                      destination: 'travel',
                                      days: 5,
                                      travelers: 1,
                                    );
                              },
                            );

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
                              onHome: () {
                                ctx.go('/home');
                              },
                            );
                          }

                          return BudgetPredictionScreen(
                            onSave: () => ctx.pop(),
                            onRecalculate: () {
                              ctx.read<BudgetState>().reset();
                            },
                          );
                        },
                      ),

                      // ---------------------------------------------------------
                      // Readiness
                      // ---------------------------------------------------------

                      GoRoute(
                        path: 'readiness',
                        builder: (ctx, state) {
                          return const TravelReadinessDashboardScreen();
                        },
                      ),

                      // ---------------------------------------------------------
                      // Nearby
                      // ---------------------------------------------------------

                      GoRoute(
                        path: 'nearby',
                        builder: (ctx, state) {
                          return const NearbyEssentialsScreen();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // -----------------------------------------------------------------
          // Branch 3 — Recommendations
          // -----------------------------------------------------------------

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/recommendations',
                builder: (ctx, state) {
                  final recommendationState = ctx.watch<RecommendationState>();

                  if (recommendationState.status == AsyncStatus.idle) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        ctx.read<RecommendationState>().load();
                      },
                    );

                    return const LoadingRecommendationsScreen();
                  }

                  if (recommendationState.status == AsyncStatus.loading) {
                    return const LoadingRecommendationsScreen();
                  }

                  if (recommendationState.status == AsyncStatus.error) {
                    return ErrorServerIssueScreen(
                      onRetry: () {
                        ctx.read<RecommendationState>().load();
                      },
                      onHome: () {
                        ctx.go('/home');
                      },
                    );
                  }

                  if (!recommendationState.hasRecommendations) {
                    return Scaffold(
                      body: EmptyNoRecommendationsScreen(
                        onSetPreferences: () {},
                        onExplore: () {
                          ctx.go('/home/explore');
                        },
                      ),
                    );
                  }

                  return RecommendedForYouScreen(
                    onDestinationTap: (id) {
                      ctx.push(
                        '/home/explore/destination/$id',
                      );
                    },
                  );
                },
              ),
            ],
          ),

          // -----------------------------------------------------------------
          // Branch 4 — Profile
          // -----------------------------------------------------------------

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/profile',
                builder: (ctx, state) {
                  return ProfileDashboardScreen(
                    onSettings: () {
                      ctx.push('/settings');
                    },
                    onLogout: () async {
                      await ctx.read<AuthState>().logout();

                      if (!ctx.mounted) {
                        return;
                      }

                      ctx.go('/auth');
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
