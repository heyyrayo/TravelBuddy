import '../data/recommendation_experience_repository.dart';
import '../data/recommendation_repository.dart';
import '../domain/experience_aware_recommendation_engine.dart';
import '../domain/recommendation_candidate.dart';
import '../domain/recommendation_experience_ranking_policy.dart';
import '../domain/recommendation_monthly_experience_evidence.dart';
import '../domain/recommendation_presentation.dart';
import '../domain/recommendation_user_preferences.dart';

class RecommendationService {
  RecommendationService({
    RecommendationRepository? recommendationRepository,
    RecommendationExperienceRepository? experienceRepository,
    ExperienceAwareRecommendationEngine? engine,
  })  : _recommendationRepository =
            recommendationRepository ?? RecommendationRepository(),
        _experienceRepository =
            experienceRepository ?? RecommendationExperienceRepository(),
        _engine = engine ??
            const ExperienceAwareRecommendationEngine(
              experiencePolicy:
                  RecommendationExperienceRankingPolicy.disabled(),
            );

  final RecommendationRepository _recommendationRepository;
  final RecommendationExperienceRepository _experienceRepository;
  final ExperienceAwareRecommendationEngine _engine;

  Future<List<RecommendationPresentation>> generate({
    required RecommendationUserPreferences preferences,
    int limit = 20,
  }) async {
    preferences.validate();

    final features = await _recommendationRepository.getFeaturesByMonth(
      preferences.travelMonth,
    );

    if (features.isEmpty) {
      return const <RecommendationPresentation>[];
    }

    final List<RecommendationMonthlyExperienceEvidence> evidenceRows =
        preferences.experiences.isEmpty
            ? const <RecommendationMonthlyExperienceEvidence>[]
            : await _experienceRepository.getEvidenceByMonth(
                preferences.travelMonth,
              );

    final Map<String, RecommendationMonthlyExperienceEvidence>
        evidenceByDestination = <String, RecommendationMonthlyExperienceEvidence>{
      for (final evidence in evidenceRows)
        evidence.destinationId: evidence,
    };

    final candidates = features
        .map(
          (feature) => RecommendationCandidate(
            features: feature,
            experienceEvidence: evidenceByDestination[feature.destinationId],
          ),
        )
        .toList(growable: false);

    final recommendations = _engine.generate(
      candidates: candidates,
      preferences: preferences,
      limit: limit,
    );

    return List<RecommendationPresentation>.unmodifiable(
      recommendations,
    );
  }
}
