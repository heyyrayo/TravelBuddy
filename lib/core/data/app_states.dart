import 'package:flutter/material.dart';

import 'destination_repository.dart';
import 'trip_repository.dart';

// ---------------------------------------------------------------------------
// Async lifecycle enum
// ---------------------------------------------------------------------------

enum AsyncStatus {
  idle,
  loading,
  success,
  error,
}

// ---------------------------------------------------------------------------
// Destination state
// ---------------------------------------------------------------------------

class DestinationState extends ChangeNotifier {
  DestinationState(this._repo);

  final DestinationRepository _repo;

  List<Destination> _destinations = [];
  List<Destination> _searchResults = [];
  AsyncStatus _status = AsyncStatus.idle;

  List<Destination> get destinations => List.unmodifiable(_destinations);

  List<Destination> get searchResults => List.unmodifiable(_searchResults);

  AsyncStatus get status => _status;

  Future<void> loadAll() async {
    _status = AsyncStatus.loading;
    notifyListeners();

    try {
      _destinations = await _repo.getAll();
      _status = AsyncStatus.success;
    } catch (_) {
      _status = AsyncStatus.error;
    }

    notifyListeners();
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _searchResults = await _repo.search(query);
    notifyListeners();
  }
}

// ---------------------------------------------------------------------------
// Trip state
// ---------------------------------------------------------------------------

class TripState extends ChangeNotifier {
  TripState(this._repo);

  final TripRepository _repo;

  List<Trip> _trips = [];
  List<SavedPlace> _savedPlaces = [];

  bool _isLoading = false;
  bool _isLoadingTrips = false;
  bool _isLoadingSavedPlaces = false;

  String? _errorMessage;
  String? _tripErrorMessage;
  String? _savedPlaceErrorMessage;

  // -------------------------------------------------------------------------
  // Getters
  // -------------------------------------------------------------------------

  List<Trip> get trips => List.unmodifiable(_trips);

  bool get hasTrips => _trips.isNotEmpty;

  List<SavedPlace> get savedPlaces => List.unmodifiable(_savedPlaces);

  bool get hasSavedPlaces => _savedPlaces.isNotEmpty;

  bool get isLoading => _isLoading;

  bool get isLoadingTrips => _isLoadingTrips;

  bool get isLoadingSavedPlaces => _isLoadingSavedPlaces;

  String? get errorMessage => _errorMessage;

  String? get tripErrorMessage => _tripErrorMessage;

  String? get savedPlaceErrorMessage => _savedPlaceErrorMessage;

  // -------------------------------------------------------------------------
  // Load everything
  // -------------------------------------------------------------------------

