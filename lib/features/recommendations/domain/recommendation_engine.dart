import 'recommendation_monthly_features.dart';
import 'recommendation_presentation.dart';
import 'recommendation_user_preferences.dart';

class RecommendationEngine {
  const RecommendationEngine();

  List<RecommendationPresentation> generate({
    required List<RecommendationMonthlyFeatures> features,
    required RecommendationUserPreferences preferences,
    int limit = 20,
  }) {
    preferences.validate();

    if (limit <= 0) {
      throw ArgumentError.value(
        limit,
        'limit',
        'Must be greater than zero.',
      );
    }

    final monthFeatures = features
        .where((feature) => feature.month == preferences.travelMonth)
        .toList(growable: false);

    final scored = <_ScoredRecommendation>[];

    for (final feature in monthFeatures) {
      final score = _score(feature, preferences);

      if (score == null) {
        continue;
      }

      scored.add(
        _ScoredRecommendation(
          feature: feature,
          score: score,
        ),
      );
    }

    scored.sort(
      (a, b) {
        final scoreOrder = b.score.compareTo(a.score);

        if (scoreOrder != 0) {
          return scoreOrder;
        }

        return a.feature.destinationId.compareTo(
          b.feature.destinationId,
        );
      },
    );

    final visibleCount = scored.length < limit ? scored.length : limit;

    return List<RecommendationPresentation>.generate(
      visibleCount,
      (index) {
        final item = scored[index];
        final presentation = _toPresentation(
          item.feature,
          rank: index + 1,
        );

        presentation.validate();
        return presentation;
      },
    );
  }

  double? _score(
    RecommendationMonthlyFeatures feature,
    RecommendationUserPreferences preferences,
  ) {
    final temperatureScore = _temperatureScore(
      feature,
      preferences.temperaturePreference,
    );

    if (temperatureScore == null) {
      return null;
    }

    final interestScore = _interestScore(
      feature,
      preferences,
    );

    final transportScore = _transportScore(
      feature,
      preferences.transportPreference,
    );

    final localityScore = _localityScore(feature);

    if (interestScore == null ||
        transportScore == null ||
        localityScore == null) {
      return null;
    }

    return (
          (3.0 * temperatureScore) +
          (3.0 * interestScore) +
          (2.0 * transportScore) +
          localityScore
        ) /
        9.0;
  }

  double? _temperatureScore(
    RecommendationMonthlyFeatures feature,
    TemperaturePreference preference,
  ) {
    switch (preference) {
      case TemperaturePreference.cool:
        return feature.coolPreferenceScore;
      case TemperaturePreference.moderate:
        return feature.moderatePreferenceScore;
      case TemperaturePreference.warm:
        return feature.warmPreferenceScore;
    }
  }

  double? _interestScore(
    RecommendationMonthlyFeatures feature,
    RecommendationUserPreferences preferences,
  ) {
    final requested = <double>[];
    final available = <double>[];

    void addInterest(
      bool selected,
      int? count,
    ) {
      if (!selected) {
        return;
      }

      if (count == null) {
        return;
      }

      available.add(count.toDouble());
      requested.add(count > 0 ? 1.0 : 0.0);
    }

    addInterest(preferences.templeInterest, feature.templeCount);
    addInterest(preferences.shrineInterest, feature.shrineCount);
    addInterest(preferences.palaceInterest, feature.palaceCount);
    addInterest(preferences.monumentInterest, feature.monumentCount);
    addInterest(preferences.churchInterest, feature.churchCount);
    addInterest(preferences.museumInterest, feature.museumCount);
    addInterest(preferences.stadiumInterest, feature.stadiumCount);
    addInterest(
      preferences.customsHouseInterest,
      feature.customsHouseCount,
    );

    if (requested.isEmpty) {
      return 1.0;
    }

    if (available.isEmpty) {
      return null;
    }

    var matched = 0.0;

    for (var i = 0; i < requested.length; i++) {
      if (requested[i] > 0 && available[i] > 0) {
        matched += 1.0;
      }
    }

    return matched / requested.length;
  }

  double? _transportScore(
    RecommendationMonthlyFeatures feature,
    TransportPreference preference,
  ) {
    final railSupported =
        (feature.railwayStationsWithin25Km ?? 0) > 0;

    final airSupported =
        (feature.airportsWithin100Km ?? 0) > 0;

    switch (preference) {
      case TransportPreference.rail:
        if (feature.railwayStationsWithin25Km == null) {
          return null;
        }
        return railSupported ? 1.0 : 0.0;

      case TransportPreference.air:
        if (feature.airportsWithin100Km == null) {
          return null;
        }
        return airSupported ? 1.0 : 0.0;

      case TransportPreference.either:
        final available = <double>[];

        if (feature.railwayStationsWithin25Km != null) {
          available.add(railSupported ? 1.0 : 0.0);
        }

        if (feature.airportsWithin100Km != null) {
          available.add(airSupported ? 1.0 : 0.0);
        }

        if (available.isEmpty) {
          return null;
        }

        return available.reduce((a, b) => a > b ? a : b);
    }
  }

  double? _localityScore(
    RecommendationMonthlyFeatures feature,
  ) {
    final nearestRail = feature.nearestRailwayDistanceKm;
    final nearestAir = feature.nearestAirportDistanceKm;

    final localitySignals = <double>[];

    if (nearestRail != null) {
      localitySignals.add(_distanceScore(nearestRail, 25.0));
    }

    if (nearestAir != null) {
      localitySignals.add(_distanceScore(nearestAir, 100.0));
    }

    if ((feature.totalAttractionCount ?? 0) > 0) {
      localitySignals.add(1.0);
    }

    if (localitySignals.isEmpty) {
      return null;
    }

    return localitySignals.reduce((a, b) => a + b) /
        localitySignals.length;
  }

  double _distanceScore(
    double distanceKm,
    double referenceKm,
  ) {
    if (distanceKm < 0) {
      return 0.0;
    }

    final normalized = 1.0 - (distanceKm / referenceKm);

    return normalized.clamp(0.0, 1.0);
  }

  RecommendationPresentation _toPresentation(
    RecommendationMonthlyFeatures feature, {
    required int rank,
  }) {
    final signals = <String>[
      'Temperature match',
      'Interest match',
      'Transport access',
      'Local relevance',
    ];

    final stateOrRegion = feature.stateUt.trim().isNotEmpty
        ? feature.stateUt
        : feature.region;

    final explanation = _buildExplanation(feature);

    return RecommendationPresentation(
      destinationId: feature.destinationId,
      destinationName: feature.destinationName,
      stateOrRegion: stateOrRegion,

      rank: rank,
      explanation: explanation,
      supportedSignals: signals,
    );
  }

  String _buildExplanation(
    RecommendationMonthlyFeatures feature,
  ) {
    final parts = <String>[];

    if (feature.avgTemperatureC != null) {
      parts.add(
        'Monthly temperature data available',
      );
    }

    if ((feature.totalAttractionCount ?? 0) > 0) {
      parts.add(
        '${feature.totalAttractionCount} nearby attraction records',
      );
    }

    if ((feature.railwayStationsWithin25Km ?? 0) > 0 ||
        (feature.airportsWithin100Km ?? 0) > 0) {
      parts.add(
        'Transport access data available',
      );
    }

    if (parts.isEmpty) {
      return 'Recommendation based on available validated destination data.';
    }

    return parts.join(' • ');
  }
}

class _ScoredRecommendation {
  const _ScoredRecommendation({
    required this.feature,
    required this.score,
  });

  final RecommendationMonthlyFeatures feature;
  final double score;
}



