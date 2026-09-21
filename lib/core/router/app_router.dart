import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/auth_state.dart';
import '../state/onboarding_state.dart';
import '../data/app_states.dart';
import '../../features/destination/data/destination_detail_demo_data.dart';
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
import '../../features/accommodation/presentation/screens/accommodation_list_screen.dart';
import '../../features/search/presentation/screens/search_india_screen.dart';
import '../../features/destination/presentation/screens/destination_details_screen_v2.dart';

import '../../features/trip/presentation/screens/trip_details_manali_screen.dart';
import '../../features/trip/presentation/screens/trip_planner_step1_screen.dart';

import '../../features/budget/presentation/screens/trip_budget_screen.dart';

import '../../features/recommendations/presentation/screens/recommended_for_you_screen.dart';
import '../../features/recommendations/presentation/screens/loading_recommendations_screen.dart';

import '../../features/readiness/presentation/screens/travel_readiness_dashboard_screen.dart';
import '../../features/nearby/presentation/screens/nearby_essentials_screen.dart';
import '../../features/notifications/presentation/screens/notification_center_screen.dart';

import '../../features/profile/presentation/screens/profile_dashboard_screen.dart';
import '../../features/profile/presentation/screens/saved_places_screen.dart';
import '../../shared/widgets/branding/travelbuddy_ai_logo.dart';

import '../../features/settings/presentation/screens/settings_screen.dart';

import '../../features/errors/presentation/screens/error_gps_disabled_screen.dart';
import '../../features/errors/presentation/screens/error_server_issue_screen.dart';
import '../../features/errors/presentation/screens/empty_state_screens.dart';

import '../../features/ai/data/travelbuddy_ai_service.dart';
import '../../features/ai/presentation/screens/travelbuddy_ai_screen.dart';

import '../../shared/widgets/nav/app_nav.dart';

// ---------------------------------------------------------------------------
// Main application shell
// ---------------------------------------------------------------------------

