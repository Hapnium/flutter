import 'location_data.dart';

class LocationInformation {
  final int placeId;
  final String licence;
  final String osmType;
  final int osmId;
  final String lat;
  final String lon;
  final String highwayClass;
  final String type;
  final int placeRank;
  final double importance;
  final String addressType;
  final String? name;
  final String displayName;
  final LocationData address;
  final List<String> boundingBox;

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
      importance: json['importance'] ?? 0.0,
      addressType: json['addresstype'] ?? json['address_type'] ?? '',
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? '',
      address: LocationData.fromJson(json['address'] ?? {}),
      boundingBox: List<String>.from(json['boundingbox'] ?? json['bounding_box'] ?? []),
    );
  }

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