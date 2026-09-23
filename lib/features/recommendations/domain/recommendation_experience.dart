enum RecommendationExperience {
  hills,
  mountains,
  forests,
  lakes,
  islands,
  dunes,
  rivers,
  protectedNature,
  beaches,
  wildlife,
  waterfalls,
  nightlife,
  adventure,
}

extension RecommendationExperienceX on RecommendationExperience {
  String get storageValue {
    switch (this) {
      case RecommendationExperience.hills:
        return 'hills';
      case RecommendationExperience.mountains:
        return 'mountains';
      case RecommendationExperience.forests:
        return 'forests';
      case RecommendationExperience.lakes:
        return 'lakes';
      case RecommendationExperience.islands:
        return 'islands';
      case RecommendationExperience.dunes:
        return 'dunes';
      case RecommendationExperience.rivers:
        return 'rivers';
      case RecommendationExperience.protectedNature:
        return 'protected_nature';
      case RecommendationExperience.beaches:
        return 'beaches';
      case RecommendationExperience.wildlife:
        return 'wildlife';
      case RecommendationExperience.waterfalls:
        return 'waterfalls';
      case RecommendationExperience.nightlife:
        return 'nightlife';
      case RecommendationExperience.adventure:
        return 'adventure';
    }
  }

  String get displayName {
    switch (this) {
      case RecommendationExperience.hills:
        return 'Hills';
      case RecommendationExperience.mountains:
        return 'Mountains';
      case RecommendationExperience.forests:
        return 'Forests';
      case RecommendationExperience.lakes:
        return 'Lakes';
      case RecommendationExperience.islands:
        return 'Islands';
      case RecommendationExperience.dunes:
        return 'Desert & Dunes';
      case RecommendationExperience.rivers:
        return 'Rivers';
      case RecommendationExperience.protectedNature:
        return 'Protected Nature';
      case RecommendationExperience.beaches:
        return 'Beaches';
      case RecommendationExperience.wildlife:
        return 'Wildlife';
      case RecommendationExperience.waterfalls:
        return 'Waterfalls';
      case RecommendationExperience.nightlife:
        return 'Nightlife';
      case RecommendationExperience.adventure:
        return 'Adventure';
    }
  }
}
