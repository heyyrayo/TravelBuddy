import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

import '../../models/nearby_place.dart';

class NearbyPlacesService {
  NearbyPlacesService({
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _endpoint =
      'https://overpass-api.de/api/interpreter';

  static const double _defaultRadiusMeters = 5000;

  Future<List<NearbyPlace>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    double radiusMeters = _defaultRadiusMeters,
    String? category,
  }) async {
    final query = _buildQuery(
      latitude: latitude,
      longitude: longitude,
      radiusMeters: radiusMeters,
      category: category,
    );

    final response = await _client.post(
      Uri.parse(_endpoint),
      headers: const {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'User-Agent': 'TravelBuddy/1.0 (Flutter travel application)',
        'Referer': 'https://travelbuddy.app',
      },
      body: {
        'data': query,
      },
    );

    if (response.statusCode != 200) {
      throw NearbyPlacesException(
        'Nearby places request failed with status '
        '${response.statusCode}.',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const NearbyPlacesException(
        'Nearby places API returned an invalid response.',
      );
    }

    final elements = decoded['elements'];

    if (elements is! List) {
      return const [];
    }

    final places = <NearbyPlace>[];

    for (final element in elements) {
      if (element is! Map) {
        continue;
      }

      final place = _parseElement(
        Map<String, dynamic>.from(element),
        userLatitude: latitude,
        userLongitude: longitude,
      );

      if (place != null) {
        places.add(place);
      }
    }

    places.sort(
      (a, b) => (a.distanceMeters ?? double.infinity)
          .compareTo(b.distanceMeters ?? double.infinity),
    );

    return places;
  }

  String _buildQuery({
    required double latitude,
    required double longitude,
    required double radiusMeters,
    String? category,
  }) {
    final safeRadius = radiusMeters.clamp(100.0, 50000.0).toDouble();

    final filterText = _categoryFilters(
      category,
      latitude: latitude,
      longitude: longitude,
      radius: safeRadius,
    );

    return '''
[out:json][timeout:25];
(
$filterText
);
out center tags;
''';
  }

  String _categoryFilters(
    String? category, {
    required double latitude,
    required double longitude,
    required double radius,
  }) {
    final area = 'around:${radius.toStringAsFixed(0)},'
        '${latitude.toString()},'
        '${longitude.toString()}';

    switch (category?.toLowerCase()) {
      case 'hospital':
        return _tagFilters(area, 'amenity', 'hospital');

      case 'police':
        return _tagFilters(area, 'amenity', 'police');

      case 'railway':
        return _tagFilters(area, 'railway', 'station');

      case 'bus':
        return _tagFilters(area, 'highway', 'bus_stop');

      case 'atm':
        return _tagFilters(area, 'amenity', 'atm');

      case 'restaurant':
        return _tagFilters(area, 'amenity', 'restaurant');

      case 'pharmacy':
        return _tagFilters(area, 'amenity', 'pharmacy');

      case 'shop':
        return '''
  node($area)["shop"];
  way($area)["shop"];
  relation($area)["shop"];
''';

      default:
        return '''
  node($area)["amenity"="hospital"];
  way($area)["amenity"="hospital"];
  relation($area)["amenity"="hospital"];

  node($area)["amenity"="police"];
  way($area)["amenity"="police"];
  relation($area)["amenity"="police"];

  node($area)["railway"="station"];
  way($area)["railway"="station"];
  relation($area)["railway"="station"];

  node($area)["highway"="bus_stop"];
  way($area)["highway"="bus_stop"];
  relation($area)["highway"="bus_stop"];

  node($area)["amenity"="atm"];
  way($area)["amenity"="atm"];
  relation($area)["amenity"="atm"];

  node($area)["amenity"="restaurant"];
  way($area)["amenity"="restaurant"];
  relation($area)["amenity"="restaurant"];

  node($area)["amenity"="pharmacy"];
  way($area)["amenity"="pharmacy"];
  relation($area)["amenity"="pharmacy"];

  node($area)["shop"];
  way($area)["shop"];
  relation($area)["shop"];
''';
    }
  }

  String _tagFilters(
    String area,
    String key,
    String value,
  ) {
    return '''
  node($area)["$key"="$value"];
  way($area)["$key"="$value"];
  relation($area)["$key"="$value"];
''';
  }

  NearbyPlace? _parseElement(
    Map<String, dynamic> element, {
    required double userLatitude,
    required double userLongitude,
  }) {
    final tags = element['tags'];

    if (tags is! Map) {
      return null;
    }

    final safeTags = Map<String, dynamic>.from(tags);

    final rawName = safeTags['name']?.toString().trim();

    if (rawName == null || rawName.isEmpty) {
      return null;
    }

    final name = rawName;

    final coordinates = _extractCoordinates(element);

    if (coordinates == null) {
      return null;
    }

    final placeLatitude = coordinates.$1;
    final placeLongitude = coordinates.$2;

    final category = _detectCategory(safeTags);

    final distanceMeters = _distanceInMeters(
      userLatitude,
      userLongitude,
      placeLatitude,
      placeLongitude,
    );

    return NearbyPlace(
      id: '${element['type'] ?? 'place'}:${element['id'] ?? ''}',
      name: name,
      category: category,
      latitude: placeLatitude,
      longitude: placeLongitude,
      address: _buildAddress(safeTags),
      distanceMeters: distanceMeters,
      phone: _firstTag(
        safeTags,
        const ['phone', 'contact:phone'],
      ),
      website: _firstTag(
        safeTags,
        const ['website', 'contact:website'],
      ),
      isOpen: null,
    );
  }

  (double, double)? _extractCoordinates(
    Map<String, dynamic> element,
  ) {
    final latitude = element['lat'];
    final longitude = element['lon'];

    if (latitude is num && longitude is num) {
      return (
        latitude.toDouble(),
        longitude.toDouble(),
      );
    }

    final center = element['center'];

    if (center is Map) {
      final centerLatitude = center['lat'];
      final centerLongitude = center['lon'];

      if (centerLatitude is num && centerLongitude is num) {
        return (
          centerLatitude.toDouble(),
          centerLongitude.toDouble(),
        );
      }
    }

    return null;
  }

  String _detectCategory(Map<String, dynamic> tags) {
    if (tags['amenity'] == 'hospital') {
      return 'Hospital';
    }

    if (tags['amenity'] == 'police') {
      return 'Police';
    }

    if (tags['railway'] == 'station') {
      return 'Railway';
    }

    if (tags['highway'] == 'bus_stop') {
      return 'Bus';
    }

    if (tags['amenity'] == 'atm') {
      return 'ATM';
    }

    if (tags['amenity'] == 'restaurant') {
      return 'Restaurant';
    }

    if (tags['amenity'] == 'pharmacy') {
      return 'Pharmacy';
    }

    if (tags['shop'] != null) {
      return 'Shop';
    }

    return 'Other';
  }

  String? _buildAddress(Map<String, dynamic> tags) {
    final parts = <String>[];

    for (final key in [
      'addr:housenumber',
      'addr:street',
      'addr:suburb',
      'addr:city',
      'addr:state',
      'addr:postcode',
    ]) {
      final value = tags[key]?.toString().trim();

      if (value != null && value.isNotEmpty) {
        parts.add(value);
      }
    }

    return parts.isEmpty ? null : parts.join(', ');
  }

  String? _firstTag(
    Map<String, dynamic> tags,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = tags[key]?.toString().trim();

      if (value != null && value.isNotEmpty) {
        return value;
      }
    }

    return null;
  }

  double _distanceInMeters(
    double latitude1,
    double longitude1,
    double latitude2,
    double longitude2,
  ) {
    const earthRadiusMeters = 6371000.0;

    final latitude1Radians = _toRadians(latitude1);
    final latitude2Radians = _toRadians(latitude2);
    final deltaLatitude =
        _toRadians(latitude2 - latitude1);
    final deltaLongitude =
        _toRadians(longitude2 - longitude1);

    final a =
        math.pow(math.sin(deltaLatitude / 2), 2) +
        math.cos(latitude1Radians) *
            math.cos(latitude2Radians) *
            math.pow(math.sin(deltaLongitude / 2), 2);

    final c =
        2 * math.atan2(
          math.sqrt(a),
          math.sqrt(1 - a),
        );

    return earthRadiusMeters * c;
  }

  double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  void dispose() {
    _client.close();
  }
}

class NearbyPlacesException implements Exception {
  const NearbyPlacesException(this.message);

  final String message;

  @override
  String toString() => message;
}
