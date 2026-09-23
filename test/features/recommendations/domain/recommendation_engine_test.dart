import 'package:flutter_test/flutter_test.dart';

import 'package:travelbuddy_india/features/recommendations/domain/experience_aware_recommendation_engine.dart';
import 'package:travelbuddy_india/features/recommendations/domain/recommendation_candidate.dart';
import 'package:travelbuddy_india/features/recommendations/domain/recommendation_engine.dart';
import 'package:travelbuddy_india/features/recommendations/domain/recommendation_monthly_features.dart';
import 'package:travelbuddy_india/features/recommendations/domain/recommendation_user_preferences.dart';

void main() {
  group('Recommendation engine baseline regression', () {
    const preferences = RecommendationUserPreferences(
      travelMonth: '01',
      temperaturePreference: TemperaturePreference.moderate,
      templeInterest: false,
      shrineInterest: false,
      palaceInterest: false,
      monumentInterest: false,
      churchInterest: false,
      museumInterest: false,
      stadiumInterest: false,
      customsHouseInterest: false,
      transportPreference: TransportPreference.either,
      tourismPreference: TourismPreference.either,
      populationPreference: PopulationPreference.either,
    );

    test(
      'legacy and active engines preserve the same baseline ordering '
      'when experience ranking is disabled',
      () {
        final features = <RecommendationMonthlyFeatures>[
          _features(
            destinationId: 'DEST-A',
            destinationName: 'Destination A',
            moderatePreferenceScore: 1.0,
            nearestRailwayDistanceKm: 0.0,
            railwayStationsWithin25Km: 1,
            nearestAirportDistanceKm: 0.0,
            airportsWithin100Km: 1,
            totalAttractionCount: 1,
          ),
          _features(
            destinationId: 'DEST-B',
            destinationName: 'Destination B',
            moderatePreferenceScore: 0.5,
            nearestRailwayDistanceKm: 25.0,
            railwayStationsWithin25Km: 1,
            nearestAirportDistanceKm: 100.0,
            airportsWithin100Km: 1,
            totalAttractionCount: 1,
          ),
        ];

        final legacyResults = const RecommendationEngine().generate(
          features: features,
          preferences: preferences,
        );

        final activeResults =
            const ExperienceAwareRecommendationEngine().generate(
          candidates: [
            RecommendationCandidate(
              features: features[0],
              experienceEvidence: null,
            ),
            RecommendationCandidate(
              features: features[1],
              experienceEvidence: null,
            ),
          ],
          preferences: preferences,
        );

        expect(
          legacyResults.map((item) => item.destinationId).toList(),
          ['DEST-A', 'DEST-B'],
        );

        expect(
          activeResults.map((item) => item.destinationId).toList(),
          ['DEST-A', 'DEST-B'],
        );

        expect(
          activeResults.map((item) => item.destinationId).toList(),
          legacyResults.map((item) => item.destinationId).toList(),
        );
      },
    );

    test('both engines ignore candidates from another month', () {
      final january = _features(
        destinationId: 'JAN',
        destinationName: 'January Destination',
        moderatePreferenceScore: 1.0,
        nearestRailwayDistanceKm: 0.0,
        railwayStationsWithin25Km: 1,
        nearestAirportDistanceKm: 0.0,
        airportsWithin100Km: 1,
        totalAttractionCount: 1,
      );

      final february = _features(
        destinationId: 'FEB',
        destinationName: 'February Destination',
        month: '02',
        moderatePreferenceScore: 1.0,
        nearestRailwayDistanceKm: 0.0,
        railwayStationsWithin25Km: 1,
        nearestAirportDistanceKm: 0.0,
        airportsWithin100Km: 1,
        totalAttractionCount: 1,
      );

      final legacyResults = const RecommendationEngine().generate(
        features: [january, february],
        preferences: preferences,
      );

      final activeResults =
          const ExperienceAwareRecommendationEngine().generate(
        candidates: [
          RecommendationCandidate(
            features: january,
            experienceEvidence: null,
          ),
          RecommendationCandidate(
            features: february,
            experienceEvidence: null,
          ),
        ],
        preferences: preferences,
      );

      expect(
        legacyResults.map((item) => item.destinationId).toList(),
        ['JAN'],
      );

      expect(
        activeResults.map((item) => item.destinationId).toList(),
        ['JAN'],
      );
    });

    test('both engines use destination ID as deterministic tie-breaker', () {
      final features = <RecommendationMonthlyFeatures>[
        _features(
          destinationId: 'DEST-B',
          destinationName: 'Destination B',
          moderatePreferenceScore: 1.0,
          nearestRailwayDistanceKm: 0.0,
          railwayStationsWithin25Km: 1,
          nearestAirportDistanceKm: 0.0,
          airportsWithin100Km: 1,
          totalAttractionCount: 1,
        ),
        _features(
          destinationId: 'DEST-A',
          destinationName: 'Destination A',
          moderatePreferenceScore: 1.0,
          nearestRailwayDistanceKm: 0.0,
          railwayStationsWithin25Km: 1,
          nearestAirportDistanceKm: 0.0,
          airportsWithin100Km: 1,
          totalAttractionCount: 1,
        ),
      ];

      final legacyResults = const RecommendationEngine().generate(
        features: features,
        preferences: preferences,
      );

      final activeResults =
          const ExperienceAwareRecommendationEngine().generate(
        candidates: [
          RecommendationCandidate(
            features: features[0],
            experienceEvidence: null,
          ),
          RecommendationCandidate(
            features: features[1],
            experienceEvidence: null,
          ),
        ],
        preferences: preferences,
      );

      expect(
        legacyResults.map((item) => item.destinationId).toList(),
        ['DEST-A', 'DEST-B'],
      );

      expect(
        activeResults.map((item) => item.destinationId).toList(),
        ['DEST-A', 'DEST-B'],
      );
    });
  });
}

RecommendationMonthlyFeatures _features({
  required String destinationId,
  required String destinationName,
  String month = '01',
  required double moderatePreferenceScore,
  required double nearestRailwayDistanceKm,
  required int railwayStationsWithin25Km,
  required double nearestAirportDistanceKm,
  required int airportsWithin100Km,
  required int totalAttractionCount,
}) {
  return RecommendationMonthlyFeatures(
    destinationId: destinationId,
    destinationName: destinationName,
    month: month,
    stateUt: 'Test State',
    region: 'Test Region',
    timezone: 'Asia/Kolkata',
    tourismComponent: null,
    accessibilityComponent: null,
    populationComponent: null,
    attractionComponent: null,
    hasAttractions: totalAttractionCount > 0,
    templeCount: null,
    shrineCount: null,
    palaceCount: null,
    monumentCount: null,
    churchCount: null,
    museumCount: null,
    stadiumCount: null,
    customsHouseCount: null,
    totalAttractionCount: totalAttractionCount,
    attractionCategoryCount: null,
    avgTemperatureC: 22.0,
    avgMaxTemperatureC: null,
    avgMinTemperatureC: null,
    historicalMaxTemperatureC: null,
    historicalMinTemperatureC: null,
    avgTemperatureRangeC: null,
    elevationM: null,
    yearsAnalyzed: null,
    coolPreferenceScore: 0.0,
    moderatePreferenceScore: moderatePreferenceScore,
    warmPreferenceScore: 0.0,
    nearestRailwayDistanceKm: nearestRailwayDistanceKm,
    railwayStationsWithin25Km: railwayStationsWithin25Km,
    nearestAirportDistanceKm: nearestAirportDistanceKm,
    airportsWithin100Km: airportsWithin100Km,
  );
}
