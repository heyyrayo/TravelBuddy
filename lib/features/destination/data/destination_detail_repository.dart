import '../../../core/database/destination_detail_database.dart';
import '../domain/destination_detail.dart';

class DestinationDetailRepository {
  DestinationDetailRepository({
    DestinationDetailDatabase? database,
  }) : _database = database ?? DestinationDetailDatabase.instance;

  final DestinationDetailDatabase _database;

  Future<DestinationDetail?> getById(
    String destinationId,
  ) async {
    final normalizedId = destinationId.trim();

    if (normalizedId.isEmpty) {
      return null;
    }

    final destinationMap =
        await _database.getDestinationMapById(normalizedId);

    if (destinationMap == null) {
      return null;
    }

    final attractionMaps =
        await _database.getNearbyAttractionMaps(normalizedId);

    final detail = DestinationDetail(
      destinationId: _requiredString(
        destinationMap['destination_id'],
      ),
      destinationName: _requiredString(
        destinationMap['destination_name'],
      ),
      stateOrRegion: _optionalString(
        destinationMap['state_or_region'],
      ),
      latitude: _optionalDouble(
        destinationMap['latitude'],
      ),
      longitude: _optionalDouble(
        destinationMap['longitude'],
      ),
      attractions: attractionMaps
          .map(_mapAttraction)
          .toList(growable: false),
    );

    detail.validate();
    return detail;
  }

  Future<int> getDestinationCount() {
    return _database.getDestinationCount();
  }

  Future<int> getNearbyAttractionCount() {
    return _database.getNearbyAttractionCount();
  }

  Future<void> close() {
    return _database.close();
  }

  DestinationAttraction _mapAttraction(
    Map<String, dynamic> map,
  ) {
    final distance =
        _optionalDouble(map['distance_to_destination_km']);

    return DestinationAttraction(
      name: _requiredString(map['attraction_name']),
      distanceLabel: distance == null
          ? null
          : '${_formatDistance(distance)} km',
    );
  }

  static String _requiredString(dynamic value) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }

    throw const FormatException(
      'Required destination detail string field is missing.',
    );
  }

  static String? _optionalString(dynamic value) {
    if (value == null) {
      return null;
    }

    final normalized = value.toString().trim();

    if (normalized.isEmpty) {
      return null;
    }

    return normalized;
  }

  static double? _optionalDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString().trim());
  }

  static String _formatDistance(double distanceKm) {
    if (distanceKm == distanceKm.roundToDouble()) {
      return distanceKm.toStringAsFixed(0);
    }

    if (distanceKm < 10) {
      return distanceKm.toStringAsFixed(1);
    }

    return distanceKm.toStringAsFixed(0);
  }
}