class _HomeShell extends StatelessWidget {
  const _HomeShell({
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  // ===========================================================================
  // QUIT DIALOG
  // ===========================================================================

  Future<void> _handleQuitRequest(BuildContext context) async {
    final shouldQuit = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.errorContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.logout_rounded,
              color: AppColors.error,
              size: 26,
            ),
          ),
          title: const Text(
            'Exit TravelBuddy?',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Are you sure you want to quit the application?',
            textAlign: TextAlign.center,
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            24,
            8,
            24,
            20,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(false);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.onError,
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop(true);
                    },
                    child: const Text('Quit'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (shouldQuit == true) {
      await SystemNavigator.pop();
    }
  }

  // ===========================================================================
  // BACK NAVIGATION
  // ===========================================================================

  Future<void> _handleBack(BuildContext context) async {
    final router = GoRouter.of(context);

    // -------------------------------------------------------------------------
    // STEP 1
    //
    // Return through the current navigation stack first.
    //
    // Home ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ Explore ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ Manali ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ Plan Trip
    //
    // Back:
    //
    // Plan Trip ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ Manali
    // Manali    ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ Explore
    // Explore   ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¾Ãƒâ€šÃ‚Â¢ Home
    // -------------------------------------------------------------------------

    if (router.canPop()) {
      router.pop();
      return;
    }

    // -------------------------------------------------------------------------
    // STEP 2
    //
    // If we're on another bottom-navigation section,
    // return to Home.
    // -------------------------------------------------------------------------

    if (navigationShell.currentIndex != 0) {
      navigationShell.goBranch(
        0,
        initialLocation: true,
      );
      return;
    }

    // -------------------------------------------------------------------------
    // STEP 3
    //
    // Only the actual Home root can show the quit dialog.
    // -------------------------------------------------------------------------

    await _handleQuitRequest(context);
  }

  // ===========================================================================
  // TRAVELBUDDY AI CONTEXT
  // ===========================================================================

  TravelBuddyAiContext _aiContextForCurrentSection() {
    switch (navigationShell.currentIndex) {
      // Home
      case 0:
        return const TravelBuddyAiContext(
          screen: 'home',
        );

      // Explore
      case 1:
        return const TravelBuddyAiContext(
          screen: 'explore',
        );

      // Recommendations
      case 2:
        return const TravelBuddyAiContext(
          screen: 'recommendations',
        );

      // Profile
      case 3:
        return const TravelBuddyAiContext(
          screen: 'profile',
        );

      // Trips / remaining navigation branch
      case 4:
        return const TravelBuddyAiContext(
          screen: 'trips',
        );

      default:
        return const TravelBuddyAiContext(
          screen: 'home',
        );
    }
  }

  // ===========================================================================
  // OPEN TRAVELBUDDY AI
  // ===========================================================================

  void _openTravelBuddyAi(BuildContext context) {
    context.push(
      '/travelbuddy-ai',
      extra: _aiContextForCurrentSection(),
    );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        _handleBack(context);
      },
      child: Scaffold(
        body: navigationShell,

        // ---------------------------------------------------------------------
        // TRAVELBUDDY AI BUTTON
        // ---------------------------------------------------------------------
        //
        // The AI button floats above the existing bottom navigation.
        //
        // It does NOT replace or modify BottomNavBar.
        // ---------------------------------------------------------------------

        floatingActionButton: FloatingActionButton(
          heroTag: 'travelbuddy-ai-fab',
          tooltip: 'TravelBuddy AI',
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 6,
          onPressed: () {
            _openTravelBuddyAi(context);
          },
          child: const TravelBuddyAiLogo(size: 34),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        // ---------------------------------------------------------------------
        // EXISTING BOTTOM NAVIGATION
        // ---------------------------------------------------------------------

        bottomNavigationBar: BottomNavBar(
          currentIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
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
      // =======================================================================
      // SPLASH
      // =======================================================================

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

      // =======================================================================
      // ONBOARDING
      // =======================================================================

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

      // =======================================================================
      // AUTHENTICATION
      // =======================================================================

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
          // EMAIL CONFIRMATION
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
          // FORGOT PASSWORD
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
          // RESET PASSWORD
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

      // =======================================================================
      // NOTIFICATIONS
      // =======================================================================

      GoRoute(
        path: '/notifications',
        builder: (ctx, state) {
          return const NotificationCenterScreen();
        },
      ),

      // =======================================================================
      // SETTINGS
      // =======================================================================

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

      // =======================================================================
      // GPS ERROR
      // =======================================================================

      GoRoute(
        path: '/error/gps',
        builder: (ctx, state) {
          return ErrorGpsDisabledScreen(
            onEnableGps: () => ctx.pop(),
            onManualEntry: () => ctx.pop(),
          );
        },
      ),

      // =======================================================================
      // SERVER ERROR
      // =======================================================================

      GoRoute(
        path: '/error/server',
        builder: (ctx, state) {
          return ErrorServerIssueScreen(
            onRetry: () => ctx.pop(),
            onHome: () => ctx.go('/home'),
          );
        },
      ),

      // =======================================================================
      // TRAVELBUDDY AI
      // =======================================================================

      GoRoute(
        path: '/travelbuddy-ai',
        name: 'travelbuddy-ai',
        builder: (ctx, state) {
          final extra = state.extra;

          if (extra is TravelBuddyAiContext) {
            return TravelBuddyAiScreen(
              context: extra,
            );
          }

          return const TravelBuddyAiScreen();
        },
      ),

      // =======================================================================
      // MAIN APPLICATION SHELL
      // =======================================================================

      StatefulShellRoute.indexedStack(
        builder: (ctx, state, shell) {
          return _HomeShell(
            navigationShell: shell,
          );
        },
        branches: [
          // ===================================================================
          // BRANCH 0 ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â HOME
          // ===================================================================

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (ctx, state) {
                  return HomeDashboardScreen(
                    // ---------------------------------------------------------
                    // PLAN TRIP
                    // ---------------------------------------------------------

                    onPlanTrip: () {
                      ctx.push(
                        '/home/trips/new/planner',
                      );
                    },

                    // ---------------------------------------------------------
                    // EXISTING TRIP
                    // ---------------------------------------------------------

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

                    // =========================================================
                    // QUICK ACCESS
                    // =========================================================

                    // ---------------------------------------------------------
                    // EXPLORE
                    // ---------------------------------------------------------

                    onExplore: () {
                      ctx.go(
                        '/home/explore',
                      );
                    },

                    // ---------------------------------------------------------
                    // BUDGET
                    // ---------------------------------------------------------

                    onBudget: () {
                      final tripState = ctx.read<TripState>();

                      if (tripState.trips.isEmpty) {
                        ctx.push(
                          '/home/trips/new/planner',
                        );
                        return;
                      }

                      final trip = tripState.trips.first;

                      ctx.push(
                        '/home/trips/${trip.id}/budget',
                      );
                    },

                    // ---------------------------------------------------------
                    // NEARBY
                    // ---------------------------------------------------------

                    onNearby: () {
                      final tripState = ctx.read<TripState>();

                      if (tripState.trips.isEmpty) {
                        ctx.push(
                          '/home/trips/new/planner',
                        );
                        return;
                      }

                      final trip = tripState.trips.first;

                      ctx.push(
                        '/home/trips/${trip.id}/nearby',
                      );
                    },

                    // ---------------------------------------------------------
                    // READINESS
                    // ---------------------------------------------------------

                    onReadiness: () {
                      final tripState = ctx.read<TripState>();

                      if (tripState.trips.isEmpty) {
                        ctx.push(
                          '/home/trips/new/planner',
                        );
                        return;
                      }

                      final trip = tripState.trips.first;

                      ctx.push(
                        '/home/trips/${trip.id}/readiness',
                      );
                    },

                    // =========================================================
                    // HEADER ACTIONS
                    // =========================================================

                    // ---------------------------------------------------------
                    // PROFILE
                    // ---------------------------------------------------------

                    onProfile: () {
                      ctx.go(
                        '/home/profile',
                      );
                    },

                    // ---------------------------------------------------------
                    // NOTIFICATIONS
                    // ---------------------------------------------------------

                    onNotifications: () {
                      ctx.push(
                        '/notifications',
                      );
                    },
                  );
                },
              ),
            ],
          ),

          // ===================================================================
          // BRANCH 1 ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â EXPLORE
          // ===================================================================

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
                  // -----------------------------------------------------------
                  // SEARCH
                  // -----------------------------------------------------------

                  // ACCOMMODATIONS

                  GoRoute(
                    path: 'accommodations',
                    builder: (ctx, state) {
                      return const AccommodationListScreen();
                    },
                  ),

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

                  // -----------------------------------------------------------
                  // DESTINATION
                  // -----------------------------------------------------------

                  GoRoute(
                    path: 'destination/:id',
                    builder: (ctx, state) {
                      return DestinationDetailsScreen(
                        detail: DestinationDetailDemoData.manali,
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

          // ===================================================================
          // BRANCH 2 ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â TRIPS
          // ===================================================================

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/trips',
                builder: (ctx, state) {
                  final tripState = ctx.watch<TripState>();

                  // -----------------------------------------------------------
                  // LOADING
                  // -----------------------------------------------------------

                  if (tripState.isLoading) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  // -----------------------------------------------------------
                  // ERROR
                  // -----------------------------------------------------------

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

                  // -----------------------------------------------------------
                  // NO TRIPS
                  // -----------------------------------------------------------

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
                  // NEW TRIP PLANNER
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

                          ScaffoldMessenger.of(
                            ctx,
                          ).showSnackBar(
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
                  // INDIVIDUAL TRIP
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

                      // -------------------------------------------------------
                      // TRIP NOT FOUND
                      // -------------------------------------------------------

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
                      // -------------------------------------------------------
                      // PLANNER
                      // -------------------------------------------------------

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

                      // -------------------------------------------------------
                      // BUDGET
                      // -------------------------------------------------------

                      GoRoute(
                        path: 'budget',
                        builder: (ctx, state) {
                          final tripId = state.pathParameters['tripId'];

                          if (tripId == null || tripId.trim().isEmpty) {
                            return const Scaffold(
                              body: Center(
                                child: Text('Trip not found'),
                              ),
                            );
                          }

                          return TripBudgetScreen(
                            tripId: tripId,
                          );
                        },
                      ),

                      // -------------------------------------------------------
                      // READINESS
                      // -------------------------------------------------------

                      GoRoute(
                        path: 'readiness',
                        builder: (ctx, state) {
                          return const TravelReadinessDashboardScreen();
                        },
                      ),

                      // -------------------------------------------------------
                      // NEARBY
                      // -------------------------------------------------------

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

          // ===================================================================
          // BRANCH 3 ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â RECOMMENDATIONS
          // ===================================================================

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
                          ctx.go(
                            '/home/explore',
                          );
                        },
                      ),
                    );
                  }

                  return RecommendedForYouScreen(
                    recommendations: recommendationState.recommendations,
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

          // ===================================================================
          // BRANCH 4 ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â PROFILE
          // ===================================================================

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home/profile',
                builder: (ctx, state) {
                  return ProfileDashboardScreen(
                    onSettings: () {
                      ctx.push('/settings');
                    },
                    onTripHistory: () {
                      ctx.go('/home/trips');
                    },
                    onSavedPlaces: () {
                      ctx.push(
                        '/home/profile/saved-places',
                      );
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
                routes: [
                  // -----------------------------------------------------------
                  // SAVED PLACES
                  // -----------------------------------------------------------

                  GoRoute(
                    path: 'saved-places',
                    builder: (ctx, state) {
                      return const SavedPlacesScreen();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
