import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'itinerary_item.dart';
import 'trip_repository.dart';

/// Supabase-backed implementation for the Trip domain.
///
/// Data ownership:
///
///     Supabase Auth
///          ↓
///     authenticated user UUID
///          ↓
///     trips / saved_places
///          ↓
///     PostgreSQL RLS
///
/// This repository never trusts a user ID supplied by the UI.
/// The authenticated Supabase user's ID is always used.
class SupabaseTripRepository implements TripRepository {
  SupabaseTripRepository({
    SupabaseClient? client,
  }) : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  // ===========================================================================
  // Authentication
  // ===========================================================================

  User _requireAuthenticatedUser() {
    final session = _client.auth.currentSession;
    final user = _client.auth.currentUser;

    debugPrint(
      '════════════════════════════════════════════════════════════',
    );

    debugPrint(
      '[TravelBuddy][AUTH] currentSession: '
      '${session != null ? 'EXISTS' : 'NULL'}',
    );

    debugPrint(
      '[TravelBuddy][AUTH] currentUser: '
      '${user != null ? 'EXISTS' : 'NULL'}',
    );

    if (user != null) {
      debugPrint(
        '[TravelBuddy][AUTH] user.id: ${user.id}',
      );

      debugPrint(
        '[TravelBuddy][AUTH] user.email: ${user.email}',
      );
    }

    if (user == null) {
      debugPrint(
        '[TravelBuddy][AUTH] ERROR: No authenticated Supabase user.',
      );

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      throw const TripRepositoryException(
        'You must be signed in to access your travel data.',
      );
    }

    return user;
  }

  // ===========================================================================
  // Trips — READ
  // ===========================================================================

  @override
  Future<List<Trip>> getTrips() async {
    debugPrint(
      '[TravelBuddy][TRIPS] Starting getTrips()',
    );

    final user = _requireAuthenticatedUser();

    debugPrint(
      '[TravelBuddy][TRIPS] Querying trips for user: ${user.id}',
    );

    try {
      final rows = await _client
          .from('trips')
          .select()
          .eq(
            'user_id',
            user.id,
          )
          .order(
            'start_date',
            ascending: true,
          );

      debugPrint(
        '[TravelBuddy][TRIPS] Query SUCCESS',
      );

      debugPrint(
        '[TravelBuddy][TRIPS] Rows returned: ${rows.length}',
      );

      for (final row in rows) {
        debugPrint(
          '[TravelBuddy][TRIPS] Row: $row',
        );
      }

      final trips = rows
          .map(
            (row) => _tripFromRow(
              Map<String, dynamic>.from(row),
            ),
          )
          .toList();

      debugPrint(
        '[TravelBuddy][TRIPS] Parsed trips: ${trips.length}',
      );

      return trips;
    } on PostgrestException catch (error) {
      _logPostgrestError(
        operation: 'GET trips',
        error: error,
      );

      throw TripRepositoryException(
        'Unable to load your trips: ${error.message}',
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[TravelBuddy][TRIPS] UNEXPECTED ERROR: $error',
      );

      debugPrint(
        '[TravelBuddy][TRIPS] STACK TRACE: $stackTrace',
      );

      throw TripRepositoryException(
        'Unable to load your trips. '
        'Please try again. '
        'Details: $error',
      );
    }
  }

  // ===========================================================================
  // Trips — CREATE
  // ===========================================================================

  @override
  Future<Trip> createTrip(
    Trip trip,
  ) async {
    debugPrint(
      '[TravelBuddy][TRIPS] Starting createTrip()',
    );

    final user = _requireAuthenticatedUser();

    debugPrint(
      '[TravelBuddy][TRIPS] Creating trip for user: ${user.id}',
    );

    debugPrint(
      '[TravelBuddy][TRIPS] name: ${trip.name}',
    );

    debugPrint(
      '[TravelBuddy][TRIPS] destination_id: ${trip.destinationId}',
    );

    debugPrint(
      '[TravelBuddy][TRIPS] travelers: ${trip.travelers}',
    );

    try {
      final payload = {
        'user_id': user.id,
        'name': trip.name.trim(),
        'destination_id': trip.destinationId,
        'start_date': _dateOnly(
          trip.startDate,
        ),
        'end_date': _dateOnly(
          trip.endDate,
        ),
        'travelers': trip.travelers,
        'status': _statusToDatabase(
          trip.status,
        ),
      };

      debugPrint(
        '[TravelBuddy][TRIPS] INSERT payload: $payload',
      );

      final row = await _client.from('trips').insert(payload).select().single();

      debugPrint(
        '[TravelBuddy][TRIPS] CREATE SUCCESS',
      );

      debugPrint(
        '[TravelBuddy][TRIPS] Created row: $row',
      );

      return _tripFromRow(
        Map<String, dynamic>.from(row),
      );
    } on PostgrestException catch (error) {
      _logPostgrestError(
        operation: 'CREATE trip',
        error: error,
      );

      throw TripRepositoryException(
        'Unable to create your trip: ${error.message}',
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[TravelBuddy][TRIPS] CREATE UNEXPECTED ERROR: $error',
      );

      debugPrint(
        '[TravelBuddy][TRIPS] STACK TRACE: $stackTrace',
      );

      throw TripRepositoryException(
        'Unable to create your trip. '
        'Please try again. '
        'Details: $error',
      );
    }
  }

