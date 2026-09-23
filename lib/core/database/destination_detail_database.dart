import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DestinationDetailDatabase {
  DestinationDetailDatabase._();

  static final DestinationDetailDatabase instance =
      DestinationDetailDatabase._();

  static const String _assetDatabasePath =
      'assets/databases/travelbuddy_destination_details.db';

  static const String _databaseFileName =
      'travelbuddy_destination_details.db';

  static const String destinationDetailsTable =
      'destination_details';

  static const String nearbyAttractionsTable =
      'destination_nearby_attractions';

  static const String schemaInfoTable =
      'schema_info';

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

  Future<Map<String, dynamic>?> getDestinationMapById(
    String destinationId,
  ) async {
    final db = await database;

    final results = await db.query(
      destinationDetailsTable,
      where: 'destination_id = ?',
      whereArgs: [destinationId.trim()],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    return results.first;
  }

  Future<List<Map<String, dynamic>>> getNearbyAttractionMaps(
    String destinationId,
  ) async {
    final db = await database;

    return db.query(
      nearbyAttractionsTable,
      where: 'destination_id = ?',
      whereArgs: [destinationId.trim()],
      orderBy:
          'distance_to_destination_km ASC, attraction_name COLLATE NOCASE ASC',
    );
  }

  Future<int> getDestinationCount() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) AS count '
      'FROM $destinationDetailsTable',
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getNearbyAttractionCount() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) AS count '
      'FROM $nearbyAttractionsTable',
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
