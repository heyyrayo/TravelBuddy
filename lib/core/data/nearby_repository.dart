import 'package:geolocator/geolocator.dart';

import '../../models/nearby_place.dart';
import '../services/location_service.dart';
import '../services/nearby_places_service.dart';

class NearbyRepository {
  const NearbyRepository({
    this.locationService = const LocationService(),
    this.nearbyPlacesService,
  });

  final LocationService locationService;
  final NearbyPlacesService? nearbyPlacesService;

  Future<List<NearbyPlace>> getNearbyPlaces({
    double radiusMeters = 5000,
    String? category,
  }) async {
    final position = await locationService.getCurrentPosition();

    final service =
        nearbyPlacesService ?? NearbyPlacesService();

    try {
      return await service.getNearbyPlaces(
        latitude: position.latitude,
        longitude: position.longitude,
        radiusMeters: radiusMeters,
        category: category,
      );
    } finally {
      if (nearbyPlacesService == null) {
        service.dispose();
      }
    }
  }

  Future<Position> getCurrentPosition() {
    return locationService.getCurrentPosition();
  }
}
