class ItineraryItem {
  const ItineraryItem({
    required this.id,
    required this.tripId,
    required this.dayNumber,
    required this.title,
    required this.sortOrder,
    this.description,
    this.location,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String tripId;
  final int dayNumber;
  final String title;
  final String? description;
  final String? location;
  final String? category;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ItineraryItem.fromMap(Map<String, dynamic> map) {
    return ItineraryItem(
      id: _requiredString(map, 'id'),
      tripId: _requiredString(map, 'trip_id'),
      dayNumber: _requiredInt(map, 'day_number'),
      title: _requiredString(map, 'title'),
      description: _nullableString(map['description']),
      location: _nullableString(map['location']),
      category: _nullableString(map['category']),
      sortOrder: _requiredInt(map, 'sort_order'),
      createdAt: _nullableDateTime(map['created_at'], 'created_at'),
      updatedAt: _nullableDateTime(map['updated_at'], 'updated_at'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trip_id': tripId,
      'day_number': dayNumber,
      'title': title,
      'description': description,
      'location': location,
      'category': category,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ItineraryItem copyWith({
    String? id,
    String? tripId,
    int? dayNumber,
    String? title,
    String? description,
    String? location,
    String? category,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ItineraryItem(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      dayNumber: dayNumber ?? this.dayNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      category: category ?? this.category,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  void validate({
    bool requireId = true,
  }) {
    if (requireId && id.trim().isEmpty) {
      throw const FormatException('Itinerary item id must not be empty.');
    }

    if (tripId.trim().isEmpty) {
      throw const FormatException('Itinerary item tripId must not be empty.');
    }

    if (dayNumber < 1) {
      throw const FormatException(
          'Itinerary item dayNumber must be at least 1.');
    }

    if (title.trim().isEmpty) {
      throw const FormatException('Itinerary item title must not be empty.');
    }

    if (sortOrder < 0) {
      throw const FormatException(
          'Itinerary item sortOrder must not be negative.');
    }
  }

  static String _requiredString(
    Map<String, dynamic> map,
    String key,
  ) {
    final value = map[key];
    final text = value?.toString().trim();

    if (text == null || text.isEmpty) {
      throw FormatException('Itinerary item field "$key" is missing.');
    }

    return text;
  }

  static int _requiredInt(
    Map<String, dynamic> map,
    String key,
  ) {
    final value = map[key];

    if (value is int) {
      return value;
    }

    if (value is num && value == value.roundToDouble()) {
      return value.toInt();
    }

    final parsed = int.tryParse(value?.toString() ?? '');
    if (parsed == null) {
      throw FormatException('Itinerary item field "$key" is invalid.');
    }

    return parsed;
  }

  static String? _nullableString(dynamic value) {
    final text = value?.toString().trim();

    if (text == null || text.isEmpty) {
      return null;
    }

    return text;
  }

  static DateTime? _nullableDateTime(
    dynamic value,
    String key,
  ) {
    if (value == null) {
      return null;
    }

    final parsed = DateTime.tryParse(value.toString());
    if (parsed == null) {
      throw FormatException('Itinerary item field "$key" is invalid.');
    }

    return parsed;
  }
}
