class LocationData {
  final String road;
  final String amenity;
  final String county;
  final String state;
  final String isoCode;
  final String postcode;
  final String country;
  final String countryCode;
  final String houseNumber;
  final String borough;
  final String city;
  final String iso31662Lvl4;

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