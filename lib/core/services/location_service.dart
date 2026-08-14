import 'package:geolocator/geolocator.dart';

class LocationService {
  const LocationService();

  /// Returns the user's current position.
  ///
  /// Handles:
  /// - Location service disabled
  /// - Permission denied
  /// - Permission denied forever
  /// - Current GPS position
  Future<Position> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw const LocationServiceException(
        LocationServiceError.serviceDisabled,
        'Location services are disabled. Please enable location services and try again.',
      );
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationServiceException(
        LocationServiceError.permissionDenied,
        'Location permission was denied.',
      );
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(
        LocationServiceError.permissionDeniedForever,
        'Location permission is permanently denied. Please enable it from App Settings.',
      );
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } on LocationServiceException {
      rethrow;
    } catch (error) {
      throw LocationServiceException(
        LocationServiceError.unavailable,
        'Unable to determine your current location.',
        cause: error,
      );
    }
  }

  /// Opens the device's location settings.
  Future<bool> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }

  /// Opens the application's settings page.
  Future<bool> openAppSettings() {
    return Geolocator.openAppSettings();
  }
}

enum LocationServiceError {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  unavailable,
}

class LocationServiceException implements Exception {
  const LocationServiceException(
    this.error,
    this.message, {
    this.cause,
  });

  final LocationServiceError error;
  final String message;
  final Object? cause;

  @override
  String toString() => message;
}
