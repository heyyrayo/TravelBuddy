import 'package:shared_preferences/shared_preferences.dart';

import '../domain/recommendation_experience.dart';
import '../domain/recommendation_user_preferences.dart';

class RecommendationPreferencesRepository {
  static const _travelMonthKey = 'recommendation.travel_month';
  static const _temperaturePreferenceKey =
      'recommendation.temperature_preference';

  static const _templeInterestKey = 'recommendation.temple_interest';
  static const _shrineInterestKey = 'recommendation.shrine_interest';
  static const _palaceInterestKey = 'recommendation.palace_interest';
  static const _monumentInterestKey = 'recommendation.monument_interest';
  static const _churchInterestKey = 'recommendation.church_interest';
  static const _museumInterestKey = 'recommendation.museum_interest';
  static const _stadiumInterestKey = 'recommendation.stadium_interest';
  static const _customsHouseInterestKey =
      'recommendation.customs_house_interest';

  static const _transportPreferenceKey =
      'recommendation.transport_preference';
  static const _tourismPreferenceKey =
      'recommendation.tourism_preference';
  static const _populationPreferenceKey =
      'recommendation.population_preference';
  static const _tripDurationDaysKey =
      'recommendation.trip_duration_days';
  static const _experiencesKey =
      'recommendation.experiences';

  Future<RecommendationUserPreferences?> load() async {
    final prefs = await SharedPreferences.getInstance();

    final travelMonth = prefs.getString(_travelMonthKey);
    final temperatureRaw =
        prefs.getString(_temperaturePreferenceKey);
    final transportRaw =
        prefs.getString(_transportPreferenceKey);
    final tourismRaw =
        prefs.getString(_tourismPreferenceKey);
    final populationRaw =
        prefs.getString(_populationPreferenceKey);

    if (travelMonth == null ||
        temperatureRaw == null ||
        transportRaw == null ||
        tourismRaw == null ||
        populationRaw == null) {
      return null;
    }

    final temperaturePreference =
        _temperatureFromStorage(temperatureRaw);
    final transportPreference =
        _transportFromStorage(transportRaw);
    final tourismPreference =
        _tourismFromStorage(tourismRaw);
    final populationPreference =
        _populationFromStorage(populationRaw);

    if (temperaturePreference == null ||
        transportPreference == null ||
        tourismPreference == null ||
        populationPreference == null) {
      return null;
    }

    final storedExperiences =
        prefs.getStringList(_experiencesKey) ?? const <String>[];

    final experiences = storedExperiences
        .map(_experienceFromStorage)
        .whereType<RecommendationExperience>()
        .toSet();

    final preferences = RecommendationUserPreferences(
      travelMonth: travelMonth,
      temperaturePreference: temperaturePreference,
      templeInterest: prefs.getBool(_templeInterestKey) ?? false,
      shrineInterest: prefs.getBool(_shrineInterestKey) ?? false,
      palaceInterest: prefs.getBool(_palaceInterestKey) ?? false,
      monumentInterest: prefs.getBool(_monumentInterestKey) ?? false,
      churchInterest: prefs.getBool(_churchInterestKey) ?? false,
      museumInterest: prefs.getBool(_museumInterestKey) ?? false,
      stadiumInterest: prefs.getBool(_stadiumInterestKey) ?? false,
      customsHouseInterest:
          prefs.getBool(_customsHouseInterestKey) ?? false,
      transportPreference: transportPreference,
      tourismPreference: tourismPreference,
      populationPreference: populationPreference,
      tripDurationDays: prefs.getInt(_tripDurationDaysKey),
      experiences: experiences,
    );

    try {
      preferences.validate();
    } catch (_) {
      return null;
    }

    return preferences;
  }

  Future<void> save(
    RecommendationUserPreferences preferences,
  ) async {
    preferences.validate();

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _travelMonthKey,
      preferences.travelMonth,
    );

    await prefs.setString(
      _temperaturePreferenceKey,
      preferences.temperaturePreference.name,
    );

    await prefs.setBool(
      _templeInterestKey,
      preferences.templeInterest,
    );
    await prefs.setBool(
      _shrineInterestKey,
      preferences.shrineInterest,
    );
    await prefs.setBool(
      _palaceInterestKey,
      preferences.palaceInterest,
    );
    await prefs.setBool(
      _monumentInterestKey,
      preferences.monumentInterest,
    );
    await prefs.setBool(
      _churchInterestKey,
      preferences.churchInterest,
    );
    await prefs.setBool(
      _museumInterestKey,
      preferences.museumInterest,
    );
    await prefs.setBool(
      _stadiumInterestKey,
      preferences.stadiumInterest,
    );
    await prefs.setBool(
      _customsHouseInterestKey,
      preferences.customsHouseInterest,
    );

    await prefs.setString(
      _transportPreferenceKey,
      preferences.transportPreference.name,
    );
    await prefs.setString(
      _tourismPreferenceKey,
      preferences.tourismPreference.name,
    );
    await prefs.setString(
      _populationPreferenceKey,
      preferences.populationPreference.name,
    );

    if (preferences.tripDurationDays == null) {
      await prefs.remove(_tripDurationDaysKey);
    } else {
      await prefs.setInt(
        _tripDurationDaysKey,
        preferences.tripDurationDays!,
      );
    }

    await prefs.setStringList(
      _experiencesKey,
      preferences.experiences
          .map((experience) => experience.storageValue)
          .toList(),
    );
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    const keys = <String>[
      _travelMonthKey,
      _temperaturePreferenceKey,
      _templeInterestKey,
      _shrineInterestKey,
      _palaceInterestKey,
      _monumentInterestKey,
      _churchInterestKey,
      _museumInterestKey,
      _stadiumInterestKey,
      _customsHouseInterestKey,
      _transportPreferenceKey,
      _tourismPreferenceKey,
      _populationPreferenceKey,
      _tripDurationDaysKey,
      _experiencesKey,
    ];

    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  TemperaturePreference? _temperatureFromStorage(String value) {
    for (final option in TemperaturePreference.values) {
      if (option.name == value) {
        return option;
      }
    }

    return null;
  }

  TransportPreference? _transportFromStorage(String value) {
    for (final option in TransportPreference.values) {
      if (option.name == value) {
        return option;
      }
    }

    return null;
  }

  TourismPreference? _tourismFromStorage(String value) {
    for (final option in TourismPreference.values) {
      if (option.name == value) {
        return option;
      }
    }

    return null;
  }

  PopulationPreference? _populationFromStorage(String value) {
    for (final option in PopulationPreference.values) {
      if (option.name == value) {
        return option;
      }
    }

    return null;
  }

  RecommendationExperience? _experienceFromStorage(String value) {
    for (final experience in RecommendationExperience.values) {
      if (experience.storageValue == value) {
        return experience;
      }
    }

    return null;
  }
}
