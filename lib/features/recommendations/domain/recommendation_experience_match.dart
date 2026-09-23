import 'recommendation_experience.dart';
import 'recommendation_experience_evidence.dart';
import 'recommendation_monthly_experience_evidence.dart';

class RecommendationExperienceMatch {
  const RecommendationExperienceMatch({
    required this.requestedExperiences,
    required this.evidence,
  });

  final Set<RecommendationExperience> requestedExperiences;
  final List<RecommendationExperienceEvidence> evidence;

  bool get hasRequestedExperiences => requestedExperiences.isNotEmpty;

  bool get hasAnyEvidence => evidence.any((item) => item.hasEvidence);

  bool get hasStrongEvidence => evidence.any((item) => item.hasStrongEvidence);

  int get requestedCount => requestedExperiences.length;

  int get evidencedCount => evidence.where((item) => item.hasEvidence).length;

  int get stronglyEvidencedCount =>
      evidence.where((item) => item.hasStrongEvidence).length;

  static RecommendationExperienceMatch evaluate({
    required Set<RecommendationExperience> requestedExperiences,
    required RecommendationMonthlyExperienceEvidence evidence,
  }) {
    final matchedEvidence = <RecommendationExperienceEvidence>[];

    for (final experience in requestedExperiences) {
      final item = RecommendationExperienceEvidence.fromExperience(
        experience: experience,
        evidence: evidence,
      );

      if (item.hasEvidence) {
        matchedEvidence.add(item);
      }
    }

    return RecommendationExperienceMatch(
      requestedExperiences: Set<RecommendationExperience>.unmodifiable(
        requestedExperiences,
      ),
      evidence: List<RecommendationExperienceEvidence>.unmodifiable(
        matchedEvidence,
      ),
    );
  }
}
