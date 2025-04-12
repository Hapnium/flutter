/// A class for managing asset paths within the application.

/// This class provides a convenient way to access and manage the paths to
/// various assets used throughout the application.
class SmartAppAssets {
  /// Returns the base path for assets within the 'assets/app' directory.
  static String _base(String name) => "packages/smart/assets/app/$name.png";

  /// The path to the "nearby" asset.
  static String nearby = _base("nearby");

  /// The path to the "provider" asset.
  static String provider = _base("provider");

  /// The path to the "business" asset.
  static String business = _base("business");

  /// The path to the "user" asset.
  static String user = _base("user");
}