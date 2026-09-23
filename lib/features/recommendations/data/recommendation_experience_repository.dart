import '../../../core/database/recommendation_experience_database.dart';
import '../domain/recommendation_monthly_experience_evidence.dart';

class RecommendationExperienceRepository {
  RecommendationExperienceRepository({
    RecommendationExperienceDatabase? database,
  }) : _database = database ?? RecommendationExperienceDatabase.instance;

  final RecommendationExperienceDatabase _database;

  Future<List<RecommendationMonthlyExperienceEvidence>> getAllEvidence() async {
    final rows = await _database.getAllEvidence();

    return rows
        .map(RecommendationMonthlyExperienceEvidence.fromMap)
        .toList(growable: false);
  }

  Future<List<RecommendationMonthlyExperienceEvidence>>
      getEvidenceByDestination(
    String destinationId,
  ) async {
    final rows = await _database.getEvidenceByDestination(
      destinationId,
    );

    return rows
        .map(RecommendationMonthlyExperienceEvidence.fromMap)
        .toList(growable: false);
  }

  Future<RecommendationMonthlyExperienceEvidence?>
      getEvidenceByDestinationAndMonth({
    required String destinationId,
    required String month,
  }) async {
    final row = await _database.getEvidenceByDestinationAndMonth(
      destinationId: destinationId,
      month: month,
    );

    if (row == null) {
      return null;
    }

    return RecommendationMonthlyExperienceEvidence.fromMap(row);
  }

  Future<List<RecommendationMonthlyExperienceEvidence>> getEvidenceByMonth(
    String month,
  ) async {
    final rows = await _database.getEvidenceByMonth(month);

    return rows
        .map(RecommendationMonthlyExperienceEvidence.fromMap)
        .toList(growable: false);
  }

  Future<int> getEvidenceCount() {
    return _database.getEvidenceCount();
  }

  Future<int> getDestinationCount() {
    return _database.getDestinationCount();
  }

  Future<void> close() {
    return _database.close();
  }
}
