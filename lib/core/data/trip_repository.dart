// Trip domain models and repository
class Trip {
  Trip({
    required this.id,
    required this.name,
    required this.destinationId,
    required this.startDate,
    required this.endDate,
    required this.travelers,
    this.status = TripStatus.planning,
  });

  final String id;
  final String name;
  final String destinationId;
  final DateTime startDate;
  final DateTime endDate;
  final int travelers;
  TripStatus status;
}

enum TripStatus { planning, upcoming, active, completed }

class SavedPlace {
  const SavedPlace({required this.id, required this.destinationId, required this.name});

  final String id;
  final String destinationId;
  final String name;
}

abstract class TripRepository {
  Future<List<Trip>> getTrips();
  Future<Trip> createTrip(Trip trip);
  Future<List<SavedPlace>> getSavedPlaces();
  Future<void> savePlace(SavedPlace place);
}

class InMemoryTripRepository implements TripRepository {
  final List<Trip> _trips = [];
  final List<SavedPlace> _savedPlaces = [];

  @override
  Future<List<Trip>> getTrips() async => List.unmodifiable(_trips);

  @override
  Future<Trip> createTrip(Trip trip) async {
    _trips.add(trip);
    return trip;
  }

  @override
  Future<List<SavedPlace>> getSavedPlaces() async => List.unmodifiable(_savedPlaces);

  @override
  Future<void> savePlace(SavedPlace place) async => _savedPlaces.add(place);
}
