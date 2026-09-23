import 'recommendation_experience.dart';
import 'recommendation_experience_evidence.dart';
import 'recommendation_monthly_experience_evidence.dart';

enum RecommendationExperienceMatchStrength {
  none,
  distant,
  broad,
  nearby,
  close,
  veryClose,
}

class RecommendationExperienceMatchResult {
  const RecommendationExperienceMatchResult({
    required this.experience,
    required this.strength,
    required this.nearestDistanceKm,
    required this.evidenceExamples,
  });

  final RecommendationExperience experience;
  final RecommendationExperienceMatchStrength strength;
  final double? nearestDistanceKm;
  final String? evidenceExamples;

  bool get hasEvidence =>
      strength != RecommendationExperienceMatchStrength.none;

  bool get hasStrongEvidence =>
      strength == RecommendationExperienceMatchStrength.close ||
      strength == RecommendationExperienceMatchStrength.veryClose;
}

class RecommendationExperienceScorer {
  const RecommendationExperienceScorer();

  List<RecommendationExperienceMatchResult> evaluate({
    required Set<RecommendationExperience> requestedExperiences,
    required RecommendationMonthlyExperienceEvidence evidence,
  }) {
    final results = <RecommendationExperienceMatchResult>[];

    for (final experience in requestedExperiences) {
      final detail = RecommendationExperienceEvidence.fromExperience(
        experience: experience,
        evidence: evidence,
      );


      final strength = _parseStrength(detail.strength);

      results.add(
        RecommendationExperienceMatchResult(
          experience: experience,
          strength: strength,
          nearestDistanceKm: detail.nearestDistanceKm,
          evidenceExamples: detail.examples,
        ),
      );
    }

    return results;
  }

  double normalizedExperienceValue({
    required List<RecommendationExperienceMatchResult> matches,
  }) {
    if (matches.isEmpty) {
      return 0.0;
    }

    final total = matches
        .map(_strengthValue)
        .fold<double>(0.0, (sum, value) => sum + value);

    final average = total / matches.length;

    return average < 0.0 ? 0.0 : average > 1.0 ? 1.0 : average;
  }

  double _strengthValue(RecommendationExperienceMatchResult match) {
    switch (match.strength) {
      case RecommendationExperienceMatchStrength.veryClose:
        return 1.0;
      case RecommendationExperienceMatchStrength.close:
        return 0.75;
      case RecommendationExperienceMatchStrength.nearby:
        return 0.50;
      case RecommendationExperienceMatchStrength.broad:
        return 0.25;
      case RecommendationExperienceMatchStrength.distant:
      case RecommendationExperienceMatchStrength.none:
        return 0.0;
    }
  }

  RecommendationExperienceMatchStrength _parseStrength(String? value) {
    switch (value) {
      case 'VERY_CLOSE_EVIDENCE':
        return RecommendationExperienceMatchStrength.veryClose;
      case 'CLOSE_EVIDENCE':
        return RecommendationExperienceMatchStrength.close;
      case 'NEARBY_EVIDENCE':
        return RecommendationExperienceMatchStrength.nearby;
      case 'BROAD_EVIDENCE':
        return RecommendationExperienceMatchStrength.broad;
      case 'DISTANT_EVIDENCE':
        return RecommendationExperienceMatchStrength.distant;
      case 'NONE':
      case null:
      case '':
        return RecommendationExperienceMatchStrength.none;
      default:
        return RecommendationExperienceMatchStrength.none;
    }
  }
}




