import 'package:supabase_flutter/supabase_flutter.dart';

// ---------------------------------------------------------------------------
// Trip domain model
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Saved place domain model
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Repository contract
// ---------------------------------------------------------------------------

abstract class TripRepository {
  Future<List<Trip>> getTrips();

  Future<Trip> createTrip(Trip trip);

  Future<List<SavedPlace>> getSavedPlaces();

  Future<void> savePlace(SavedPlace place);
}

// ---------------------------------------------------------------------------
// Supabase implementation
//
// Trips are stored in PostgreSQL and protected by RLS.
// Saved places remain in-memory for now; we will move them to Supabase
// after creating their own user-owned table and RLS policies.
// ---------------------------------------------------------------------------

class SupabaseTripRepository implements TripRepository {
  SupabaseTripRepository({
    SupabaseClient? client,
  }) : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<Trip>> getTrips() async {
    final rows = await _client
        .from('trips')
        .select()
        .order('start_date', ascending: true);

    return rows
        .map(
          (row) => _tripFromRow(
            Map<String, dynamic>.from(row),
          ),
        )
        .toList();
  }

  @override
  Future<Trip> createTrip(Trip trip) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw const TripRepositoryException(
        'You must be signed in to create a trip.',
      );
    }

    try {
      final row = await _client
          .from('trips')
          .insert({
            'user_id': user.id,
            'name': trip.name,
            'destination_id': trip.destinationId,
            'start_date': _dateOnly(trip.startDate),
            'end_date': _dateOnly(trip.endDate),
            'travelers': trip.travelers,
            'status': _statusToDatabase(trip.status),
          })
          .select()
          .single();

      return _tripFromRow(
        Map<String, dynamic>.from(row),
      );
    } on PostgrestException catch (error) {
      throw TripRepositoryException(
        'Unable to create your trip: ${error.message}',
      );
    } catch (_) {
      throw const TripRepositoryException(
        'Unable to create your trip. Please try again.',
      );
    }
  }

  @override
  Future<List<SavedPlace>> getSavedPlaces() async {
    return const [];
  }

  @override
  Future<void> savePlace(SavedPlace place) async {
    throw const TripRepositoryException(
      'Saved places backend is not connected yet.',
    );
  }

  static Trip _tripFromRow(Map<String, dynamic> row) {
    return Trip(
      id: row['id'] as String,
      name: row['name'] as String,
      destinationId: row['destination_id'] as String,
      startDate: DateTime.parse(row['start_date'] as String),
      endDate: DateTime.parse(row['end_date'] as String),
      travelers: (row['travelers'] as num).toInt(),
      status: _statusFromDatabase(
        row['status'] as String? ?? 'planning',
      ),
    );
  }

  static TripStatus _statusFromDatabase(String value) {
    switch (value) {
      case 'upcoming':
        return TripStatus.upcoming;
      case 'active':
        return TripStatus.active;
      case 'completed':
        return TripStatus.completed;
      case 'planning':
      default:
        return TripStatus.planning;
    }
  }

  static String _statusToDatabase(TripStatus status) {
    switch (status) {
      case TripStatus.planning:
        return 'planning';
      case TripStatus.upcoming:
        return 'upcoming';
      case TripStatus.active:
        return 'active';
      case TripStatus.completed:
        return 'completed';
    }
  }

  static String _dateOnly(DateTime value) {
    final local = value.toLocal();

    String twoDigits(int number) {
      return number.toString().padLeft(2, '0');
    }

    return '${local.year}-'
        '${twoDigits(local.month)}-'
        '${twoDigits(local.day)}';
  }
}

// ---------------------------------------------------------------------------
// Repository exception
// ---------------------------------------------------------------------------

class TripRepositoryException implements Exception {
  const TripRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
