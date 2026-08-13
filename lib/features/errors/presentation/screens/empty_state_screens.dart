import 'package:flutter/material.dart';
import '../../../../shared/widgets/states/app_states.dart';

class EmptyNoInternetScreen extends StatelessWidget {
  const EmptyNoInternetScreen({super.key, this.onRetry, this.onViewOffline});

  final VoidCallback? onRetry;
  final VoidCallback? onViewOffline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EmptyStateWidget(
        illustrationAsset: 'assets/images/empty_no_internet.png',
        headline: 'Off the Grid?',
        body: "You're currently offline. Check your connection to continue exploring India",
        primaryActionLabel: 'Try Again',
        onPrimaryAction: onRetry,
        secondaryActionLabel: 'View Offline Saved Trips',
        onSecondaryAction: onViewOffline,
      ),
    );
  }
}

class EmptyNoTripsScreen extends StatelessWidget {
  const EmptyNoTripsScreen({super.key, this.onPlanTrip});

  final VoidCallback? onPlanTrip;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      illustrationAsset: 'assets/images/empty_no_trips.png',
      headline: 'Where to next?',
      body: "Your journey hasn't started yet. Let's find your first destination",
      primaryActionLabel: 'Plan a Trip',
      onPrimaryAction: onPlanTrip,
    );
  }
}

class EmptyNoSavedPlacesScreen extends StatelessWidget {
  const EmptyNoSavedPlacesScreen({super.key, this.onExplore});

  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      illustrationAsset: 'assets/images/empty_no_saved_places.png',
      headline: 'Your Wishlist is Empty',
      body: 'Start saving your favorite Indian spots to build your dream itinerary',
      primaryActionLabel: 'Explore Destinations',
      onPrimaryAction: onExplore,
    );
  }
}

class EmptyNoRecommendationsScreen extends StatelessWidget {
  const EmptyNoRecommendationsScreen({super.key, this.onSetPreferences, this.onExplore});

  final VoidCallback? onSetPreferences;
  final VoidCallback? onExplore;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      illustrationAsset: 'assets/images/empty_no_recommendations.png',
      headline: 'Still Learning...',
      body: 'Tell us more about your travel style so we can suggest the perfect Indian getaway',
      primaryActionLabel: 'Set Preferences',
      onPrimaryAction: onSetPreferences,
      secondaryActionLabel: 'Explore Popular Destinations',
      onSecondaryAction: onExplore,
      useCta: true,
    );
  }
}

class EmptyNoSearchResultsScreen extends StatelessWidget {
  const EmptyNoSearchResultsScreen({super.key, this.onExploreTrends, this.onSearchAgain});

  final VoidCallback? onExploreTrends;
  final VoidCallback? onSearchAgain;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      illustrationAsset: 'assets/images/empty_no_search_results.png',
      headline: 'Unknown Territory',
      body: "We couldn't find anything matching your search. Try searching for 'Hill Stations' or 'Goa'",
      primaryActionLabel: 'Explore Trends',
      onPrimaryAction: onExploreTrends,
      secondaryActionLabel: 'Search Again',
      onSecondaryAction: onSearchAgain,
      useCta: true,
    );
  }
}
