/// Enum representing the refresh indicator type.
///
/// - [material]: Uses Material-style [RefreshIndicator] (default for Android, Web).
/// - [cupertino]: Uses Cupertino-style [CupertinoSliverRefreshControl] (default for iOS).
enum PullToRefreshType {
  /// Uses Material-style [RefreshIndicator] (default for Android, Web).
  material,

  /// Uses Cupertino-style [CupertinoSliverRefreshControl] (default for iOS).
  cupertino
}