class RecommendationMonthlyExperienceEvidence {
  const RecommendationMonthlyExperienceEvidence({
    required this.destinationId,
    required this.destinationName,
    required this.month,
    required this.hillsCount25Km,
    required this.hillsNearestDistanceKm,
    required this.hillsStrength,
    required this.hillsExamples,
    required this.mountainsCount25Km,
    required this.mountainsNearestDistanceKm,
    required this.mountainsStrength,
    required this.mountainsExamples,
    required this.forestsCount25Km,
    required this.forestsNearestDistanceKm,
    required this.forestsStrength,
    required this.forestsExamples,
    required this.lakesCount25Km,
    required this.lakesNearestDistanceKm,
    required this.lakesStrength,
    required this.lakesExamples,
    required this.islandsCount25Km,
    required this.islandsNearestDistanceKm,
    required this.islandsStrength,
    required this.islandsExamples,
    required this.dunesCount25Km,
    required this.dunesNearestDistanceKm,
    required this.dunesStrength,
    required this.dunesExamples,
    required this.riversCount25Km,
    required this.riversNearestDistanceKm,
    required this.riversStrength,
    required this.riversExamples,
    required this.reservesCount25Km,
    required this.reservesNearestDistanceKm,
    required this.reservesStrength,
    required this.reservesExamples,
  });

  final String destinationId;
  final String destinationName;
  final String month;

  final int? hillsCount25Km;
  final double? hillsNearestDistanceKm;
  final String? hillsStrength;
  final String? hillsExamples;

  final int? mountainsCount25Km;
  final double? mountainsNearestDistanceKm;
  final String? mountainsStrength;
  final String? mountainsExamples;

  final int? forestsCount25Km;
  final double? forestsNearestDistanceKm;
  final String? forestsStrength;
  final String? forestsExamples;

  final int? lakesCount25Km;
  final double? lakesNearestDistanceKm;
  final String? lakesStrength;
  final String? lakesExamples;

  final int? islandsCount25Km;
  final double? islandsNearestDistanceKm;
  final String? islandsStrength;
  final String? islandsExamples;

  final int? dunesCount25Km;
  final double? dunesNearestDistanceKm;
  final String? dunesStrength;
  final String? dunesExamples;

  final int? riversCount25Km;
  final double? riversNearestDistanceKm;
  final String? riversStrength;
  final String? riversExamples;

  final int? reservesCount25Km;
  final double? reservesNearestDistanceKm;
  final String? reservesStrength;
  final String? reservesExamples;