  // ===========================================================================
  // Itinerary — READ
  // ===========================================================================

  @override
  Future<List<ItineraryItem>> getItinerary(
    String tripId,
  ) async {
    _requireNonEmpty(
      tripId,
      'Trip id',
    );

    _requireAuthenticatedUser();

    try {
      final rows = await _client
          .from('itinerary_items')
          .select()
          .eq(
            'trip_id',
            tripId,
          )
          .order(
            'day_number',
            ascending: true,
          )
          .order(
            'sort_order',
            ascending: true,
          );

      return rows
          .map(
            (row) => _itineraryItemFromRow(
              Map<String, dynamic>.from(row),
            ),
          )
          .toList();
    } on PostgrestException catch (error) {
      _logPostgrestError(
        operation: 'GET itinerary_items',
        error: error,
      );

      throw TripRepositoryException(
        'Unable to load the trip itinerary: ${error.message}',
      );
    } catch (error, stackTrace) {
      debugPrint('[TravelBuddy][ITINERARY] GET UNEXPECTED ERROR: $error');
      debugPrint('[TravelBuddy][ITINERARY] STACK TRACE: $stackTrace');

      if (error is TripRepositoryException) {
        rethrow;
      }

      throw TripRepositoryException(
        'Unable to load the trip itinerary. Please try again.',
      );
    }
  }

  // ===========================================================================
  // Itinerary — CREATE
  // ===========================================================================

  @override
  Future<ItineraryItem> addItineraryItem(
    ItineraryItem item,
  ) async {
    _validateItineraryItem(
      item,
      requireId: false,
    );

    _requireAuthenticatedUser();

    try {
      final row = await _client
          .from('itinerary_items')
          .insert(
            {
              'trip_id': item.tripId,
              'day_number': item.dayNumber,
              'title': item.title.trim(),
              'description': item.description,
              'location': item.location,
              'category': item.category,
              'sort_order': item.sortOrder,
            },
          )
          .select()
          .single();

      return _itineraryItemFromRow(
        Map<String, dynamic>.from(row),
      );
    } on PostgrestException catch (error) {
      _logPostgrestError(
        operation: 'INSERT itinerary_items',
        error: error,
      );

      throw TripRepositoryException(
        'Unable to add the itinerary item: ${error.message}',
      );
    } catch (error, stackTrace) {
      debugPrint('[TravelBuddy][ITINERARY] INSERT UNEXPECTED ERROR: $error');
      debugPrint('[TravelBuddy][ITINERARY] STACK TRACE: $stackTrace');

      if (error is TripRepositoryException) {
        rethrow;
      }

      throw TripRepositoryException(
        'Unable to add the itinerary item. Please try again.',
      );
    }
  }

  // ===========================================================================
  // Itinerary — UPDATE
  // ===========================================================================

  @override
  Future<ItineraryItem> updateItineraryItem(
    ItineraryItem item,
  ) async {
    _validateItineraryItem(item);

    _requireAuthenticatedUser();

    try {
      final row = await _client
          .from('itinerary_items')
          .update(
            {
              'day_number': item.dayNumber,
              'title': item.title.trim(),
              'description': item.description,
              'location': item.location,
              'category': item.category,
              'sort_order': item.sortOrder,
              'updated_at': DateTime.now().toUtc().toIso8601String(),
            },
          )
          .eq(
            'id',
            item.id,
          )
          .select()
          .single();

      return _itineraryItemFromRow(
        Map<String, dynamic>.from(row),
      );
    } on PostgrestException catch (error) {
      _logPostgrestError(
        operation: 'UPDATE itinerary_items',
        error: error,
      );

      throw TripRepositoryException(
        'Unable to update the itinerary item: ${error.message}',
      );
    } catch (error, stackTrace) {
      debugPrint('[TravelBuddy][ITINERARY] UPDATE UNEXPECTED ERROR: $error');
      debugPrint('[TravelBuddy][ITINERARY] STACK TRACE: $stackTrace');

      if (error is TripRepositoryException) {
        rethrow;
      }

      throw TripRepositoryException(
        'Unable to update the itinerary item. Please try again.',
      );
    }
  }

