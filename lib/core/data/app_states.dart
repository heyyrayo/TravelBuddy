import 'package:flutter/material.dart';
import 'destination_repository.dart';
import 'trip_repository.dart';

// ---------------------------------------------------------------------------
// Async lifecycle enum (shared by Budget and Recommendations states)
// ---------------------------------------------------------------------------
enum AsyncStatus { idle, loading, success, error }

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
    if (query.isEmpty) {
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

  List<Trip> get trips => _trips;
  bool get hasTrips => _trips.isNotEmpty;
  List<SavedPlace> get savedPlaces => _savedPlaces;
  bool get hasSavedPlaces => _savedPlaces.isNotEmpty;

  Future<void> load() async {
    _trips = await _repo.getTrips();
    _savedPlaces = await _repo.getSavedPlaces();
    notifyListeners();
  }

  Future<void> createTrip({
    required String name,
    required String destinationId,
    required DateTime startDate,
    required DateTime endDate,
    required int travelers,
  }) async {
    final trip = Trip(
      id: 'trip_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      destinationId: destinationId,
      startDate: startDate,
      endDate: endDate,
      travelers: travelers,
    );
    await _repo.createTrip(trip);
    _trips = await _repo.getTrips();
    notifyListeners();
  }

  Future<void> savePlace(String destinationId, String name) async {
    final place = SavedPlace(
      id: 'sp_${DateTime.now().millisecondsSinceEpoch}',
      destinationId: destinationId,
      name: name,
    );
    await _repo.savePlace(place);
    _savedPlaces = await _repo.getSavedPlaces();
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

  Future<void> calculateBudget({required String destination, required int days, required int travelers}) async {
    _status = AsyncStatus.loading;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    // Success path — set shouldFail=true via debugForceStatus() for error testing
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

  // Debug helper — force a specific status
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
    await Future.delayed(const Duration(seconds: 2));
    _recommendations = [
      const Destination(id: 'rishikesh', name: 'Rishikesh', state: 'Uttarakhand', category: 'Adventure', budgetTier: '₹'),
      const Destination(id: 'munnar', name: 'Munnar', state: 'Kerala', category: 'Hill Stations', budgetTier: '₹₹'),
      const Destination(id: 'jaisalmer', name: 'Jaisalmer', state: 'Rajasthan', category: 'Heritage', budgetTier: '₹₹'),
      const Destination(id: 'gokarna', name: 'Gokarna', state: 'Karnataka', category: 'Beaches', budgetTier: '₹'),
    ];
    _status = AsyncStatus.success;
    notifyListeners();
  }

  void reset() {
    _status = AsyncStatus.idle;
    _recommendations = [];
    notifyListeners();
  }

  // Debug helper
  void debugForceStatus(AsyncStatus status) {
    _status = status;
    if (status == AsyncStatus.success && _recommendations.isEmpty) {
      // leave empty for empty-state testing
    }
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
