/// {@template location_data}
/// A structured model representing detailed geographical location data.
///
/// This class is typically used to encapsulate address-level information retrieved
/// from a geolocation API (such as Nominatim or Google Places). It supports serialization
/// to/from JSON for easy API integration.
///
/// ---
///
/// ### 📍 Fields Breakdown:
/// - [road] — The street or road name.
/// - [amenity] — A notable place nearby (e.g., hospital, café, school).
/// - [county] — Administrative county or district name.
/// - [state] — State or region (e.g., California, Bavaria).
/// - [isoCode] — ISO 3166-2 subdivision code (e.g., `US-CA`).
/// - [postcode] — Postal or ZIP code.
/// - [country] — Full country name (e.g., "United States").
/// - [countryCode] — 2-letter ISO country code (e.g., "us").
/// - [houseNumber] — Street number or house number.
/// - [borough] — Borough or sub-district (mostly urban areas).
/// - [city] — City or town name.
/// - [iso31662Lvl4] — Redundant field for ISO 3166-2 level 4 code.
///
/// ---
///
/// ### 🏗️ Usage Example:
///
/// ```dart
/// final location = LocationData.fromJson(apiResponse['address']);
/// print('${location.city}, ${location.state}, ${location.country}');
/// ```
///
/// {@endtemplate}
class LocationData {
  /// Street or road name (e.g., "Main Street").
  final String road;

  /// Nearby amenity or landmark (e.g., "Starbucks").
  final String amenity;

  /// The county or district name (e.g., "Los Angeles County").
  final String county;

  /// State or region name (e.g., "California").
  final String state;

  /// ISO 3166-2 code for the location’s subdivision (e.g., "US-CA").
  final String isoCode;

  /// Postal or ZIP code (e.g., "94107").
  final String postcode;

  /// Full country name (e.g., "United States").
  final String country;

  /// Two-letter ISO 3166-1 alpha-2 country code (e.g., "us").
  final String countryCode;

  /// House or street number (e.g., "123").
  final String houseNumber;

  /// Borough or neighborhood within a city (e.g., "Brooklyn").
  final String borough;

  /// City or municipality name (e.g., "San Francisco").
  final String city;

  /// ISO 3166-2 level 4 subdivision code (sometimes redundant with [isoCode]).
  final String iso31662Lvl4;

  /// Creates an instance of [LocationData] from individual address components.
  /// 
  /// {@macro location_data}
  LocationData({
    required this.road,
    required this.amenity,
    required this.county,
    required this.state,
    required this.isoCode,
    required this.postcode,
    required this.country,
    required this.countryCode,
    required this.houseNumber,
    required this.borough,
    required this.city,
    required this.iso31662Lvl4,
  });

  /// Creates an instance of [LocationData] from a JSON map.
  ///
  /// Typically used when parsing API responses.
  /// 
  /// {@macro location_data}
  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      road: json['road'] ?? '',
      amenity: json['amenity'] ?? '',
      county: json['county'] ?? '',
      state: json['state'] ?? '',
      isoCode: json['ISO3166-2-lvl4'] ?? '',
      postcode: json['postcode'] ?? '',
      country: json['country'] ?? '',
      countryCode: json['country_code'] ?? '',
      houseNumber: json['house_number'] ?? '',
      borough: json['borough'] ?? '',
      city: json['city'] ?? '',
      iso31662Lvl4: json['ISO3166-2-lvl4'] ?? '',
    );
  }

  /// Converts the [LocationData] instance into a JSON map.
  ///
  /// Useful for sending location data in API requests or storing locally.
  /// 
  /// {@macro location_data}
  Map<String, dynamic> toJson() {
    return {
      'road': road,
      'amenity': amenity,
      'county': county,
      'state': state,
      'postcode': postcode,
      'country': country,
      'country_code': countryCode,
      'house_number': houseNumber,
      'borough': borough,
      'city': city,
      'ISO3166-2-lvl4': iso31662Lvl4,
    };
  }

  /// Returns a blank or default [LocationData] instance.
  ///
  /// Can be used as a fallback when no location information is available.
  /// 
  /// {@macro location_data}
  factory LocationData.empty() {
    return LocationData(
      road: '',
      amenity: '',
      county: '',
      state: '',
      isoCode: '',
      postcode: '',
      country: "Regional locale",
      countryCode: '',
      houseNumber: '',
      borough: '',
      city: '',
      iso31662Lvl4: '',
    );
  }
}