class RecommendationMonthlyFeatures {
  const RecommendationMonthlyFeatures({
    required this.destinationId,
    required this.destinationName,
    required this.month,
    required this.stateUt,
    required this.region,
    required this.timezone,
    required this.tourismComponent,
    required this.accessibilityComponent,
    required this.populationComponent,
    required this.attractionComponent,
    required this.hasAttractions,
    required this.templeCount,
    required this.shrineCount,
    required this.palaceCount,
    required this.monumentCount,
    required this.churchCount,
    required this.museumCount,
    required this.stadiumCount,
    required this.customsHouseCount,
    required this.totalAttractionCount,
    required this.attractionCategoryCount,
    required this.avgTemperatureC,
    required this.avgMaxTemperatureC,
    required this.avgMinTemperatureC,
    required this.historicalMaxTemperatureC,
    required this.historicalMinTemperatureC,
    required this.avgTemperatureRangeC,
    required this.elevationM,
    required this.yearsAnalyzed,
    required this.coolPreferenceScore,
    required this.moderatePreferenceScore,
    required this.warmPreferenceScore,
    required this.nearestRailwayDistanceKm,
    required this.railwayStationsWithin25Km,
    required this.nearestAirportDistanceKm,
    required this.airportsWithin100Km,
  });

  final String destinationId;
  final String destinationName;
  final String month;
  final String stateUt;
  final String region;
  final String timezone;

  final double? tourismComponent;
  final double? accessibilityComponent;
  final double? populationComponent;
  final double? attractionComponent;

  final bool hasAttractions;

  final int? templeCount;
  final int? shrineCount;
  final int? palaceCount;
  final int? monumentCount;
  final int? churchCount;
  final int? museumCount;
  final int? stadiumCount;
  final int? customsHouseCount;
  final int? totalAttractionCount;
  final int? attractionCategoryCount;

  final double? avgTemperatureC;
  final double? avgMaxTemperatureC;
  final double? avgMinTemperatureC;
  final double? historicalMaxTemperatureC;
  final double? historicalMinTemperatureC;
  final double? avgTemperatureRangeC;
  final double? elevationM;

  final int? yearsAnalyzed;

  final double? coolPreferenceScore;
  final double? moderatePreferenceScore;
  final double? warmPreferenceScore;

  final double? nearestRailwayDistanceKm;
  final int? railwayStationsWithin25Km;
  final double? nearestAirportDistanceKm;
  final int? airportsWithin100Km;

