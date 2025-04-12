import 'package:hapnium/hapnium.dart';


/// A class representing the user's consent state for various types of cookies.
///
/// This class is used to store and manage the user's preferences regarding
/// different types of cookies (essential, advertising, analytics) and their
/// rejection status. The class provides methods to create, update, and serialize
/// these preferences.
class CookieConsent {
  /// A boolean flag indicating if the essential cookies are granted.
  ///
  /// Essential cookies are necessary for the basic functionality of the website.
  final Boolean isEssential;

  /// A boolean flag indicating if the advertising cookies are granted.
  ///
  /// Advertising cookies are used to deliver personalized advertisements.
  final Boolean isAdvertising;

  /// A boolean flag indicating if the analytics cookies are granted.
  ///
  /// Analytics cookies are used to collect data on user behavior to improve
  /// website performance.
  final Boolean isAnalytics;

  /// A boolean flag indicating if the user has rejected all cookies.
  ///
  /// If set to `true`, the user has rejected cookies; otherwise, it is `false`.
  final Boolean isRejected;

  /// Creates a [CookieConsent] instance with the given cookie consent states.
  ///
  /// [isEssential] indicates if the essential cookies are granted.
  /// [isAdvertising] indicates if the advertising cookies are granted.
  /// [isAnalytics] indicates if the analytics cookies are granted.
  /// [isRejected] indicates if the user has rejected all cookies.
  CookieConsent({
    required this.isEssential,
    required this.isAdvertising,
    required this.isAnalytics,
    required this.isRejected
  });

  /// Creates a [CookieConsent] instance from a JSON map.
  ///
  /// This factory method extracts the necessary fields from a [json] map
  /// and creates a [CookieConsent] object. If any of the fields are missing,
  /// they are assigned a default value of `false`.
  factory CookieConsent.fromJson(JsonMap json) {
    return CookieConsent(
      isEssential: json["is_essential_granted"] ?? false,
      isAdvertising: json["is_advertising_granted"] ?? false,
      isAnalytics: json["is_analytics_granted"] ?? false,
      isRejected: json["is_rejected"] ?? false,
    );
  }

  /// Returns a new [CookieConsent] instance with updated values.
  ///
  /// This method allows for creating a copy of the current [CookieConsent] instance
  /// with optional changes. If no values are provided for any of the fields,
  /// the current values are retained.
  CookieConsent copyWith({
    Boolean? isEssential,
    Boolean? isAdvertising,
    Boolean? isAnalytics,
    Boolean? isRejected
  }) {
    return CookieConsent(
      isEssential: isEssential ?? this.isEssential,
      isAdvertising: isAdvertising ?? this.isAdvertising,
      isAnalytics: isAnalytics ?? this.isAnalytics,
      isRejected: isRejected ?? this.isRejected
    );
  }

  /// Converts the current [CookieConsent] instance to a JSON map.
  ///
  /// This method serializes the cookie consent states into a map that can be
  /// used for network requests or storage. The keys in the map correspond to
  /// cookie consent types and rejection status.
  JsonMap toJson() {
    return {
      "is_essential_granted": isEssential,
      "is_advertising_granted": isAdvertising,
      "is_analytics_granted": isAnalytics,
      "is_rejected": isRejected
    };
  }

  /// Creates an empty [CookieConsent] instance with all fields set to `false`.
  ///
  /// This method returns a default [CookieConsent] object where all consent flags
  /// are set to `false`, indicating no consent has been granted.
  factory CookieConsent.empty() => CookieConsent(isEssential: false, isAdvertising: false, isAnalytics: false, isRejected: false);
}