import 'package:flutter/foundation.dart';

import '../models/accommodation.dart';
import '../repositories/accommodation_repository.dart';

class AccommodationProvider extends ChangeNotifier {
  AccommodationProvider({
    AccommodationRepository? repository,
  }) : _repository = repository ?? AccommodationRepository();

  final AccommodationRepository _repository;

  List<Accommodation> _accommodations = [];
  List<String> _states = [];
  List<String> _accommodationTypes = [];

  String _searchQuery = '';
  String? _selectedState;
  String? _selectedAccommodationType;

  bool _isLoading = false;
  bool _isLoadingFilters = false;
  String? _errorMessage;
  int _totalCount = 0;

  List<Accommodation> get accommodations =>
      List.unmodifiable(_accommodations);

  List<String> get states => List.unmodifiable(_states);

  List<String> get accommodationTypes =>
      List.unmodifiable(_accommodationTypes);

  String get searchQuery => _searchQuery;

  String? get selectedState => _selectedState;

  String? get selectedAccommodationType => _selectedAccommodationType;

  bool get isLoading => _isLoading;

  bool get isLoadingFilters => _isLoadingFilters;

  String? get errorMessage => _errorMessage;

  int get totalCount => _totalCount;

  bool get hasError => _errorMessage != null;

  bool get hasResults => _accommodations.isNotEmpty;

  Future<void> loadAccommodations({
    int? limit,
    int? offset,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      _accommodations = await _repository.searchAccommodations(
        searchQuery: _searchQuery,
        state: _selectedState,
        accommodationType: _selectedAccommodationType,
        limit: limit,
        offset: offset,
      );

      _totalCount = await _repository.getAccommodationCount(
        searchQuery: _searchQuery,
        state: _selectedState,
        accommodationType: _selectedAccommodationType,
      );
    } catch (error) {
      _errorMessage = 'Unable to load accommodations: $error';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadFilters() async {
    _isLoadingFilters = true;
    _clearError();
    notifyListeners();

    try {
      _states = await _repository.getStates();
      _accommodationTypes =
          await _repository.getAccommodationTypes();
    } catch (error) {
      _errorMessage = 'Unable to load accommodation filters: $error';
    } finally {
      _isLoadingFilters = false;
      notifyListeners();
    }
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    await loadAccommodations();
  }

  Future<void> setStateFilter(String? state) async {
    _selectedState = state;
    await loadAccommodations();
  }

  Future<void> setAccommodationTypeFilter(String? type) async {
    _selectedAccommodationType = type;
    await loadAccommodations();
  }

  Future<void> clearFilters() async {
    _searchQuery = '';
    _selectedState = null;
    _selectedAccommodationType = null;
    await loadAccommodations();
  }

  Future<Accommodation?> getAccommodationById(
    String recordId,
  ) {
    return _repository.getAccommodationById(recordId);
  }

  Future<void> refresh() async {
    await loadAccommodations();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  @override
  void dispose() {
    _repository.close();
    super.dispose();
  }
}