  // ===========================================================================
  // Itinerary — DELETE
  // ===========================================================================

  @override
  Future<void> deleteItineraryItem(
    String itemId,
  ) async {
    _requireNonEmpty(
      itemId,
      'Itinerary item id',
    );

    _requireAuthenticatedUser();

    try {
      await _client.from('itinerary_items').delete().eq(
            'id',
            itemId,
          );
    } on PostgrestException catch (error) {
      _logPostgrestError(
        operation: 'DELETE itinerary_items',
        error: error,
      );

      throw TripRepositoryException(
        'Unable to delete the itinerary item: ${error.message}',
      );
    } catch (error, stackTrace) {
      debugPrint('[TravelBuddy][ITINERARY] DELETE UNEXPECTED ERROR: $error');
      debugPrint('[TravelBuddy][ITINERARY] STACK TRACE: $stackTrace');

      if (error is TripRepositoryException) {
        rethrow;
      }

      throw TripRepositoryException(
        'Unable to delete the itinerary item. Please try again.',
      );
    }
  }

  // ===========================================================================
  // Saved Places — READ
  // ===========================================================================

  @override
  Future<List<SavedPlace>> getSavedPlaces() async {
    debugPrint(
      '[TravelBuddy][SAVED] Starting getSavedPlaces()',
    );

    final user = _requireAuthenticatedUser();

    debugPrint(
      '[TravelBuddy][SAVED] Querying saved_places for user: ${user.id}',
    );

    try {
      final rows = await _client
          .from('saved_places')
          .select()
          .eq(
            'user_id',
            user.id,
          )
          .order(
            'created_at',
            ascending: false,
          );

      debugPrint(
        '[TravelBuddy][SAVED] Query SUCCESS',
      );

      debugPrint(
        '[TravelBuddy][SAVED] Rows returned: ${rows.length}',
      );

      for (final row in rows) {
        debugPrint(
          '[TravelBuddy][SAVED] Row: $row',
        );
      }

      final places = rows
          .map(
            (row) => _savedPlaceFromRow(
              Map<String, dynamic>.from(row),
            ),
          )
          .toList();

      debugPrint(
        '[TravelBuddy][SAVED] Parsed places: ${places.length}',
      );

      return places;
    } on PostgrestException catch (error) {
      _logPostgrestError(
        operation: 'GET saved_places',
        error: error,
      );

      throw TripRepositoryException(
        'Unable to load your saved places: ${error.message}',
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[TravelBuddy][SAVED] UNEXPECTED ERROR: $error',
      );

      debugPrint(
        '[TravelBuddy][SAVED] STACK TRACE: $stackTrace',
      );

      throw TripRepositoryException(
        'Unable to load your saved places. '
        'Please try again. '
        'Details: $error',
      );
    }
  }

  // ===========================================================================
  // Saved Places — CREATE
  // ===========================================================================