  factory RecommendationMonthlyExperienceEvidence.fromMap(
    Map<String, dynamic> map,
  ) {
    return RecommendationMonthlyExperienceEvidence(
      destinationId: _requiredString(map['destination_id']),
      destinationName: _requiredString(map['destination_name']),
      month: _requiredString(map['month']),
      hillsCount25Km: _optionalInt(map['hills_count_25km']),
      hillsNearestDistanceKm: _optionalDouble(map['hills_nearest_distance_km']),
      hillsStrength: _optionalString(map['hills_strength']),
      hillsExamples: _optionalString(map['hills_examples']),
      mountainsCount25Km: _optionalInt(map['mountains_count_25km']),
      mountainsNearestDistanceKm:
          _optionalDouble(map['mountains_nearest_distance_km']),
      mountainsStrength: _optionalString(map['mountains_strength']),
      mountainsExamples: _optionalString(map['mountains_examples']),
      forestsCount25Km: _optionalInt(map['forests_count_25km']),
      forestsNearestDistanceKm:
          _optionalDouble(map['forests_nearest_distance_km']),
      forestsStrength: _optionalString(map['forests_strength']),
      forestsExamples: _optionalString(map['forests_examples']),
      lakesCount25Km: _optionalInt(map['lakes_count_25km']),
      lakesNearestDistanceKm: _optionalDouble(map['lakes_nearest_distance_km']),
      lakesStrength: _optionalString(map['lakes_strength']),
      lakesExamples: _optionalString(map['lakes_examples']),
      islandsCount25Km: _optionalInt(map['islands_count_25km']),
      islandsNearestDistanceKm:
          _optionalDouble(map['islands_nearest_distance_km']),
      islandsStrength: _optionalString(map['islands_strength']),
      islandsExamples: _optionalString(map['islands_examples']),
      dunesCount25Km: _optionalInt(map['dunes_count_25km']),
      dunesNearestDistanceKm: _optionalDouble(map['dunes_nearest_distance_km']),
      dunesStrength: _optionalString(map['dunes_strength']),
      dunesExamples: _optionalString(map['dunes_examples']),
      riversCount25Km: _optionalInt(map['rivers_count_25km']),
      riversNearestDistanceKm:
          _optionalDouble(map['rivers_nearest_distance_km']),
      riversStrength: _optionalString(map['rivers_strength']),
      riversExamples: _optionalString(map['rivers_examples']),
      reservesCount25Km: _optionalInt(map['reserves_count_25km']),
      reservesNearestDistanceKm:
          _optionalDouble(map['reserves_nearest_distance_km']),
      reservesStrength: _optionalString(map['reserves_strength']),
      reservesExamples: _optionalString(map['reserves_examples']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'destination_id': destinationId,
      'destination_name': destinationName,
      'month': month,
      'hills_count_25km': hillsCount25Km,
      'hills_nearest_distance_km': hillsNearestDistanceKm,
      'hills_strength': hillsStrength,
      'hills_examples': hillsExamples,
      'mountains_count_25km': mountainsCount25Km,
      'mountains_nearest_distance_km': mountainsNearestDistanceKm,
      'mountains_strength': mountainsStrength,
      'mountains_examples': mountainsExamples,
      'forests_count_25km': forestsCount25Km,
      'forests_nearest_distance_km': forestsNearestDistanceKm,
      'forests_strength': forestsStrength,
      'forests_examples': forestsExamples,
      'lakes_count_25km': lakesCount25Km,
      'lakes_nearest_distance_km': lakesNearestDistanceKm,
      'lakes_strength': lakesStrength,
      'lakes_examples': lakesExamples,
      'islands_count_25km': islandsCount25Km,
      'islands_nearest_distance_km': islandsNearestDistanceKm,
      'islands_strength': islandsStrength,
      'islands_examples': islandsExamples,
      'dunes_count_25km': dunesCount25Km,
      'dunes_nearest_distance_km': dunesNearestDistanceKm,
      'dunes_strength': dunesStrength,
      'dunes_examples': dunesExamples,
      'rivers_count_25km': riversCount25Km,
      'rivers_nearest_distance_km': riversNearestDistanceKm,
      'rivers_strength': riversStrength,
      'rivers_examples': riversExamples,
      'reserves_count_25km': reservesCount25Km,
      'reserves_nearest_distance_km': reservesNearestDistanceKm,
      'reserves_strength': reservesStrength,
      'reserves_examples': reservesExamples,
    };
  }

  void validate() {
    if (destinationId.trim().isEmpty) {
      throw const FormatException(
        'Experience evidence destinationId must not be empty.',
      );
    }

    if (destinationName.trim().isEmpty) {
      throw const FormatException(
        'Experience evidence destinationName must not be empty.',
      );
    }

    if (!RegExp(r'^(0[1-9]|1[0-2])$').hasMatch(month)) {
      throw const FormatException(
        'Experience evidence month must be between 01 and 12.',
      );
    }
  }

  static String _requiredString(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }

    throw const FormatException(
      'Required experience evidence string field is missing.',
    );
  }

  static String? _optionalString(dynamic value) {
    if (value == null) {
      return null;
    }

    final valueString = value.toString().trim();

    if (valueString.isEmpty) {
      return null;
    }

    return valueString;
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
