import 'package:hapnium/hapnium.dart';

import '../../../../smart.dart';

/// A class representing a user's permission consent state.
///
/// This class is used to manage and represent the user's consent for certain
/// permissions. It includes whether the user can pop the current screen, whether
/// the consent UI should be displayed, and the SDK version.

class PermissionConsent {
  /// A boolean flag indicating if the user can pop the current screen.
  ///
  /// If set to `true`, the user can go back or navigate to a previous screen.
  /// Defaults to `true`.
  final Boolean canPop;

  /// A boolean flag indicating if the consent UI should be shown.
  ///
  /// If set to `true`, the UI for permission consent is shown to the user.
  /// Defaults to `false`.
  final Boolean show;

  /// The SDK version that is used for permission consent decision.
  ///
  /// This value is required when creating a `PermissionConsent` instance.
  final int sdk;

  /// Creates an instance of [PermissionConsent].
  ///
  /// [canPop] indicates if the user can pop the current screen, defaults to `true`.
  /// [show] indicates if the permission consent UI should be shown, defaults to `false`.
  /// [sdk] represents the SDK version for permission consent.
  PermissionConsent({this.canPop = true, this.show = false, required this.sdk});

  /// Returns a copy of the current [PermissionConsent] instance with optional
  /// updated values for [canPop], [show], and/or [sdk].
  ///
  /// [canPop] and [show] are optional and will default to the current values
  /// if not provided. [sdk] is required to be provided if changed.
  PermissionConsent copyWith({Boolean? canPop, Boolean? show, int? sdk}) {
    return PermissionConsent(
      sdk: sdk ?? this.sdk,
      canPop: canPop ?? this.canPop,
      show: show ?? this.show,
    );
  }
}