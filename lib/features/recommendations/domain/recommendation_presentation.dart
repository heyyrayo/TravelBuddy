class RecommendationPresentation {
  const RecommendationPresentation({
    required this.destinationId,
    required this.destinationName,
    required this.explanation,
    this.stateOrRegion,
    this.latitude,
    this.longitude,
    this.rank,
    this.imageReference,
    this.supportedSignals = const [],
  });

  final String destinationId;
  final String destinationName;
  final String? stateOrRegion;
  final double? latitude;
  final double? longitude;
  final int? rank;
  final String? imageReference;
  final String explanation;
  final List<String> supportedSignals;

  RecommendationPresentation copyWith({
    String? destinationId,
    String? destinationName,
    String? stateOrRegion,
    double? latitude,
    double? longitude,
    int? rank,
    String? imageReference,
    String? explanation,
    List<String>? supportedSignals,
  }) {
    return RecommendationPresentation(
      destinationId: destinationId ?? this.destinationId,
      destinationName: destinationName ?? this.destinationName,
      stateOrRegion: stateOrRegion ?? this.stateOrRegion,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rank: rank ?? this.rank,
      imageReference: imageReference ?? this.imageReference,
      explanation: explanation ?? this.explanation,
      supportedSignals: supportedSignals ?? this.supportedSignals,
    );
  }

  void validate() {
    if (destinationId.trim().isEmpty) {
      throw const FormatException(
        'Recommendation destinationId must not be empty.',
      );
    }

    if (destinationName.trim().isEmpty) {
      throw const FormatException(
        'Recommendation destinationName must not be empty.',
      );
    }

    if (explanation.trim().isEmpty) {
      throw const FormatException(
        'Recommendation explanation must not be empty.',
      );
    }

    if (rank != null && rank! < 1) {
      throw const FormatException(
        'Recommendation rank must be at least 1.',
      );
    }

    if (latitude != null && (latitude! < -90 || latitude! > 90)) {
      throw const FormatException(
        'Recommendation latitude must be between -90 and 90.',
      );
    }

    if (longitude != null && (longitude! < -180 || longitude! > 180)) {
      throw const FormatException(
        'Recommendation longitude must be between -180 and 180.',
      );
    }
  }
}
