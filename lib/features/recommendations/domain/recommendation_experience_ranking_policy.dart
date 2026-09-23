enum RecommendationExperienceRankingMode {
  disabled,
  experimental,
}

class RecommendationExperienceRankingPolicy {
  const RecommendationExperienceRankingPolicy({
    required this.mode,
    required this.weight,
  });

  const RecommendationExperienceRankingPolicy.disabled()
      : mode = RecommendationExperienceRankingMode.disabled,
        weight = 0.0;

  const RecommendationExperienceRankingPolicy.experimental({
    this.weight = 0.01,
  }) : mode = RecommendationExperienceRankingMode.experimental;

  final RecommendationExperienceRankingMode mode;

  /// Experimental coefficient only.
  ///
  /// This value is intentionally configurable and is not a production-approved
  /// recommendation weight.
  final double weight;

  bool get isEnabled =>
      mode == RecommendationExperienceRankingMode.experimental &&
      weight > 0.0 &&
      weight <= 1.0;
}

