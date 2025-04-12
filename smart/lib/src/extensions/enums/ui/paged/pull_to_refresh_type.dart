import '../../../../enums/ui/paged/pull_to_refresh_type.dart';

/// Provides expressive boolean checks for [PullToRefreshType].
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