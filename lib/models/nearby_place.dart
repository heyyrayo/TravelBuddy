class NearbyPlace {
  const NearbyPlace({
    required this.id,
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    this.address,
    this.distanceMeters,
    this.phone,
    this.website,
    this.isOpen,
  });

  final String id;
  final String name;
  final String category;
  final double latitude;
  final double longitude;
  final String? address;
  final double? distanceMeters;
  final String? phone;
  final String? website;
  final bool? isOpen;

  String get distanceLabel {
    final distance = distanceMeters;

    if (distance == null) {
      return 'Distance unavailable';
    }

    if (distance < 1000) {
      return '${distance.round()} m';
    }

    return '${(distance / 1000).toStringAsFixed(1)} km';
  }

  factory NearbyPlace.fromMap(Map<String, dynamic> map) {
    return NearbyPlace(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'Unnamed place',
      category: map['category']?.toString() ?? 'Other',
      latitude: _toDouble(map['latitude']),
      longitude: _toDouble(map['longitude']),
      address: _nullableString(map['address']),
      distanceMeters: _nullableDouble(map['distanceMeters']),
      phone: _nullableString(map['phone']),
      website: _nullableString(map['website']),
      isOpen: map['isOpen'] is bool ? map['isOpen'] as bool : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'distanceMeters': distanceMeters,
      'phone': phone,
      'website': website,
      'isOpen': isOpen,
    };
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double? _nullableDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '');
  }

  static String? _nullableString(dynamic value) {
    final text = value?.toString().trim();

    if (text == null || text.isEmpty) {
      return null;
    }

    return text;
  }
}
