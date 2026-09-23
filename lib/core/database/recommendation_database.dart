import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class RecommendationDatabase {
  RecommendationDatabase._();

  static final RecommendationDatabase instance =
      RecommendationDatabase._();

  static const String _assetDatabasePath =
      'assets/databases/travelbuddy_recommendations.db';

  static const String _databaseFileName =
      'travelbuddy_recommendations.db';

  static const String tableName =
      'recommendation_monthly_features';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final documentsDirectory =
        await getApplicationDocumentsDirectory();

    final databasePath =
        path.join(documentsDirectory.path, _databaseFileName);

    final databaseFile = File(databasePath);

    if (!await databaseFile.exists()) {
      final databaseData =
          await rootBundle.load(_assetDatabasePath);

      final databaseBytes = databaseData.buffer.asUint8List(
        databaseData.offsetInBytes,
        databaseData.lengthInBytes,
      );

      await databaseFile.writeAsBytes(
        databaseBytes,
        flush: true,
      );
    }

    return openDatabase(
      databasePath,
      readOnly: true,
    );
  }

  Future<List<Map<String, dynamic>>> getAllFeatures() async {
    final db = await database;

    return db.query(
      tableName,
      orderBy: 'destination_id ASC, month ASC',
    );
  }

  Future<List<Map<String, dynamic>>> getFeaturesByDestination(
    String destinationId,
  ) async {
    final db = await database;

    return db.query(
      tableName,
      where: 'destination_id = ?',
      whereArgs: [destinationId.trim()],
      orderBy: 'month ASC',
    );
  }

  Future<Map<String, dynamic>?> getFeaturesByDestinationAndMonth({
    required String destinationId,
    required String month,
  }) async {
    final db = await database;

    final rows = await db.query(
      tableName,
      where: 'destination_id = ? AND month = ?',
      whereArgs: [
        destinationId.trim(),
        month.trim(),
      ],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return rows.first;
  }

  Future<List<Map<String, dynamic>>> getFeaturesByMonth(
    String month,
  ) async {
    final db = await database;

    return db.query(
      tableName,
      where: 'month = ?',
      whereArgs: [month.trim()],
      orderBy: 'destination_id ASC',
    );
  }

  Future<int> getFeatureCount() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM $tableName',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getDestinationCount() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(DISTINCT destination_id) AS count '
      'FROM $tableName',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
