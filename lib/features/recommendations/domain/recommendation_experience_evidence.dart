import 'recommendation_experience.dart';
import 'recommendation_monthly_experience_evidence.dart';

class RecommendationExperienceEvidence {
  const RecommendationExperienceEvidence({
    required this.experience,
    required this.strength,
    required this.nearestDistanceKm,
    required this.countWithin25Km,
    required this.examples,
  });

  final RecommendationExperience experience;
  final String? strength;
  final double? nearestDistanceKm;
  final int? countWithin25Km;
  final String? examples;

  bool get hasEvidence =>
      strength != null || nearestDistanceKm != null || countWithin25Km != null;

  bool get hasStrongEvidence =>
      strength == 'VERY_CLOSE_EVIDENCE' || strength == 'CLOSE_EVIDENCE';

  static RecommendationExperienceEvidence fromExperience({
    required RecommendationExperience experience,
    required RecommendationMonthlyExperienceEvidence evidence,
  }) {
    switch (experience) {
      case RecommendationExperience.hills:
        return RecommendationExperienceEvidence(
          experience: experience,
          strength: evidence.hillsStrength,
          nearestDistanceKm: evidence.hillsNearestDistanceKm,
          countWithin25Km: evidence.hillsCount25Km,
          examples: evidence.hillsExamples,
        );

      case RecommendationExperience.mountains:
        return RecommendationExperienceEvidence(
          experience: experience,
          strength: evidence.mountainsStrength,
          nearestDistanceKm: evidence.mountainsNearestDistanceKm,
          countWithin25Km: evidence.mountainsCount25Km,
          examples: evidence.mountainsExamples,
        );

      case RecommendationExperience.forests:
        return RecommendationExperienceEvidence(
          experience: experience,
          strength: evidence.forestsStrength,
          nearestDistanceKm: evidence.forestsNearestDistanceKm,
          countWithin25Km: evidence.forestsCount25Km,
          examples: evidence.forestsExamples,
        );

      case RecommendationExperience.lakes:
        return RecommendationExperienceEvidence(
          experience: experience,
          strength: evidence.lakesStrength,
          nearestDistanceKm: evidence.lakesNearestDistanceKm,
          countWithin25Km: evidence.lakesCount25Km,
          examples: evidence.lakesExamples,
        );

      case RecommendationExperience.islands:
        return RecommendationExperienceEvidence(
          experience: experience,
          strength: evidence.islandsStrength,
          nearestDistanceKm: evidence.islandsNearestDistanceKm,
          countWithin25Km: evidence.islandsCount25Km,
          examples: evidence.islandsExamples,
        );

      case RecommendationExperience.dunes:
        return RecommendationExperienceEvidence(
          experience: experience,
          strength: evidence.dunesStrength,
          nearestDistanceKm: evidence.dunesNearestDistanceKm,
          countWithin25Km: evidence.dunesCount25Km,
          examples: evidence.dunesExamples,
        );

      case RecommendationExperience.rivers:
        return RecommendationExperienceEvidence(
          experience: experience,
          strength: evidence.riversStrength,
          nearestDistanceKm: evidence.riversNearestDistanceKm,
          countWithin25Km: evidence.riversCount25Km,
          examples: evidence.riversExamples,
        );

      case RecommendationExperience.protectedNature:
        return RecommendationExperienceEvidence(
          experience: experience,
          strength: evidence.reservesStrength,
          nearestDistanceKm: evidence.reservesNearestDistanceKm,
          countWithin25Km: evidence.reservesCount25Km,
          examples: evidence.reservesExamples,
        );

      case RecommendationExperience.beaches:
      case RecommendationExperience.wildlife:
      case RecommendationExperience.waterfalls:
      case RecommendationExperience.nightlife:
      case RecommendationExperience.adventure:
        return RecommendationExperienceEvidence(
          experience: experience,
          strength: null,
          nearestDistanceKm: null,
          countWithin25Km: null,
          examples: null,
        );
    }
  }
}
