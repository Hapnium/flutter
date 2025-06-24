/// Redirect information.
/// 
/// This class is used to store the redirect information.
abstract interface class RedirectInfo {
  /// Returns the status code used for the redirect.
  /// 
  /// This property returns the status code used for the redirect.
  int get statusCode;

  /// Returns the method used for the redirect.
  /// 
  /// This property returns the method used for the redirect.
  String get method;

  /// Returns the location for the redirect.
  /// 
  /// This property returns the location for the redirect.
  Uri get location;
}