class Expense {
  const Expense({
    required this.id,
    required this.tripId,
    required this.title,
    required this.amountPaise,
    required this.currency,
    required this.category,
    required this.note,
    required this.spentAt,
    required this.createdAt,
    required this.updatedAt,
  });

  static const supportedCurrency = 'INR';
  static const categories = [
    'Accommodation',
    'Transport',
    'Food',
    'Activities',
    'Shopping',
    'Other',
  ];

  final String id;
  final String tripId;
  final String title;
  final int amountPaise;
  final String currency;
  final String category;
  final String? note;
  final DateTime spentAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  double get amountRupees => amountPaise / 100;

  factory Expense.fromMap(Map<String, dynamic> map) {
    final expense = Expense(
      id: _requiredString(map, 'id'),
      tripId: _requiredString(map, 'trip_id'),
      title: _requiredString(map, 'title'),
      amountPaise: _requiredInt(map, 'amount_paise'),
      currency: _requiredString(map, 'currency'),
      category: _requiredString(map, 'category'),
      note: _nullableString(map['note']),
      spentAt: _requiredDateTime(map, 'spent_at'),
      createdAt: _requiredDateTime(map, 'created_at'),
      updatedAt: _requiredDateTime(map, 'updated_at'),
    );

    expense.validate();
    return expense;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trip_id': tripId,
      'title': title,
      'amount_paise': amountPaise,
      'currency': currency,
      'category': category,
      'note': note,
      'spent_at': spentAt.toUtc().toIso8601String(),
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  Expense copyWith({
    String? id,
    String? tripId,
    String? title,
    int? amountPaise,
    String? currency,
    String? category,
    String? note,
    DateTime? spentAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      title: title ?? this.title,
      amountPaise: amountPaise ?? this.amountPaise,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      note: note ?? this.note,
      spentAt: spentAt ?? this.spentAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  void validate({bool requireId = true}) {
    if (requireId && id.trim().isEmpty) {
      throw const FormatException('Expense id must not be empty.');
    }
    if (tripId.trim().isEmpty) {
      throw const FormatException('Expense tripId must not be empty.');
    }
    if (title.trim().isEmpty) {
      throw const FormatException('Expense title must not be empty.');
    }
    if (amountPaise <= 0) {
      throw const FormatException('Expense amount must be greater than zero.');
    }
    if (currency != supportedCurrency) {
      throw const FormatException('Expense currency must be INR.');
    }
    if (!categories.contains(category)) {
      throw const FormatException('Expense category is not supported.');
    }
  }

  static String _requiredString(Map<String, dynamic> map, String key) {
    final value = map[key]?.toString().trim();
    if (value == null || value.isEmpty) {
      throw FormatException('Expense field "$key" is missing.');
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
      throw FormatException('Expense field "$key" is invalid.');
    }
    return parsed;
  }

  static DateTime _requiredDateTime(Map<String, dynamic> map, String key) {
    final value = DateTime.tryParse(map[key]?.toString() ?? '');
    if (value == null) {
      throw FormatException('Expense field "$key" is invalid.');
    }
    return value;
  }

  static String? _nullableString(dynamic value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }
}
