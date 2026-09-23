import 'recommendation_candidate_experience.dart';
import 'recommendation_experience_ranking_policy.dart';
import 'recommendation_experience_scorer.dart';

class RecommendationExperienceScoreApplier {
  const RecommendationExperienceScoreApplier();

  double apply({
    required double baseScore,
    required RecommendationCandidateExperience experience,
    required RecommendationExperienceRankingPolicy policy,
  }) {
    if (!policy.isEnabled) {
      return baseScore;
    }

    if (!experience.hasRequestedExperiences) {
      return baseScore;
    }

    if (!experience.hasEvidence) {
      return baseScore;
    }

    final matches = experience.matches;

    if (matches.isEmpty) {
      return baseScore;
    }

    final normalizedExperienceValue =
        const RecommendationExperienceScorer()
            .normalizedExperienceValue(matches: matches);

    return baseScore *
        (1.0 + (policy.weight * normalizedExperienceValue));
  }
}
