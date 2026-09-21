// Centralized destination image URLs for TravelBuddy.
//
// Destination photographs are sourced from Wikimedia Commons.
// Check the individual Commons file pages for attribution and license
// requirements before publishing the application.

class DestinationImages {
  DestinationImages._();

  static const String _commonsRedirect =
      'https://commons.wikimedia.org/wiki/Special:Redirect/file/';

  // ===========================================================================
  // MANALI
  // ===========================================================================

  static const String manaliHero =
      '${_commonsRedirect}Manali%20%2C%20Himachal%20Pradesh.jpg';

  static const List<String> manaliGallery = [
    manaliHero,
    'https://upload.wikimedia.org/wikipedia/commons/0/04/View_in_Manali.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/a/a8/The_Himalayan_mountains_in_Manali%2C_Himachal_Pradesh.jpg',
  ];

  // ===========================================================================
  // GOA
  // ===========================================================================

  static const String goaHero = '${_commonsRedirect}Goa-sea-beach.jpg';

  static const List<String> goaGallery = [
    goaHero,
    '${_commonsRedirect}Goa%20beach%20--%20Anjuna%203.jpg',
    '${_commonsRedirect}Goa%20sandy%20beach.jpg',
  ];

  // ===========================================================================
  // JAIPUR
  // ===========================================================================

  static const String jaipurHero =
      '${_commonsRedirect}Jaipur%20Rajasthan%20India.JPG';

  static const List<String> jaipurGallery = [
    jaipurHero,
    '${_commonsRedirect}Jaipur%2C%20Rajasthan.jpg',
    jaipurHero,
  ];

  // ===========================================================================
  // RISHIKESH
  // ===========================================================================

  static const String rishikeshHero = '${_commonsRedirect}RISHIKESH.jpg';

  static const List<String> rishikeshGallery = [
    rishikeshHero,
    '${_commonsRedirect}Rishikesh%20Uttarakhand.jpg',
    '${_commonsRedirect}Rishikesh%2C%20Lakshman%20Jhula.jpg',
  ];

  // ===========================================================================
  // KERALA BACKWATERS
  // ===========================================================================

  static const String keralaBackwatersHero =
      '${_commonsRedirect}Kerala%20back%20waters.jpg';

  static const List<String> keralaBackwatersGallery = [
    keralaBackwatersHero,
    '${_commonsRedirect}Kerala%20backwater%20Aleppey.jpg',
    '${_commonsRedirect}The%20Backwaters%20of%20Alleppey.jpg',
  ];

  // ===========================================================================
  // RANTHAMBORE
  // ===========================================================================

  static const String ranthamboreHero =
      '${_commonsRedirect}Ranthambore%20National%20Park%201.jpg';

  static const List<String> ranthamboreGallery = [
    ranthamboreHero,
    '${_commonsRedirect}RANTHAMBORE%20NATIONAL%20PARK%2001.jpg',
    '${_commonsRedirect}Ranthambore%20National%20Park1.jpg',
  ];

  // ===========================================================================
  // VARANASI
  // ===========================================================================

  static const String varanasiHero =
      '${_commonsRedirect}Varanasi%2C%20India%2C%20Ganges%20River%2C%20ghats%2C%20temples%20and%20embankments.jpg';

  static const List<String> varanasiGallery = [
    varanasiHero,
    '${_commonsRedirect}View%20of%20the%20ghats%20at%20Varanasi.jpg',
    '${_commonsRedirect}Varanasi%20Ganga%20Ghat.jpg',
  ];

  // ===========================================================================
  // MUNNAR
  // ===========================================================================

  static const String munnarHero =
      '${_commonsRedirect}Tea%20plantation%20and%20road%20%2Cmunnar.jpg';

  static const List<String> munnarGallery = [
    munnarHero,
    '${_commonsRedirect}Tea%20plantation%20in%20Munnar.jpg',
    '${_commonsRedirect}Munnar%20tea%20plantation.jpg',
  ];

  // ===========================================================================
  // JAISALMER
  // ===========================================================================

  static const String jaisalmerHero = '${_commonsRedirect}JaisalmerFort.jpg';

  static const List<String> jaisalmerGallery = [
    jaisalmerHero,
    '${_commonsRedirect}Jaisalmer%20Fort%20with%20Jaisalmer%20city.jpg',
    '${_commonsRedirect}The%20Jaisalmer%20Fort.jpg',
  ];

  // ===========================================================================
  // GOKARNA
  // ===========================================================================

  static const String gokarnaHero = '${_commonsRedirect}Gokarna%20beach.jpg';

  static const List<String> gokarnaGallery = [
    gokarnaHero,
    '${_commonsRedirect}Kudle%20Beach%2C%20Gokarna.jpg',
    '${_commonsRedirect}Gokarna%20Main%20Beach.jpg',
  ];

  // ===========================================================================
  // GENERIC HERO LOOKUP
  // ===========================================================================

  static String hero(String destinationName) {
    switch (_normalize(destinationName)) {
      case 'manali':
        return manaliHero;

      case 'goa':
        return goaHero;

      case 'jaipur':
        return jaipurHero;

      case 'rishikesh':
        return rishikeshHero;

      case 'kerala backwaters':
        return keralaBackwatersHero;

      case 'ranthambore':
        return ranthamboreHero;

      case 'varanasi':
        return varanasiHero;

      case 'munnar':
        return munnarHero;

      case 'jaisalmer':
        return jaisalmerHero;

      case 'gokarna':
        return gokarnaHero;

      default:
        return manaliHero;
    }
  }

  // ===========================================================================
  // GENERIC GALLERY LOOKUP
  // ===========================================================================

  static List<String> gallery(String destinationName) {
    switch (_normalize(destinationName)) {
      case 'manali':
        return manaliGallery;

      case 'goa':
        return goaGallery;

      case 'jaipur':
        return jaipurGallery;

      case 'rishikesh':
        return rishikeshGallery;

      case 'kerala backwaters':
        return keralaBackwatersGallery;

      case 'ranthambore':
        return ranthamboreGallery;

      case 'varanasi':
        return varanasiGallery;

      case 'munnar':
        return munnarGallery;

      case 'jaisalmer':
        return jaisalmerGallery;

      case 'gokarna':
        return gokarnaGallery;

      default:
        return manaliGallery;
    }
  }

  // ===========================================================================
  // NORMALIZATION
  // ===========================================================================

  static String _normalize(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }
}
