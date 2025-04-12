import 'package:flutter/material.dart';
import 'package:hapnium/hapnium.dart';

/// Metadata for a Smart Poll.
///
/// This class holds information about a poll's metadata,
/// such as the total number of votes, an optional label for the votes,
/// and whether the metadata should be displayed.
class SmartPollMetadata {
  /// Total number of votes for the poll.
  ///
  /// This will be overridden in the [SmartPoll] widget. To override the total votes,
  /// use the [overrideTotalVotes] property.
  final Integer totalVotes;

  /// Whether the total votes should be overridden as the [SmartPoll] widget is rebuilt with the new total votes.
  ///
  /// Defaults to `true`.
  final Boolean overrideTotalVotes;

  /// Text label to display alongside the total votes.
  ///
  /// Defaults to "Votes".
  final String text;

  /// Whether the metadata should be shown.
  ///
  /// Defaults to `true`.
  final Boolean shouldShow;

  /// Custom widget to display as metadata.
  ///
  /// If `meta` is provided, it will be used instead of the default metadata display.
  final Widget? meta;

  /// TextStyle of the [text].
  final TextStyle style;

  /// Whether to auto-size the text
  ///
  /// Defaults to true
  final Boolean autoSize;

  /// The space between the poll and the metadata.
  ///
  /// Defaults to 4
  final Double spacing;

  /// The space between the children of the metadata.
  ///
  /// Defaults to 4
  final Double metaSpacing;

  /// **NEW**: How the main axis should be aligned.
  ///
  /// Defaults to `MainAxisAlignment.start` if not specified.
  final MainAxisAlignment mainAxisAlignment;

  /// **NEW**: Determines the size behavior along the main axis.
  ///
  /// Defaults to `MainAxisSize.max`.
  final MainAxisSize mainAxisSize;

  /// **NEW**: How the cross axis should be aligned.
  ///
  /// Defaults to `CrossAxisAlignment.center`.
  final CrossAxisAlignment crossAxisAlignment;

  /// **NEW**: Text direction for rendering children.
  ///
  /// Useful for controlling right-to-left (RTL) or left-to-right (LTR) layouts.
  final TextDirection? textDirection;

  /// **NEW**: Defines the vertical layout direction (e.g., down or up).
  ///
  /// Defaults to `VerticalDirection.down`.
  final VerticalDirection verticalDirection;

  /// **NEW**: The baseline to align text when using the `TextBaseline` option.
  final TextBaseline? textBaseline;

  /// Creates an instance of `SmartPollMetadata`.
  SmartPollMetadata({
    this.totalVotes = 0,
    this.text = "Votes",
    this.shouldShow = true,
    this.meta,
    this.style = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black
    ),
    this.autoSize = true,
    this.spacing = 4,
    this.metaSpacing = 4,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.overrideTotalVotes = true,
  });

  /// Creates a copy of the current `SmartPollMetadata` with optional overrides.
  SmartPollMetadata copyWith({
    Integer? totalVotes,
    String? text,
    Boolean? shouldShow,
    Widget? meta,
    TextStyle? style,
    Boolean? autoSize,
    Double? spacing,
    Double? metaSpacing,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    TextBaseline? textBaseline,
    Boolean? overrideTotalVotes,
  }) {
    return SmartPollMetadata(
      totalVotes: totalVotes ?? this.totalVotes,
      text: text ?? this.text,
      shouldShow: shouldShow ?? this.shouldShow,
      meta: meta ?? this.meta,
      style: style ?? this.style,
      autoSize: autoSize ?? this.autoSize,
      spacing: spacing ?? this.spacing,
      metaSpacing: metaSpacing ?? this.metaSpacing,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      mainAxisSize: mainAxisSize ?? this.mainAxisSize,
      textDirection: textDirection ?? this.textDirection,
      verticalDirection: verticalDirection ?? this.verticalDirection,
      textBaseline: textBaseline ?? this.textBaseline,
      overrideTotalVotes: overrideTotalVotes ?? this.overrideTotalVotes,
    );
  }
}