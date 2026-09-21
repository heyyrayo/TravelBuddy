class DestinationDetail {
  const DestinationDetail({
    required this.destinationId,
    required this.destinationName,
    this.stateOrRegion,
    this.latitude,
    this.longitude,
    this.description,
    this.heroImageReference,
    this.galleryImageReferences = const [],
    this.attractions = const [],
    this.localFood = const [],
    this.quickInfo,
  });

  final String destinationId;
  final String destinationName;

  final String? stateOrRegion;
  final double? latitude;
  final double? longitude;

  final String? description;

  final String? heroImageReference;
  final List<String> galleryImageReferences;

  final List<DestinationAttraction> attractions;
  final List<String> localFood;

  final DestinationQuickInfo? quickInfo;

  void validate() {
    if (destinationId.trim().isEmpty) {
      throw const FormatException(
        'DestinationDetail.destinationId cannot be empty.',
      );
    }

    if (destinationName.trim().isEmpty) {
      throw const FormatException(
        'DestinationDetail.destinationName cannot be empty.',
      );
    }

    if (latitude != null && (latitude! < -90 || latitude! > 90)) {
      throw const FormatException(
        'DestinationDetail.latitude must be between -90 and 90.',
      );
    }

    if (longitude != null && (longitude! < -180 || longitude! > 180)) {
      throw const FormatException(
        'DestinationDetail.longitude must be between -180 and 180.',
      );
    }

    for (final attraction in attractions) {
      attraction.validate();
    }

    quickInfo?.validate();
  }
}

class DestinationAttraction {
  const DestinationAttraction({
    required this.name,
    this.distanceLabel,
  });

  final String name;
  final String? distanceLabel;

  void validate() {
    if (name.trim().isEmpty) {
      throw const FormatException(
        'DestinationAttraction.name cannot be empty.',
      );
    }
  }
}

class DestinationQuickInfo {
  const DestinationQuickInfo({
    this.weatherLabel,
    this.travelPeriodLabel,
    this.budgetLabel,
    this.durationLabel,
  });

  final String? weatherLabel;
  final String? travelPeriodLabel;
  final String? budgetLabel;
  final String? durationLabel;

  void validate() {
    // Quick-info fields are optional because the application must not
    // fabricate unsupported destination facts.
  }
}
