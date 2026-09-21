class Accommodation {
  final String recordId;
  final String displayName;
  final String accommodationType;
  final String address;
  final String stateNormalized;
  final String pincode;
  final String pincodeStatus;
  final bool isTypeKnown;
  final bool isPincodeKnown;

  const Accommodation({
    required this.recordId,
    required this.displayName,
    required this.accommodationType,
    required this.address,
    required this.stateNormalized,
    required this.pincode,
    required this.pincodeStatus,
    required this.isTypeKnown,
    required this.isPincodeKnown,
  });

  factory Accommodation.fromMap(Map<String, dynamic> map) {
    return Accommodation(
      recordId: map['record_id'] as String? ?? '',
      displayName: map['display_name'] as String? ?? '',
      accommodationType: map['accommodation_type'] as String? ?? '',
      address: map['address'] as String? ?? '',
      stateNormalized: map['state_normalized'] as String? ?? '',
      pincode: map['pincode'] as String? ?? '',
      pincodeStatus: map['pincode_status'] as String? ?? '',
      isTypeKnown: _parseBoolean(map['is_type_known']),
      isPincodeKnown: _parseBoolean(map['is_pincode_known']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'record_id': recordId,
      'display_name': displayName,
      'accommodation_type': accommodationType,
      'address': address,
      'state_normalized': stateNormalized,
      'pincode': pincode,
      'pincode_status': pincodeStatus,
      'is_type_known': isTypeKnown ? 1 : 0,
      'is_pincode_known': isPincodeKnown ? 1 : 0,
    };
  }

  static bool _parseBoolean(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is int) {
      return value == 1;
    }

    if (value is String) {
      return value == '1' || value.toLowerCase() == 'true';
    }

    return false;
  }

  String get locationLabel {
    if (stateNormalized.isEmpty) {
      return address;
    }

    return stateNormalized;
  }

  String get typeLabel {
    if (accommodationType.trim().isEmpty) {
      return 'Unspecified';
    }

    return accommodationType;
  }

  String get pincodeLabel {
    if (!isPincodeKnown || pincode.trim().isEmpty) {
      return 'PIN code unavailable';
    }

    return pincode;
  }
}
