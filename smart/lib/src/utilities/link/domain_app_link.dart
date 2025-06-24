/// {@template domain_app_link}
/// A class that holds the app links for different platforms (web, Android, and iOS).
///
/// This class is used to store the URLs for the web version, Android version,
/// and iOS version of the app, providing a convenient structure for managing
/// these links.
/// 
/// {@endtemplate}
class DomainAppLink {
  /// The URL for the web version of the app.
  ///
  /// This is a string representing the URL that points to the web version of the app.
  /// Example: "https://www.example.com"
  final String web;

  /// The URL for the Android version of the app.
  ///
  /// This is a string representing the URL that points to the Android version of the app.
  /// Example: "https://play.google.com/store/apps/details?id=com.example.app"
  final String android;

  /// The URL for the iOS version of the app.
  ///
  /// This is a string representing the URL that points to the iOS version of the app.
  /// Example: "https://apps.apple.com/us/app/example-app/id123456789"
  final String ios;

  /// Creates a new instance of [DomainAppLink] with the provided URLs for web, Android, and iOS.
  ///
  /// The constructor requires three named parameters:
  /// - [web]: The URL for the web version of the app.
  /// - [android]: The URL for the Android version of the app.
  /// - [ios]: The URL for the iOS version of the app.
  ///
  /// Example usage:
  /// ```dart
  /// DomainAppLink appLinks = DomainAppLink(
  ///   web: "https://www.example.com",
  ///   android: "https://play.google.com/store/apps/details?id=com.example.app",
  ///   ios: "https://apps.apple.com/us/app/example-app/id123456789"
  /// );
  /// ```
  /// 
  /// {@macro domain_app_link}
  DomainAppLink({required this.web, required this.android, required this.ios});
}