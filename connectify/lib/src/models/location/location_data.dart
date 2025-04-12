class LocationData {
  final String road;
  final String district;
  final String county;
  final String state;
  final String isoCode;
  final String postcode;
  final String country;
  final String countryCode;

  LocationData({
    required this.road,
    required this.district,
    required this.county,
    required this.state,
    required this.isoCode,
    required this.postcode,
    required this.country,
    required this.countryCode,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      road: json['road'],
      district: json['district'],
      county: json['county'],
      state: json['state'],
      isoCode: json['ISO3166-2-lvl4'],
      postcode: json['postcode'],
      country: json['country'],
      countryCode: json['country_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'road': road,
      'district': district,
      'county': county,
      'state': state,
      'ISO3166-2-lvl4': isoCode,
      'postcode': postcode,
      'country': country,
      'country_code': countryCode,
    };
  }

  factory LocationData.empty() {
    return LocationData(
      road: '',
      district: '',
      county: '',
      state: '',
      isoCode: '',
      postcode: '',
      country: "Regional locale",
      countryCode: '',
    );
  }
}