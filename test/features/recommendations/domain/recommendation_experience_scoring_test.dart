import 'package:flutter_test/flutter_test.dart';

import 'package:travelbuddy_india/features/recommendations/domain/recommendation_candidate_experience.dart';
import 'package:travelbuddy_india/features/recommendations/domain/recommendation_experience.dart';
import 'package:travelbuddy_india/features/recommendations/domain/recommendation_experience_ranking_policy.dart';
import 'package:travelbuddy_india/features/recommendations/domain/recommendation_experience_score_applier.dart';
import 'package:travelbuddy_india/features/recommendations/domain/recommendation_experience_scorer.dart';

void main() {
  group('RecommendationExperienceScorer', () {
    const scorer = RecommendationExperienceScorer();

    test('maps VERY_CLOSE strength to 1.0', () {
      const match = RecommendationExperienceMatchResult(
        experience: RecommendationExperience.mountains,
        strength: RecommendationExperienceMatchStrength.veryClose,
        nearestDistanceKm: 1.0,
        evidenceExamples: 'Example',
      );

      expect(
        scorer.normalizedExperienceValue(matches: [match]),
        closeTo(1.0, 0.000001),
      );
    });

    test('maps CLOSE strength to 0.75', () {
      const match = RecommendationExperienceMatchResult(
        experience: RecommendationExperience.lakes,
        strength: RecommendationExperienceMatchStrength.close,
        nearestDistanceKm: 2.0,
        evidenceExamples: 'Example',
      );

      expect(
        scorer.normalizedExperienceValue(matches: [match]),
        closeTo(0.75, 0.000001),
      );
    });

    test('maps NEARBY strength to 0.50', () {
      const match = RecommendationExperienceMatchResult(
        experience: RecommendationExperience.rivers,
        strength: RecommendationExperienceMatchStrength.nearby,
        nearestDistanceKm: 4.0,
        evidenceExamples: 'Example',
      );

      expect(
        scorer.normalizedExperienceValue(matches: [match]),
        closeTo(0.50, 0.000001),
      );
    });

    test('maps BROAD strength to 0.25', () {
      const match = RecommendationExperienceMatchResult(
        experience: RecommendationExperience.hills,
        strength: RecommendationExperienceMatchStrength.broad,
        nearestDistanceKm: 8.0,
        evidenceExamples: 'Example',
      );

      expect(
        scorer.normalizedExperienceValue(matches: [match]),
        closeTo(0.25, 0.000001),
      );
    });

    test('maps DISTANT strength to 0.0', () {
      const match = RecommendationExperienceMatchResult(
        experience: RecommendationExperience.forests,
        strength: RecommendationExperienceMatchStrength.distant,
        nearestDistanceKm: 20.0,
        evidenceExamples: 'Example',
      );

      expect(
        scorer.normalizedExperienceValue(matches: [match]),
        closeTo(0.0, 0.000001),
      );
    });

    test('averages multiple requested experience strengths', () {
      const matches = [
        RecommendationExperienceMatchResult(
          experience: RecommendationExperience.mountains,
          strength: RecommendationExperienceMatchStrength.veryClose,
          nearestDistanceKm: 1.0,
          evidenceExamples: 'Example',
        ),
        RecommendationExperienceMatchResult(
          experience: RecommendationExperience.lakes,
          strength: RecommendationExperienceMatchStrength.broad,
          nearestDistanceKm: 8.0,
          evidenceExamples: 'Example',
        ),
      ];

      expect(
        scorer.normalizedExperienceValue(matches: matches),
        closeTo(0.625, 0.000001),
      );
    });

    test('empty matches produce zero', () {
      expect(
        scorer.normalizedExperienceValue(
          matches: const <RecommendationExperienceMatchResult>[],
        ),
        0.0,
      );
    });
  });

  group('RecommendationExperienceScoreApplier', () {
    const applier = RecommendationExperienceScoreApplier();

    test('disabled policy returns unchanged base score', () {
      const experience = RecommendationCandidateExperience(
        requestedCount: 1,
        evidencedCount: 1,
        stronglyEvidencedCount: 1,
        matches: [
          RecommendationExperienceMatchResult(
            experience: RecommendationExperience.mountains,
            strength: RecommendationExperienceMatchStrength.veryClose,
            nearestDistanceKm: 1.0,
            evidenceExamples: 'Example',
          ),
        ],
      );

      final result = applier.apply(
        baseScore: 0.80,
        experience: experience,
        policy: const RecommendationExperienceRankingPolicy.disabled(),
      );

      expect(result, closeTo(0.80, 0.000001));
    });

    test('enabled policy follows normalized multiplicative formula', () {
      const experience = RecommendationCandidateExperience(
        requestedCount: 2,
        evidencedCount: 2,
        stronglyEvidencedCount: 1,
        matches: [
          RecommendationExperienceMatchResult(
            experience: RecommendationExperience.mountains,
            strength: RecommendationExperienceMatchStrength.veryClose,
            nearestDistanceKm: 1.0,
            evidenceExamples: 'Example',
          ),
          RecommendationExperienceMatchResult(
            experience: RecommendationExperience.lakes,
            strength: RecommendationExperienceMatchStrength.broad,
            nearestDistanceKm: 8.0,
            evidenceExamples: 'Example',
          ),
        ],
      );

      final result = applier.apply(
        baseScore: 0.80,
        experience: experience,
        policy: const RecommendationExperienceRankingPolicy.experimental(
          weight: 0.01,
        ),
      );

      expect(result, closeTo(0.805, 0.000001));
    });
  });
}
