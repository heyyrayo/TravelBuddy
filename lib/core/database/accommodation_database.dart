import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/accommodation.dart';

class AccommodationDatabase {
  AccommodationDatabase._();

  static final AccommodationDatabase instance = AccommodationDatabase._();

  static const String _assetDatabasePath =
      'assets/databases/nidhi_accommodation.db';

  static const String _databaseFileName = 'nidhi_accommodation.db';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final databasePath =
        path.join(documentsDirectory.path, _databaseFileName);

    final databaseFile = File(databasePath);

    if (!await databaseFile.exists()) {
      final databaseData = await rootBundle.load(_assetDatabasePath);
      final databaseBytes = databaseData.buffer.asUint8List(
        databaseData.offsetInBytes,
        databaseData.lengthInBytes,
      );

      await databaseFile.writeAsBytes(databaseBytes, flush: true);
    }

    return openDatabase(
      databasePath,
      readOnly: true,
    );
  }

  Future<List<Map<String, dynamic>>> getAllAccommodationMaps({
    int? limit,
    int? offset,
  }) async {
    final db = await database;

    return db.query(
      'accommodations',
      orderBy: 'display_name COLLATE NOCASE ASC',
      limit: limit,
      offset: offset,
    );
  }

  Future<List<Accommodation>> getAllAccommodations({
    int? limit,
    int? offset,
  }) async {
    final maps = await getAllAccommodationMaps(
      limit: limit,
      offset: offset,
    );

    return maps.map(Accommodation.fromMap).toList();
  }

  Future<List<Map<String, dynamic>>> searchAccommodationMaps({
    String searchQuery = '',
    String? state,
    String? accommodationType,
    int? limit,
    int? offset,
  }) async {
    final db = await database;

    final conditions = <String>[];
    final arguments = <dynamic>[];

    final trimmedQuery = searchQuery.trim();

    if (trimmedQuery.isNotEmpty) {
      conditions.add('''
        (
          display_name LIKE ?
          OR address LIKE ?
          OR state_normalized LIKE ?
          OR accommodation_type LIKE ?
        )
      ''');

      final searchPattern = '%$trimmedQuery%';

      arguments.addAll([
        searchPattern,
        searchPattern,
        searchPattern,
        searchPattern,
      ]);
    }

    if (state != null && state.trim().isNotEmpty) {
      conditions.add('state_normalized = ?');
      arguments.add(state.trim());
    }

    if (accommodationType != null &&
        accommodationType.trim().isNotEmpty) {
      conditions.add('accommodation_type = ?');
      arguments.add(accommodationType.trim());
    }

    final whereClause =
        conditions.isEmpty ? null : conditions.join(' AND ');

    return db.query(
      'accommodations',
      where: whereClause,
      whereArgs: arguments.isEmpty ? null : arguments,
      orderBy: 'display_name COLLATE NOCASE ASC',
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
  }) async {
    final maps = await searchAccommodationMaps(
      searchQuery: searchQuery,
      state: state,
      accommodationType: accommodationType,
      limit: limit,
      offset: offset,
    );

    return maps.map(Accommodation.fromMap).toList();
  }

  Future<Map<String, dynamic>?> getAccommodationMapById(
    String recordId,
  ) async {
    final db = await database;

    final results = await db.query(
      'accommodations',
      where: 'record_id = ?',
      whereArgs: [recordId],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    return results.first;
  }

  Future<Accommodation?> getAccommodationById(
    String recordId,
  ) async {
    final map = await getAccommodationMapById(recordId);

    if (map == null) {
      return null;
    }

    return Accommodation.fromMap(map);
  }

  Future<List<String>> getStates() async {
    final db = await database;

    final results = await db.rawQuery('''
      SELECT DISTINCT state_normalized
      FROM accommodations
      WHERE state_normalized IS NOT NULL
        AND TRIM(state_normalized) != ''
      ORDER BY state_normalized COLLATE NOCASE ASC
    ''');

    return results
        .map((row) => row['state_normalized'] as String)
        .toList();
  }

  Future<List<String>> getAccommodationTypes() async {
    final db = await database;

    final results = await db.rawQuery('''
      SELECT DISTINCT accommodation_type
      FROM accommodations
      WHERE accommodation_type IS NOT NULL
        AND TRIM(accommodation_type) != ''
      ORDER BY accommodation_type COLLATE NOCASE ASC
    ''');

    return results
        .map((row) => row['accommodation_type'] as String)
        .toList();
  }

  Future<int> getAccommodationCount({
    String searchQuery = '',
    String? state,
    String? accommodationType,
  }) async {
    final db = await database;

    final conditions = <String>[];
    final arguments = <dynamic>[];

    final trimmedQuery = searchQuery.trim();

    if (trimmedQuery.isNotEmpty) {
      conditions.add('''
        (
          display_name LIKE ?
          OR address LIKE ?
          OR state_normalized LIKE ?
          OR accommodation_type LIKE ?
        )
      ''');

      final searchPattern = '%$trimmedQuery%';

      arguments.addAll([
        searchPattern,
        searchPattern,
        searchPattern,
        searchPattern,
      ]);
    }

    if (state != null && state.trim().isNotEmpty) {
      conditions.add('state_normalized = ?');
      arguments.add(state.trim());
    }

    if (accommodationType != null &&
        accommodationType.trim().isNotEmpty) {
      conditions.add('accommodation_type = ?');
      arguments.add(accommodationType.trim());
    }

    final whereClause =
        conditions.isEmpty ? null : conditions.join(' AND ');

    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) AS total
      FROM accommodations
      ${whereClause == null ? '' : 'WHERE $whereClause'}
      ''',
      arguments,
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
