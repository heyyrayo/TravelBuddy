import '../domain/destination_detail.dart';
import '../../../core/constants/destination_images.dart';

class DestinationDetailDemoData {
  static const manali = DestinationDetail(
    destinationId: 'manali',
    destinationName: 'Manali',
    stateOrRegion: 'Himachal Pradesh, India',
    heroImageReference: DestinationImages.manaliHero,
    galleryImageReferences: DestinationImages.manaliGallery,
    description: 'Nestled in the Kullu Valley of Himachal Pradesh, '
        'Manali is a high-altitude Himalayan resort town. '
        'Known for its breathtaking landscapes, adventure '
        'sports, and spiritual significance, it is a '
        'year-round destination loved by backpackers and '
        'luxury travelers alike.',
    attractions: [
      DestinationAttraction(
        name: 'Rohtang Pass',
        distanceLabel: '51 km',
      ),
      DestinationAttraction(
        name: 'Solang Valley',
        distanceLabel: '14 km',
      ),
      DestinationAttraction(
        name: 'Hadimba Temple',
        distanceLabel: '3 km',
      ),
      DestinationAttraction(
        name: 'Beas River',
        distanceLabel: '1 km',
      ),
      DestinationAttraction(
        name: 'Mall Road',
        distanceLabel: '0.5 km',
      ),
    ],
    localFood: [
      'Siddu',
      'Trout Fish',
      'Dham',
      'Babru',
      'Aktori',
    ],
    quickInfo: DestinationQuickInfo(
      weatherLabel: '12\u00B0C',
      travelPeriodLabel: 'Oct\u2013Jun',
      budgetLabel: '\u20B9\u20B9',
      durationLabel: '5\u20137 days',
    ),
  );
}
