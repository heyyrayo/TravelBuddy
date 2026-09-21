// Trip domain models and repository contract.

import 'itinerary_item.dart';

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

enum TripStatus {
  planning,
  upcoming,
  active,
  completed,
}

class SavedPlace {
  const SavedPlace({
    required this.id,
    required this.destinationId,
    required this.name,
  });

  final String id;
  final String destinationId;
  final String name;
}

abstract class TripRepository {
  Future<List<Trip>> getTrips();

  Future<Trip> createTrip(Trip trip);

  Future<List<SavedPlace>> getSavedPlaces();

  Future<void> savePlace(SavedPlace place);

  Future<List<ItineraryItem>> getItinerary(String tripId);

  Future<ItineraryItem> addItineraryItem(ItineraryItem item);

  Future<ItineraryItem> updateItineraryItem(ItineraryItem item);

  Future<void> deleteItineraryItem(String itemId);
}

class TripRepositoryException implements Exception {
  const TripRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
