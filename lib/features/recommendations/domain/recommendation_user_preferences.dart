import 'recommendation_experience.dart';

enum TemperaturePreference {
  cool,
  moderate,
  warm,
}

enum TransportPreference {
  rail,
  air,
  either,
}

enum TourismPreference {
  popular,
  lessTouristy,
  either,
}

enum PopulationPreference {
  largeCity,
  smallCity,
  either,
}

class RecommendationUserPreferences {
  const RecommendationUserPreferences({
    required this.travelMonth,
    required this.temperaturePreference,
    required this.templeInterest,
    required this.shrineInterest,
    required this.palaceInterest,
    required this.monumentInterest,
    required this.churchInterest,
    required this.museumInterest,
    required this.stadiumInterest,
    required this.customsHouseInterest,
    required this.transportPreference,
    required this.tourismPreference,
    required this.populationPreference,
    this.tripDurationDays,
    this.experiences = const <RecommendationExperience>{},
  });

  /// Calendar month represented as a zero-padded string: 01-12.
  final String travelMonth;

  final TemperaturePreference temperaturePreference;

  final bool templeInterest;
  final bool shrineInterest;
  final bool palaceInterest;
  final bool monumentInterest;
  final bool churchInterest;
  final bool museumInterest;
  final bool stadiumInterest;
  final bool customsHouseInterest;

  final TransportPreference transportPreference;
  final TourismPreference tourismPreference;
  final PopulationPreference populationPreference;

  /// User-only input. It is not currently backed by destination data.
  final int? tripDurationDays;

  /// Natural/experience preferences.
  ///
  /// This is intentionally optional so existing saved preferences remain
  /// valid when no experience has been selected.
  final Set<RecommendationExperience> experiences;

  void validate() {
    if (!RegExp(r'^(0[1-9]|1[0-2])$').hasMatch(travelMonth)) {
      throw ArgumentError.value(
        travelMonth,
        'travelMonth',
        'Expected a zero-padded month from 01 to 12.',
      );
    }

    if (tripDurationDays != null && tripDurationDays! <= 0) {
      throw ArgumentError.value(
        tripDurationDays,
        'tripDurationDays',
        'Must be a positive integer when provided.',
      );
    }
  }
}
