import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hapnium/hapnium.dart';

import '../../typedefs.dart';

part 'inactivity_layout_state.dart';

/// A wrapper widget that detects user inactivity based on touch and pointer interactions.
///
/// This widget listens to user interactions and triggers the [onInactivity] callback
/// after a specified [inactivityDuration] if no user interaction occurs. If any user
/// activity is detected, the [onActivity] callback is triggered (if provided), and the
/// inactivity timer is reset.
class InactivityLayout extends StatefulWidget {
  /// The child widget that this wrapper monitors for inactivity.
  final Widget child;

  /// Callback triggered when inactivity is detected.
  final UserActivityHandler? onInactivity;

  /// Optional callback triggered when user activity is detected.
  final UserActivityHandler? onActivity;

  /// The duration of inactivity before [onInactivity] is triggered.
  /// Defaults to 3 minutes if not provided.
  final Duration? inactivityDuration;

  /// Constructor for [InactivityLayout].
  const InactivityLayout({
    super.key,
    required this.child,
    this.onInactivity,
    this.onActivity,
    this.inactivityDuration,
  });

  @override
  State<InactivityLayout> createState() => _InactivityLayoutState();
}