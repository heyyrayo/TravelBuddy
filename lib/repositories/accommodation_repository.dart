import '../core/database/accommodation_database.dart';
import '../models/accommodation.dart';

class AccommodationRepository {
  AccommodationRepository({
    AccommodationDatabase? database,
  }) : _database = database ?? AccommodationDatabase.instance;

  final AccommodationDatabase _database;

  Future<List<Accommodation>> getAllAccommodations({
    int? limit,
    int? offset,
  }) {
    return _database.getAllAccommodations(
      limit: limit,
      offset: offset,
    );
  }

  Future<List<Accommodation>> searchAccommodations({
    String searchQuery = '',
    String? state,
    String? accommodationType,
    int? limit,
    int? offset,
  }) {
    return _database.searchAccommodations(
      searchQuery: searchQuery,
      state: state,
      accommodationType: accommodationType,
      limit: limit,
      offset: offset,
    );
  }

  Future<Accommodation?> getAccommodationById(
    String recordId,
  ) {
    return _database.getAccommodationById(recordId);
  }

  Future<List<String>> getStates() {
    return _database.getStates();
  }

  Future<List<String>> getAccommodationTypes() {
    return _database.getAccommodationTypes();
  }

  Future<int> getAccommodationCount({
    String searchQuery = '',
    String? state,
    String? accommodationType,
  }) {
    return _database.getAccommodationCount(
      searchQuery: searchQuery,
      state: state,
      accommodationType: accommodationType,
    );
  }

  Future<void> close() {
    return _database.close();
  }
}
