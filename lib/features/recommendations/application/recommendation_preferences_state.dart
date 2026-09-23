import 'package:flutter/foundation.dart';

import '../data/recommendation_preferences_repository.dart';
import '../domain/recommendation_user_preferences.dart';

enum RecommendationPreferencesStatus {
  idle,
  loading,
  loaded,
  saving,
  error,
}

class RecommendationPreferencesState extends ChangeNotifier {
  RecommendationPreferencesState(this._repository);

  final RecommendationPreferencesRepository _repository;

  RecommendationPreferencesStatus _status =
      RecommendationPreferencesStatus.idle;

  RecommendationUserPreferences? _preferences;

  RecommendationPreferencesStatus get status => _status;

  RecommendationUserPreferences? get preferences => _preferences;

  bool get hasPreferences => _preferences != null;

  Future<void> load() async {
    _status = RecommendationPreferencesStatus.loading;
    notifyListeners();

    try {
      _preferences = await _repository.load();
      _status = RecommendationPreferencesStatus.loaded;
    } catch (_) {
      _preferences = null;
      _status = RecommendationPreferencesStatus.error;
    }

    notifyListeners();
  }

  Future<void> save(RecommendationUserPreferences preferences) async {
    preferences.validate();

    _status = RecommendationPreferencesStatus.saving;
    notifyListeners();

    try {
      await _repository.save(preferences);
      _preferences = preferences;
      _status = RecommendationPreferencesStatus.loaded;
    } catch (_) {
      _status = RecommendationPreferencesStatus.error;
    }

    notifyListeners();
  }

  Future<void> clear() async {
    try {
      await _repository.clear();
      _preferences = null;
      _status = RecommendationPreferencesStatus.loaded;
    } catch (_) {
      _status = RecommendationPreferencesStatus.error;
    }

    notifyListeners();
  }

  void resetError() {
    if (_status != RecommendationPreferencesStatus.error) {
      return;
    }

    _status = _preferences == null
        ? RecommendationPreferencesStatus.idle
        : RecommendationPreferencesStatus.loaded;

    notifyListeners();
  }
}
