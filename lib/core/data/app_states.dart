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

  List<Destination> get destinations => _destinations;

  List<Destination> get searchResults => _searchResults;

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
  String? _errorMessage;

  List<Trip> get trips => List.unmodifiable(_trips);

  bool get hasTrips => _trips.isNotEmpty;

  List<SavedPlace> get savedPlaces => List.unmodifiable(_savedPlaces);

  bool get hasSavedPlaces => _savedPlaces.isNotEmpty;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _trips = await _repo.getTrips();
      _savedPlaces = await _repo.getSavedPlaces();
    } on TripRepositoryException catch (error) {
      _errorMessage = error.message;
    } catch (_) {
      _errorMessage = 'Unable to load your trips. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Trip?> createTrip({
    required String name,
    required String destinationId,
    required DateTime startDate,
    required DateTime endDate,
    required int travelers,
  }) async {
    _isLoading = true;
    _errorMessage = null;
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
      return null;
    } catch (_) {
      _errorMessage = 'Unable to create your trip. Please try again.';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> savePlace(
    String destinationId,
    String name,
  ) async {
    try {
      final place = SavedPlace(
        id: 'sp_${DateTime.now().millisecondsSinceEpoch}',
        destinationId: destinationId,
        name: name,
      );

      await _repo.savePlace(place);

      _savedPlaces = [
        ..._savedPlaces,
        place,
      ];

      notifyListeners();
    } on TripRepositoryException catch (error) {
      _errorMessage = error.message;
      notifyListeners();
    }
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

  List<Destination> get recommendations => _recommendations;

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
