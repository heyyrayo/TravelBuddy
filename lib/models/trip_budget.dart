class TripBudget {
  const TripBudget({
    required this.id,
    required this.tripId,
    required this.amountPaise,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
  });

  static const supportedCurrency = 'INR';

  final String id;
  final String tripId;
  final int amountPaise;
  final String currency;
  final DateTime createdAt;
  final DateTime updatedAt;

  double get amountRupees => amountPaise / 100;

  factory TripBudget.fromMap(Map<String, dynamic> map) {
    final budget = TripBudget(
      id: _requiredString(map, 'id'),
      tripId: _requiredString(map, 'trip_id'),
      amountPaise: _requiredInt(map, 'amount_paise'),
      currency: _requiredString(map, 'currency'),
      createdAt: _requiredDateTime(map, 'created_at'),
      updatedAt: _requiredDateTime(map, 'updated_at'),
    );

    budget.validate();
    return budget;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trip_id': tripId,
      'amount_paise': amountPaise,
      'currency': currency,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  TripBudget copyWith({
    String? id,
    String? tripId,
    int? amountPaise,
    String? currency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TripBudget(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      amountPaise: amountPaise ?? this.amountPaise,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  void validate({bool requireId = true}) {
    if (requireId && id.trim().isEmpty) {
      throw const FormatException('Budget id must not be empty.');
    }
    if (tripId.trim().isEmpty) {
      throw const FormatException('Budget tripId must not be empty.');
    }
    if (amountPaise < 0) {
      throw const FormatException('Budget amount must not be negative.');
    }
    if (currency != supportedCurrency) {
      throw const FormatException('Budget currency must be INR.');
    }
  }

  static String _requiredString(Map<String, dynamic> map, String key) {
    final value = map[key]?.toString().trim();
    if (value == null || value.isEmpty) {
      throw FormatException('Budget field "$key" is missing.');
    }
    return value;
  }

  static int _requiredInt(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is int) {
      return value;
    }
    if (value is num && value == value.roundToDouble()) {
      return value.toInt();
    }
    final parsed = int.tryParse(value?.toString() ?? '');
    if (parsed == null) {
      throw FormatException('Budget field "$key" is invalid.');
    }
    return parsed;
  }

  static DateTime _requiredDateTime(Map<String, dynamic> map, String key) {
    final value = DateTime.tryParse(map[key]?.toString() ?? '');
    if (value == null) {
      throw FormatException('Budget field "$key" is invalid.');
    }
    return value;
  }
}
