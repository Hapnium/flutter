import 'location_data.dart';

/// {@template location_information}
/// Represents a detailed location object returned by a geocoding service
/// (such as OpenStreetMap's Nominatim or similar APIs).
///
/// This class contains high-level metadata about a place (e.g., coordinates, name,
/// classification, ranking) and includes structured address details through
/// a nested [LocationData] instance.
///
/// ---
///
/// ### 🔍 Fields Overview:
/// | Field          | Description                                                   | Example                         |
/// |----------------|---------------------------------------------------------------|----------------------------------|
/// | [placeId]      | Unique identifier of the place in the geolocation system      | `12345678`                      |
/// | [licence]      | API license string                                            | `"Data © OpenStreetMap"`        |
/// | [osmType]      | Type of OSM object (`node`, `way`, `relation`)               | `"node"`                        |
/// | [osmId]        | The unique OSM ID for the feature                            | `305558247`                     |
/// | [lat], [lon]   | Latitude and longitude of the location                        | `"37.7749"`, `"-122.4194"`      |
/// | [highwayClass] | General classification like `"highway"`, `"place"`, etc.     | `"residential"`                 |
/// | [type]         | More specific type of place or feature                        | `"city"`, `"neighbourhood"`     |
/// | [placeRank]    | Rank of the place in terms of search relevance               | `30`                            |
/// | [importance]   | Importance score used for ranking                            | `0.85`                          |
/// | [addressType]  | Type of location used to categorize the place                | `"city"`, `"village"`           |
/// | [name]         | Optional name of the location (e.g., "Golden Gate Park")     | `"Golden Gate Park"`            |
/// | [displayName]  | Readable full string of the location                         | `"San Francisco, CA, USA"`      |
/// | [address]      | Structured address data parsed from geocoder                 | see [LocationData]              |
/// | [boundingBox]  | Area boundary surrounding the feature                        | `["37.77", "37.78", ...]`       |
///
/// ---
/// 
/// {@endtemplate}
class LocationInformation {
  /// Unique ID of the place in the geolocation service.
  final int placeId;

  /// Copyright or license information associated with the API source.
  final String licence;

  /// The OpenStreetMap object type (`node`, `way`, or `relation`).
  final String osmType;

  /// Unique OSM identifier of the place.
  final int osmId;

  /// Latitude of the place in string format.
  final String lat;

  /// Longitude of the place in string format.
  final String lon;

  /// General classification of the geographic feature (e.g., `highway`, `place`).
  final String highwayClass;

  /// Specific feature type (e.g., `residential`, `city`, `neighbourhood`).
  final String type;

  /// Rank indicating how relevant or significant this place is in the database.
  final int placeRank;

  /// Relative importance score, used for prioritizing results.
  final double importance;

  /// High-level type of address (e.g., `"city"`, `"town"`).
  final String addressType;

  /// Optional name of the place (e.g., `"Union Square"`). May be null.
  final String? name;

  /// Fully formatted address string suitable for display.
  final String displayName;

  /// Parsed and structured address details (e.g., street, city, country).
  final LocationData address;

  /// Bounding box coordinates defining the geographical bounds of the location.
  final List<String> boundingBox;

  /// Constructs a complete [LocationInformation] object from individual values.
  /// 
  /// {@macro location_information}
  LocationInformation({
    required this.placeId,
    required this.licence,
    required this.osmType,
    required this.osmId,
    required this.lat,
    required this.lon,
    required this.highwayClass,
    required this.type,
    required this.placeRank,
    required this.importance,
    required this.addressType,
    this.name,
    required this.displayName,
    required this.address,
    required this.boundingBox,
  });

  /// Constructs a [LocationInformation] instance from a JSON object.
  ///
  /// Handles fallback values if fields are missing or null.
  /// 
  /// {@macro location_information}
  factory LocationInformation.fromJson(Map<String, dynamic> json) {
    return LocationInformation(
      placeId: json['place_id'] ?? 0,
      licence: json['licence'] ?? '',
      osmType: json['osm_type'] ?? '',
      osmId: json['osm_id'] ?? 0,
      lat: json['lat'] ?? '',
      lon: json['lon'] ?? '',
      highwayClass: json['class'] ?? '',
      type: json['type'] ?? '',
      placeRank: json['place_rank'] ?? 0,
      importance: json['importance']?.toDouble() ?? 0.0,
      addressType: json['addresstype'] ?? json['address_type'] ?? '',
      name: json['name'],
      displayName: json['display_name'] ?? '',
      address: LocationData.fromJson(json['address'] ?? {}),
      boundingBox: List<String>.from(json['boundingbox'] ?? json['bounding_box'] ?? []),
    );
  }

  /// Converts this [LocationInformation] instance into a JSON object.
  ///
  /// Useful for serialization or API payloads.
  /// 
  /// {@macro location_information}
  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'licence': licence,
      'osm_type': osmType,
      'osm_id': osmId,
      'lat': lat,
      'lon': lon,
      'class': highwayClass,
      'type': type,
      'place_rank': placeRank,
      'importance': importance,
      'address_type': addressType,
      'name': name,
      'display_name': displayName,
      'address': address.toJson(),
      'bounding_box': boundingBox,
    };
  }

  /// Returns a copy of this object with overridden values.
  ///
  /// Helpful for immutability or updating only some fields.
  /// 
  /// {@macro location_information}
  LocationInformation copyWith({
    int? placeId,
    String? licence,
    String? osmType,
    int? osmId,
    String? lat,
    String? lon,
    String? highwayClass,
    String? type,
    int? placeRank,
    double? importance,
    String? addressType,
    String? name,
    String? displayName,
    LocationData? address,
    List<String>? boundingBox,
  }) {
    return LocationInformation(
      placeId: placeId ?? this.placeId,
      licence: licence ?? this.licence,
      osmType: osmType ?? this.osmType,
      osmId: osmId ?? this.osmId,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      highwayClass: highwayClass ?? this.highwayClass,
      type: type ?? this.type,
      placeRank: placeRank ?? this.placeRank,
      importance: importance ?? this.importance,
      addressType: addressType ?? this.addressType,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      address: address ?? this.address,
      boundingBox: boundingBox ?? this.boundingBox,
    );
  }

  /// Returns a placeholder [LocationInformation] object with default values.
  ///
  /// Can be used as a safe fallback or initial state.
  /// 
  /// {@macro location_information}
  factory LocationInformation.empty() {
    return LocationInformation(
      placeId: 0,
      licence: '',
      osmType: '',
      osmId: 0,
      lat: '',
      lon: '',
      highwayClass: '',
      type: '',
      placeRank: 0,
      importance: 0.0,
      addressType: '',
      name: null,
      displayName: '',
      address: LocationData.empty(),
      boundingBox: [],
    );
  }

  /// Creates a basic [LocationInformation] object from latitude and longitude.
  ///
  /// Useful when only coordinates are available, and full geocoding is not performed.
  /// 
  /// {@macro location_information}
  factory LocationInformation.fromLatLng(double latitude, double longitude) {
    return LocationInformation(
      placeId: 0,
      licence: '',
      osmType: '',
      osmId: 0,
      lat: '$latitude',
      lon: '$longitude',
      highwayClass: '',
      type: '',
      placeRank: 0,
      importance: 0.0,
      addressType: '',
      name: null,
      displayName: "Residential Zone",
      address: LocationData.empty(),
      boundingBox: [],
    );
  }
}