  @override
  Future<void> savePlace(
    SavedPlace place,
  ) async {
    debugPrint(
      '════════════════════════════════════════════════════════════',
    );

    debugPrint(
      '[TravelBuddy][SAVED] Starting savePlace()',
    );

    final user = _requireAuthenticatedUser();

    debugPrint(
      '[TravelBuddy][SAVED] Saving for user: ${user.id}',
    );

    debugPrint(
      '[TravelBuddy][SAVED] destination_id: ${place.destinationId}',
    );

    debugPrint(
      '[TravelBuddy][SAVED] name: ${place.name}',
    );

    try {
      // -----------------------------------------------------------------------
      // Check for an existing saved place.
      // -----------------------------------------------------------------------

      debugPrint(
        '[TravelBuddy][SAVED] Checking for existing place...',
      );

      final existing = await _client
          .from('saved_places')
          .select('id')
          .eq(
            'user_id',
            user.id,
          )
          .eq(
            'destination_id',
            place.destinationId,
          )
          .maybeSingle();

      if (existing != null) {
        debugPrint(
          '[TravelBuddy][SAVED] Place already exists: $existing',
        );

        debugPrint(
          '[TravelBuddy][SAVED] Treating as successful save.',
        );

        return;
      }

      // -----------------------------------------------------------------------
      // Insert.
      // -----------------------------------------------------------------------

      final payload = {
        'user_id': user.id,
        'destination_id': place.destinationId,
        'name': place.name.trim(),
      };

      debugPrint(
        '[TravelBuddy][SAVED] INSERT payload: $payload',
      );

      await _client.from('saved_places').insert(payload);

      debugPrint(
        '[TravelBuddy][SAVED] INSERT SUCCESS',
      );

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );
    } on PostgrestException catch (error) {
      _logPostgrestError(
        operation: 'INSERT saved_places',
        error: error,
      );

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      throw TripRepositoryException(
        'Unable to save this place: ${error.message}',
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[TravelBuddy][SAVED] UNEXPECTED ERROR: $error',
      );

      debugPrint(
        '[TravelBuddy][SAVED] STACK TRACE: $stackTrace',
      );

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      throw TripRepositoryException(
        'Unable to save this place. '
        'Please try again. '
        'Details: $error',
      );
    }
  }

  // ===========================================================================
  // Supabase error diagnostics
  // ===========================================================================

  static void _logPostgrestError({
    required String operation,
    required PostgrestException error,
  }) {
    debugPrint(
      '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
    );

    debugPrint(
      '[TravelBuddy][SUPABASE ERROR]',
    );

    debugPrint(
      '[TravelBuddy][SUPABASE ERROR] Operation: $operation',
    );

    debugPrint(
      '[TravelBuddy][SUPABASE ERROR] Message: ${error.message}',
    );

    debugPrint(
      '[TravelBuddy][SUPABASE ERROR] Code: ${error.code}',
    );

    debugPrint(
      '[TravelBuddy][SUPABASE ERROR] Details: ${error.details}',
    );

    debugPrint(
      '[TravelBuddy][SUPABASE ERROR] Hint: ${error.hint}',
    );

    debugPrint(
      '[TravelBuddy][SUPABASE ERROR] Error: $error',
    );

    debugPrint(
      '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
    );
  }

  // ===========================================================================
  // Trip mapping
  // ===========================================================================

  static Trip _tripFromRow(
    Map<String, dynamic> row,
  ) {
    final id = row['id']?.toString();
    final name = row['name']?.toString();
    final destinationId = row['destination_id']?.toString();

    final startDate = row['start_date']?.toString();

    final endDate = row['end_date']?.toString();

    final travelers = row['travelers'];

    if (id == null ||
        name == null ||
        destinationId == null ||
        startDate == null ||
        endDate == null ||
        travelers == null) {
      throw const TripRepositoryException(
        'A trip returned by Supabase is missing required data.',
      );
    }

    return Trip(
      id: id,
      name: name,
      destinationId: destinationId,
      startDate: _parseDatabaseDate(
        startDate,
      ),
      endDate: _parseDatabaseDate(
        endDate,
      ),
      travelers: (travelers as num).toInt(),
      status: _statusFromDatabase(
        row['status']?.toString() ?? 'planning',
      ),
    );
  }

  // ===========================================================================
  // Saved place mapping
  // ===========================================================================

  static SavedPlace _savedPlaceFromRow(
    Map<String, dynamic> row,
  ) {
    final id = row['id']?.toString();
    final destinationId = row['destination_id']?.toString();
    final name = row['name']?.toString();

    if (id == null || destinationId == null || name == null) {
      throw const TripRepositoryException(
        'A saved place returned by Supabase is missing required data.',
      );
    }

    return SavedPlace(
      id: id,
      destinationId: destinationId,
      name: name,
    );
  }

  // ===========================================================================
  // Itinerary mapping and validation
  // ===========================================================================

  static ItineraryItem _itineraryItemFromRow(
    Map<String, dynamic> row,
  ) {
    try {
      final item = ItineraryItem.fromMap(row);
      item.validate();
      return item;
    } on FormatException catch (error) {
      throw TripRepositoryException(
        'An itinerary item returned by Supabase is invalid: ${error.message}',
      );
    }
  }

  static void _validateItineraryItem(
    ItineraryItem item, {
    bool requireId = true,
  }) {
    try {
      item.validate(requireId: requireId);
    } on FormatException catch (error) {
      throw TripRepositoryException(error.message);
    }
  }

  static void _requireNonEmpty(
    String value,
    String fieldName,
  ) {
    if (value.trim().isEmpty) {
      throw TripRepositoryException('$fieldName must not be empty.');
    }
  }

  // ===========================================================================
  // Status mapping
  // ===========================================================================

  static TripStatus _statusFromDatabase(
    String value,
  ) {
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

  static String _statusToDatabase(
    TripStatus status,
  ) {
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

  // ===========================================================================
  // Date helpers
  // ===========================================================================

  static String _dateOnly(
    DateTime value,
  ) {
    final local = value.toLocal();

    String twoDigits(
      int value,
    ) {
      return value.toString().padLeft(
            2,
            '0',
          );
    }

    return '${local.year}-'
        '${twoDigits(local.month)}-'
        '${twoDigits(local.day)}';
  }

  static DateTime _parseDatabaseDate(
    String value,
  ) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      throw TripRepositoryException(
        'Invalid trip date returned by Supabase: $value',
      );
    }
  }
}

// =============================================================================
// Repository exception
// =============================================================================

class TripRepositoryException implements Exception {
  const TripRepositoryException(
    this.message,
  );

  final String message;

  @override
  String toString() => message;
}
