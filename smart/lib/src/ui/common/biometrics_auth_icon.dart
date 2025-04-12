import 'package:flutter/material.dart';
import 'package:smart/enums.dart';
import 'package:smart/extensions.dart';
import 'package:smart/src/styles/colors/common_colors.dart';

/// A visual indicator for the status of biometric authentication.
/// 
/// This widget displays an icon representing the current state of biometric 
/// authentication, such as success, failure, or an initial state.
/// 
/// **Parameters:**
/// 
/// * **state:** 
///     * The current state of biometric authentication.
///     * Required.
/// * **iconSize:** 
///     * The size of the icon. 
///     * Defaults to 60.
/// * **staleColor:** 
///     * The color of the icon when the state is `BiometricAuthState.none`.
/// * **failedColor:** 
///     * The color of the icon when the state is `BiometricAuthState.failed`.
/// * **successColor:** 
///     * The color of the icon when the state is `BiometricAuthState.success`.
class BiometricsAuthIcon extends StatelessWidget {
  /// The current state of biometric authentication.
  /// 
  /// Required.
  final BiometricAuthState state;

  /// The size of the icon. 
  /// 
  /// Defaults to 60.
  final double iconSize;

  /// The color of the icon when the state is `BiometricAuthState.none`.
  final Color? staleColor;

  /// The color of the icon when the state is `BiometricAuthState.failed`.
  final Color? failedColor;

  /// The color of the icon when the state is `BiometricAuthState.success`.
  final Color? successColor;

  const BiometricsAuthIcon({
    super.key,
    required this.state,
    this.iconSize = 60,
    this.staleColor,
    this.failedColor,
    this.successColor
  });

  @override
  Widget build(BuildContext context) {
    if(state.isNone) {
      return Icon(
        Icons.fingerprint_rounded,
        color: staleColor ?? Theme.of(context).primaryColorLight,
        size: iconSize
      );
    } else if(state.isFailed) {
      return Icon(
        Icons.error_rounded,
        color: failedColor ?? CommonColors.instance.error,
        size: iconSize
      );
    } else {
      return Icon(
        Icons.check_circle_rounded,
        color: successColor ?? CommonColors.instance.error,
        size: iconSize
      );
    }
  }
}