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

// Provides expressive boolean checks for [PullToRefreshType].
///
/// This extension simplifies status checks by replacing `==` comparisons
/// with readable getters.
///
/// Example:
/// ```dart
/// if (refreshType.isMaterial) {
///   // Use Material-style refresh indicator
/// } else if (refreshType.isCupertino) {
///   // Use Cupertino-style refresh indicator
/// }
/// ```
extension PullToRefreshTypeExtension on PullToRefreshType {
  /// Returns `true` if the refresh type is [PullToRefreshType.material].
  bool get isMaterial => this == PullToRefreshType.material;

  /// Returns `true` if the refresh type is [PullToRefreshType.cupertino].
  bool get isCupertino => this == PullToRefreshType.cupertino;
}