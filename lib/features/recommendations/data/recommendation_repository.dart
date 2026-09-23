import '../../../core/database/recommendation_database.dart';
import '../domain/recommendation_monthly_features.dart';

class RecommendationRepository {
  RecommendationRepository({
    RecommendationDatabase? database,
  }) : _database = database ?? RecommendationDatabase.instance;

  final RecommendationDatabase _database;

  Future<List<RecommendationMonthlyFeatures>> getAllFeatures() async {
    final rows = await _database.getAllFeatures();

    return rows
        .map(RecommendationMonthlyFeatures.fromMap)
        .toList(growable: false);
  }

  Future<List<RecommendationMonthlyFeatures>> getFeaturesByDestination(
    String destinationId,
  ) async {
    final rows = await _database.getFeaturesByDestination(
      destinationId,
    );

    return rows
        .map(RecommendationMonthlyFeatures.fromMap)
        .toList(growable: false);
  }

  Future<RecommendationMonthlyFeatures?> getFeaturesByDestinationAndMonth({
    required String destinationId,
    required String month,
  }) async {
    final row = await _database.getFeaturesByDestinationAndMonth(
      destinationId: destinationId,
      month: month,
    );

    if (row == null) {
      return null;
    }

    return RecommendationMonthlyFeatures.fromMap(row);
  }

  Future<List<RecommendationMonthlyFeatures>> getFeaturesByMonth(
    String month,
  ) async {
    final rows = await _database.getFeaturesByMonth(month);

    return rows
        .map(RecommendationMonthlyFeatures.fromMap)
        .toList(growable: false);
  }

  Future<int> getFeatureCount() {
    return _database.getFeatureCount();
  }

  Future<int> getDestinationCount() {
    return _database.getDestinationCount();
  }

  Future<void> close() {
    return _database.close();
  }
}
