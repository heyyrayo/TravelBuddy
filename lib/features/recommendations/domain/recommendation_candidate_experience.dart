import 'recommendation_candidate.dart';
import 'recommendation_experience.dart';
import 'recommendation_experience_scorer.dart';

class RecommendationCandidateExperience {
  const RecommendationCandidateExperience({
    required this.requestedCount,
    required this.evidencedCount,
    required this.stronglyEvidencedCount,
    required this.matches,
  });

  final int requestedCount;
  final int evidencedCount;
  final int stronglyEvidencedCount;
  final List<RecommendationExperienceMatchResult> matches;

  bool get hasRequestedExperiences => requestedCount > 0;

  bool get hasEvidence => evidencedCount > 0;

  bool get hasStrongEvidence => stronglyEvidencedCount > 0;

  static RecommendationCandidateExperience evaluate({
    required RecommendationCandidate candidate,
    required Set<RecommendationExperience> requestedExperiences,
    RecommendationExperienceScorer scorer =
        const RecommendationExperienceScorer(),
  }) {
    if (requestedExperiences.isEmpty ||
        candidate.experienceEvidence == null) {
      return const RecommendationCandidateExperience(
        requestedCount: 0,
        evidencedCount: 0,
        stronglyEvidencedCount: 0,
        matches: <RecommendationExperienceMatchResult>[],
      );
    }

    final matches = scorer.evaluate(
      requestedExperiences: requestedExperiences,
      evidence: candidate.experienceEvidence!,
    );

    final evidencedCount = matches
        .where(
          (match) => match.hasEvidence,
        )
        .length;

    final stronglyEvidencedCount = matches
        .where(
          (match) => match.hasStrongEvidence,
        )
        .length;

    return RecommendationCandidateExperience(
      requestedCount: requestedExperiences.length,
      evidencedCount: evidencedCount,
      stronglyEvidencedCount: stronglyEvidencedCount,
      matches: List<RecommendationExperienceMatchResult>.unmodifiable(
        matches,
      ),
    );
  }
}