  Future<void> load() async {
    _errorMessage = null;
    _tripErrorMessage = null;
    _savedPlaceErrorMessage = null;

    _isLoading = true;
    notifyListeners();

    try {
      await Future.wait([
        loadTrips(),
        loadSavedPlaces(),
      ]);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -------------------------------------------------------------------------
  // Load trips independently
  // -------------------------------------------------------------------------

  Future<void> loadTrips() async {
    _isLoadingTrips = true;
    _tripErrorMessage = null;

    notifyListeners();

    try {
      final loadedTrips = await _repo.getTrips();

      _trips = List<Trip>.from(loadedTrips);
    } on TripRepositoryException catch (error) {
      _tripErrorMessage = error.message;
      _errorMessage = error.message;
    } catch (_) {
      _tripErrorMessage = 'Unable to load your trips. Please try again.';

      _errorMessage = _tripErrorMessage;
    } finally {
      _isLoadingTrips = false;
      notifyListeners();
    }
  }

  // -------------------------------------------------------------------------
  // Load saved places independently
  // -------------------------------------------------------------------------

  Future<void> loadSavedPlaces() async {
    _isLoadingSavedPlaces = true;
    _savedPlaceErrorMessage = null;

    notifyListeners();

    try {
      final loadedPlaces = await _repo.getSavedPlaces();

      _savedPlaces = List<SavedPlace>.from(loadedPlaces);
    } on TripRepositoryException catch (error) {
      _savedPlaceErrorMessage = error.message;
      _errorMessage = error.message;
    } catch (_) {
      _savedPlaceErrorMessage =
          'Unable to load your saved places. Please try again.';

      _errorMessage = _savedPlaceErrorMessage;
    } finally {
      _isLoadingSavedPlaces = false;
      notifyListeners();
    }
  }

  // -------------------------------------------------------------------------
  // Create trip
  // -------------------------------------------------------------------------

  Future<Trip?> createTrip({
    required String name,
    required String destinationId,
    required DateTime startDate,
    required DateTime endDate,
    required int travelers,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _tripErrorMessage = null;

    notifyListeners();

    try {
      final trip = Trip(
        id: '',
        name: name.trim(),
        destinationId: destinationId,
        startDate: startDate,
        endDate: endDate,
        travelers: travelers,
        status: TripStatus.planning,
      );

      final createdTrip = await _repo.createTrip(trip);

      _trips = [
        ..._trips,
        createdTrip,
      ];

      return createdTrip;
    } on TripRepositoryException catch (error) {
      _errorMessage = error.message;
      _tripErrorMessage = error.message;

      return null;
    } catch (_) {
      const message = 'Unable to create your trip. Please try again.';

      _errorMessage = message;
      _tripErrorMessage = message;

      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -------------------------------------------------------------------------
  // Save place
  // -------------------------------------------------------------------------

  Future<void> savePlace(
    String destinationId,
    String name,
  ) async {
    _errorMessage = null;
    _savedPlaceErrorMessage = null;

    // Prevent duplicate local saves.
    final alreadySaved = _savedPlaces.any(
      (place) => place.destinationId == destinationId,
    );

    if (alreadySaved) {
      notifyListeners();
      return;
    }

    try {
      final place = SavedPlace(
        id: '',
        destinationId: destinationId,
        name: name.trim(),
      );

      await _repo.savePlace(place);

      // Generate a local fallback identifier because
      // Supabase generates the real database ID.
      final localPlace = SavedPlace(
        id: 'local_${DateTime.now().microsecondsSinceEpoch}',
        destinationId: destinationId,
        name: name.trim(),
      );

      _savedPlaces = [
        ..._savedPlaces,
        localPlace,
      ];

      notifyListeners();
    } on TripRepositoryException catch (error) {
      _errorMessage = error.message;
      _savedPlaceErrorMessage = error.message;

      notifyListeners();
    } catch (_) {
      const message = 'Unable to save this place. Please try again.';

      _errorMessage = message;
      _savedPlaceErrorMessage = message;

      notifyListeners();
    }
  }

  // -------------------------------------------------------------------------
  // Clear state when user changes account
  // -------------------------------------------------------------------------

  void clear() {
    _trips = [];
    _savedPlaces = [];

    _errorMessage = null;
    _tripErrorMessage = null;
    _savedPlaceErrorMessage = null;

    _isLoading = false;
    _isLoadingTrips = false;
    _isLoadingSavedPlaces = false;

    notifyListeners();
  }
}

// ---------------------------------------------------------------------------
// Budget state
// ---------------------------------------------------------------------------

class BudgetState extends ChangeNotifier {
  AsyncStatus _status = AsyncStatus.idle;

  Map<String, int>? _breakdown;

  AsyncStatus get status => _status;

  Map<String, int>? get breakdown => _breakdown;

  Future<void> calculateBudget({
    required String destination,
    required int days,
    required int travelers,
  }) async {
    _status = AsyncStatus.loading;
    notifyListeners();

    await Future.delayed(
      const Duration(seconds: 2),
    );

    _breakdown = {
      'Accommodation': 15000 * travelers * days ~/ 5,
      'Transport': 12000,
      'Food': 8500 * travelers * days ~/ 5,
      'Activities': 6000,
      'Shopping': 2000,
      'Emergency Buffer': 2000,
    };

    _status = AsyncStatus.success;
    notifyListeners();
  }

  void reset() {
    _status = AsyncStatus.idle;
    _breakdown = null;
    notifyListeners();
  }

  void debugForceStatus(AsyncStatus status) {
    _status = status;
    notifyListeners();
  }
}

// ---------------------------------------------------------------------------
// Recommendation state
// ---------------------------------------------------------------------------

class RecommendationState extends ChangeNotifier {
  AsyncStatus _status = AsyncStatus.idle;

  List<Destination> _recommendations = [];

  AsyncStatus get status => _status;

  List<Destination> get recommendations => List.unmodifiable(_recommendations);

  bool get hasRecommendations => _recommendations.isNotEmpty;

  Future<void> load() async {
    _status = AsyncStatus.loading;
    notifyListeners();

    await Future.delayed(
      const Duration(seconds: 2),
    );

    _recommendations = [
      const Destination(
        id: 'rishikesh',
        name: 'Rishikesh',
        state: 'Uttarakhand',
        category: 'Adventure',
        budgetTier: '₹',
      ),
      const Destination(
        id: 'munnar',
        name: 'Munnar',
        state: 'Kerala',
        category: 'Hill Stations',
        budgetTier: '₹₹',
      ),
      const Destination(
        id: 'jaisalmer',
        name: 'Jaisalmer',
        state: 'Rajasthan',
        category: 'Heritage',
        budgetTier: '₹₹',
      ),
      const Destination(
        id: 'gokarna',
        name: 'Gokarna',
        state: 'Karnataka',
        category: 'Beaches',
        budgetTier: '₹',
      ),
    ];

    _status = AsyncStatus.success;
    notifyListeners();
  }

  void reset() {
    _status = AsyncStatus.idle;
    _recommendations = [];
    notifyListeners();
  }

  void debugForceStatus(AsyncStatus status) {
    _status = status;
    notifyListeners();
  }
}

// ---------------------------------------------------------------------------
// Notification state
// ---------------------------------------------------------------------------

class AppNotificationState extends ChangeNotifier {
  int _unreadCount = 3;

  int get unreadCount => _unreadCount;

  void markAllRead() {
    _unreadCount = 0;
    notifyListeners();
  }
}