  factory RecommendationMonthlyFeatures.fromMap(
    Map<String, dynamic> map,
  ) {
    return RecommendationMonthlyFeatures(
      destinationId: _requiredString(map['destination_id']),
      destinationName: _requiredString(map['destination_name']),
      month: _requiredString(map['month']),
      stateUt: _requiredString(map['state_ut']),
      region: _requiredString(map['region']),
      timezone: _requiredString(map['timezone']),
      tourismComponent: _optionalDouble(map['tourism_component']),
      accessibilityComponent: _optionalDouble(
        map['accessibility_component'],
      ),
      populationComponent: _optionalDouble(
        map['population_component'],
      ),
      attractionComponent: _optionalDouble(
        map['attraction_component'],
      ),
      hasAttractions: _requiredBool(map['has_attractions']),
      templeCount: _optionalInt(map['temple_count']),
      shrineCount: _optionalInt(map['shrine_count']),
      palaceCount: _optionalInt(map['palace_count']),
      monumentCount: _optionalInt(map['monument_count']),
      churchCount: _optionalInt(map['church_count']),
      museumCount: _optionalInt(map['museum_count']),
      stadiumCount: _optionalInt(map['stadium_count']),
      customsHouseCount: _optionalInt(map['customs_house_count']),
      totalAttractionCount: _optionalInt(
        map['total_attraction_count'],
      ),
      attractionCategoryCount: _optionalInt(
        map['attraction_category_count'],
      ),
      avgTemperatureC: _optionalDouble(
        map['avg_temperature_c'],
      ),
      avgMaxTemperatureC: _optionalDouble(
        map['avg_max_temperature_c'],
      ),
      avgMinTemperatureC: _optionalDouble(
        map['avg_min_temperature_c'],
      ),
      historicalMaxTemperatureC: _optionalDouble(
        map['historical_max_temperature_c'],
      ),
      historicalMinTemperatureC: _optionalDouble(
        map['historical_min_temperature_c'],
      ),
      avgTemperatureRangeC: _optionalDouble(
        map['avg_temperature_range_c'],
      ),
      elevationM: _optionalDouble(map['elevation_m']),
      yearsAnalyzed: _optionalInt(map['years_analyzed']),
      coolPreferenceScore: _optionalDouble(
        map['cool_preference_score'],
      ),
      moderatePreferenceScore: _optionalDouble(
        map['moderate_preference_score'],
      ),
      warmPreferenceScore: _optionalDouble(
        map['warm_preference_score'],
      ),
      nearestRailwayDistanceKm: _optionalDouble(
        map['nearest_railway_distance_km'],
      ),
      railwayStationsWithin25Km: _optionalInt(
        map['railway_stations_within_25km'],
      ),
      nearestAirportDistanceKm: _optionalDouble(
        map['nearest_airport_distance_km'],
      ),
      airportsWithin100Km: _optionalInt(
        map['airports_within_100km'],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'destination_id': destinationId,
      'destination_name': destinationName,
      'month': month,
      'state_ut': stateUt,
      'region': region,
      'timezone': timezone,
      'tourism_component': tourismComponent,
      'accessibility_component': accessibilityComponent,
      'population_component': populationComponent,
      'attraction_component': attractionComponent,
      'has_attractions': hasAttractions ? 1 : 0,
      'temple_count': templeCount,
      'shrine_count': shrineCount,
      'palace_count': palaceCount,
      'monument_count': monumentCount,
      'church_count': churchCount,
      'museum_count': museumCount,
      'stadium_count': stadiumCount,
      'customs_house_count': customsHouseCount,
      'total_attraction_count': totalAttractionCount,
      'attraction_category_count': attractionCategoryCount,
      'avg_temperature_c': avgTemperatureC,
      'avg_max_temperature_c': avgMaxTemperatureC,
      'avg_min_temperature_c': avgMinTemperatureC,
      'historical_max_temperature_c': historicalMaxTemperatureC,
      'historical_min_temperature_c': historicalMinTemperatureC,
      'avg_temperature_range_c': avgTemperatureRangeC,
      'elevation_m': elevationM,
      'years_analyzed': yearsAnalyzed,
      'cool_preference_score': coolPreferenceScore,
      'moderate_preference_score': moderatePreferenceScore,
      'warm_preference_score': warmPreferenceScore,
      'nearest_railway_distance_km': nearestRailwayDistanceKm,
      'railway_stations_within_25km': railwayStationsWithin25Km,
      'nearest_airport_distance_km': nearestAirportDistanceKm,
      'airports_within_100km': airportsWithin100Km,
    };
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

    if (!RegExp(r'^(0[1-9]|1[0-2])$').hasMatch(month)) {
      throw const FormatException(
        'Recommendation month must be between 01 and 12.',
      );
    }

    if (stateUt.trim().isEmpty) {
      throw const FormatException(
        'Recommendation stateUt must not be empty.',
      );
    }

    if (region.trim().isEmpty) {
      throw const FormatException(
        'Recommendation region must not be empty.',
      );
    }

    if (timezone.trim().isEmpty) {
      throw const FormatException(
        'Recommendation timezone must not be empty.',
      );
    }

    if (latitudeNotUsedForValidation()) {
      // Coordinates are intentionally not part of this feature model.
    }
  }

  bool latitudeNotUsedForValidation() => true;

  static String _requiredString(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }

    throw const FormatException(
      'Required recommendation string field is missing.',
    );
  }

  static bool _requiredBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      if (value == 0) {
        return false;
      }

      if (value == 1) {
        return true;
      }
    }

    throw const FormatException(
      'Required recommendation boolean field is invalid.',
    );
  }

  static int? _optionalInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString().trim());
  }

  static double? _optionalDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString().trim());
  }
}
