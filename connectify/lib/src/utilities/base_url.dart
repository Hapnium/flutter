// ignore_for_file: non_constant_identifier_names

/// The [BaseUrl] class contains static constants that represent the base URLs 
/// for different environments and core within the Hapnium service ecosystem.
/// 
/// This class provides easy access to base URLs for production and sandbox 
/// environments for both the main Hapnium API and the Hapnium Portal API.
///
/// ### URLs:
/// 
/// - **PRODUCTION**: The base URL for the production environment of the Hapnium service API.
/// - **SANDBOX**: The base URL for the sandbox environment of the Hapnium service API (used for testing).
/// - **PORTAL_PRODUCTION**: The base URL for the production environment of the Hapnium Portal API.
/// - **PORTAL_SANDBOX**: The base URL for the sandbox environment of the Hapnium Portal API (used for testing).
///
/// #### Usage:
/// To get the production URL for the Hapnium service API, you would use:
/// 
/// ```dart
/// String prodUrl = BaseUrl.PRODUCTION;
/// ```
///
/// Similarly, to get the sandbox URL for the Hapnium Portal API, you would use:
///
/// ```dart
/// String sandboxPortalUrl = BaseUrl.PORTAL_SANDBOX;
/// ```
class BaseUrl {
  /// The base URL for the production environment of the Hapnium service API.
  static String get PRODUCTION => "https://api.hapnium.com/api/v1";

  /// The base URL for the sandbox environment of the Hapnium service API.
  /// This is used for testing and non-production purposes.
  static String get SANDBOX => "https://sandbox.hapnium.com/api/v1";

  /// The base URL for the production environment of the Hapnium Portal API.
  static String get PORTAL_PRODUCTION => "https://api.portal.hapnium.com/api/v1";

  /// The base URL for the sandbox environment of the Hapnium Portal API.
  /// This is used for testing the portal in a non-production environment.
  static String get PORTAL_SANDBOX => "https://sandbox.portal.hapnium.com/api/v1";
}