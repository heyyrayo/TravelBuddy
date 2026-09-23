import 'recommendation_monthly_experience_evidence.dart';
import 'recommendation_monthly_features.dart';

class RecommendationCandidate {
  const RecommendationCandidate({
    required this.features,
    required this.experienceEvidence,
  });

  final RecommendationMonthlyFeatures features;
  final RecommendationMonthlyExperienceEvidence? experienceEvidence;

  String get destinationId => features.destinationId;

  String get month => features.month;

  bool get hasExperienceEvidence => experienceEvidence != null;
}
