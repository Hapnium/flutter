import 'package:flutter/material.dart';
import 'package:hapnium/hapnium.dart';

import 'smart_poll_option.dart';

/// Configuration options for a SmartPollOption.
///
/// This class holds configuration settings that can be applied to
/// customize the appearance and behavior of a `SmartPollOption`
/// within a poll widget.
class SmartPollOptionConfig {
  /// Height of a [SmartPollOption].
  /// The height is the same for all options.
  ///
  /// Defaults to 36.
  final Double height;

  /// Determines whether to use the user-defined [text] in the [SmartPollOption]
  /// ui instead of the calculated result.
  ///
  /// Defaults to [false]
  final Boolean useText;

  /// Width of a [SmartPollOption].
  /// The width is the same for all options.
  ///
  /// If not specified, the width is set to the width of the poll.
  /// If the poll is not wide enough, the width is set to the width of the poll.
  /// If the poll is too wide, the width is set to the width of the poll.
  final Double? width;

  /// The spacing between the options.
  ///
  /// The default value is 8.
  final Double spacing;

  /// Border radius of a [SmartPollOption].
  /// The border radius is the same for all options.
  ///
  /// Defaults to [BorderRadius.circular(8)
  /// ].
  final BorderRadius borderRadius;

  /// Border of a [SmartPollOption].
  /// The border is the same for all options.
  ///
  /// Defaults to null.
  /// If null, the border is not drawn.
  final BoxBorder border;

  /// Border of a [SmartPollOption] when the user has voted.
  /// The border is the same for all options.
  /// Defaults to null.
  /// If null, the border is not drawn.
  final BoxBorder? votedBorder;

  /// BoxDecoration of a [SmartPollOption] when the user has voted.
  ///
  /// If [votedBorder] is not null, then default decoration is used unless [votedDecoration] is defined.
  /// Defaults to null.
  final BoxDecoration? votedDecoration;

  /// Color of a [SmartPollOption].
  /// The color is the same for all options.
  ///
  /// Defaults to [Colors.blue].
  final Color? fillColor;

  /// Splashes a [SmartPollOption] when the user taps it.
  ///
  /// Defaults to [Colors.grey].
  final Color splashColor;

  /// Radius of the border of a [SmartPollOption] when the user has voted.
  ///
  /// Defaults to [Radius.circular(8)].
  final Radius votedRadius;

  /// Color of the background of a [SmartPollOption] when the user has voted.
  ///
  /// Defaults to [const Color(0xffEEF0EB)].
  final Color votedBackgroundColor;

  /// Color of the progress bar of a [SmartPollOption] when the user has voted.
  ///
  /// Defaults to [const Color(0xff84D2F6)].
  final Color votedProgressColor;

  /// Color of the progress bar of a [SmartPollOption] when the user has voted.
  ///
  /// Defaults to [const Color(0xffEEF0EB)].
  final Color userVotedBackgroundColor;

  /// Color of the progress bar of a [SmartPollOption] when the user has voted.
  ///
  /// Defaults to [const Color(0xff84D2F6)].
  final Color userVotedProgressColor;

  /// Color of the leading progress bar of a [SmartPollOption] when the user has voted.
  ///
  /// Defaults to [const Color(0xff0496FF)].
  final Color leadingVotedProgressColor;

  /// Color of the background of a [SmartPollOption] when the user clicks to vote and its still in progress.
  ///
  /// Defaults to [const Color(0xffEEF0EB)].
  final Color voteInProgressColor;

  /// Widget for the checkmark of a [SmartPollOption] when the user has voted.
  ///
  /// Defaults to [Icons.check_circle_outline_rounded].
  final Widget votedCheckmark;

  /// TextStyle of the percentage or description of a [SmartPollOption].
  final TextStyle style;

  /// Whether to auto size text
  ///
  /// Defaults to true
  final Boolean autoSize;

  /// Animation duration of the progress bar of the [SmartPollOption]'s when the user has voted.
  ///
  /// Defaults to 1000 milliseconds.
  /// If the animation duration is too short, the progress bar will not animate.
  /// If you don't want the progress bar to animate, set this to 0.
  final Duration votedDuration;

  /// Animation duration of the switcher for the [SmartPollOption]'s when changing view of voted and not voted.
  ///
  /// Defaults to [Duration(milliseconds: 300)].
  final Duration switchDuration;

  /// Loading animation widget for [SmartPollOption] when [onVoted] callback is invoked
  /// Defaults to [CircularProgressIndicator]
  /// Visible until the [onVoted] execution is completed,
  final Widget votingProgressIndicator;

  /// The width of the content area within the widget.
  final double contentWidth;

  /// The spacing between elements within the content area.
  final double contentSpacing;

  /// The padding applied to the content area.
  final EdgeInsetsGeometry contentPadding;

  /// The text content to be displayed within the widget.
  final String text;

  SmartPollOptionConfig({
    Double? height,
    Double? spacing,
    this.width,
    BorderRadius? borderRadius,
    BoxBorder? border,
    BoxDecoration? votedDecoration,
    this.votedBorder,
    this.fillColor,
    Color? splashColor,
    Radius? votedRadius,
    Color? votedBackgroundColor,
    Color? votedProgressColor,
    Color? userVotedBackgroundColor,
    Color? userVotedProgressColor,
    Color? leadingVotedProgressColor,
    Color? voteInProgressColor,
    Widget? votedCheckmark,
    TextStyle? style,
    Duration? votedDuration,
    Widget? votingProgressIndicator,
    Duration? switchDuration,
    Boolean? autoSize,
    Double? contentWidth,
    Double? contentSpacing,
    EdgeInsetsGeometry? contentPadding,
    String? text,
    Boolean? useText
  }) : borderRadius = borderRadius ?? BorderRadius.circular(8),
      height = height ?? 36,
      votedRadius = votedRadius ?? Radius.circular(8),
      spacing = spacing ?? 8,
      autoSize = autoSize ?? true,
      splashColor = splashColor ?? Colors.grey,
      useText = useText ?? false,
      votedBackgroundColor = votedBackgroundColor ?? Color(0xffEEF0EB),
      votedProgressColor = votedProgressColor ?? Color(0xff84D2F6),
      userVotedBackgroundColor = userVotedBackgroundColor ?? Color(0xffEEF0EB),
      userVotedProgressColor = userVotedProgressColor ?? Color(0xff84D2F6),
      leadingVotedProgressColor = leadingVotedProgressColor ?? Color(0xff0496FF),
      voteInProgressColor = voteInProgressColor ?? Color(0xffEEF0EB),
      votedCheckmark = votedCheckmark ?? const Icon(
        Icons.check_circle_outline_rounded,
        color: Colors.black,
        size: 16,
      ),
      switchDuration = switchDuration ?? Duration(milliseconds: 300),
      votedDecoration = votedDecoration ?? (votedBorder.isNotNull ? BoxDecoration(
        border: votedBorder,
        borderRadius: BorderRadius.all(votedRadius ?? const Radius.circular(8)),
      ) : null),
      border = border ?? Border.all(color: Colors.black, width: 1),
      style = style ?? TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.normal
      ),
      votedDuration = votedDuration ?? Duration(milliseconds: 1000),
      votingProgressIndicator = votingProgressIndicator ?? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      text = text ?? ' votes',
      contentWidth = contentWidth ?? double.infinity,
      contentSpacing = contentSpacing ?? 10,
      contentPadding = contentPadding ?? const EdgeInsets.symmetric(horizontal: 14);

  /// Creates a copy of the current configuration with the option to override specific properties.
  SmartPollOptionConfig copyWith({
    Double? height,
    Double? width,
    Double? spacing,
    BorderRadius? borderRadius,
    BoxBorder? border,
    BoxBorder? votedBorder,
    BoxDecoration? votedDecoration,
    Color? fillColor,
    Color? splashColor,
    Radius? votedRadius,
    Color? votedBackgroundColor,
    Color? votedProgressColor,
    Color? leadingVotedProgressColor,
    Color? voteInProgressColor,
    Color? userVotedBackgroundColor,
    Color? userVotedProgressColor,
    Widget? votedCheckmark,
    TextStyle? style,
    Duration? votedDuration,
    Duration? switchDuration,
    Widget? votingProgressIndicator,
    Boolean? autoSize,
    Double? contentWidth,
    Double? contentSpacing,
    EdgeInsetsGeometry? contentPadding,
    String? text,
    Boolean? useText
  }) {
    return SmartPollOptionConfig(
      height: height ?? this.height,
      width: width ?? this.width,
      spacing: spacing ?? this.spacing,
      borderRadius: borderRadius ?? this.borderRadius,
      border: border ?? this.border,
      votedBorder: votedBorder ?? this.votedBorder,
      votedDecoration: votedDecoration ?? this.votedDecoration,
      fillColor: fillColor ?? this.fillColor,
      splashColor: splashColor ?? this.splashColor,
      votedRadius: votedRadius ?? this.votedRadius,
      votedBackgroundColor: votedBackgroundColor ?? this.votedBackgroundColor,
      votedProgressColor: votedProgressColor ?? this.votedProgressColor,
      leadingVotedProgressColor: leadingVotedProgressColor ?? this.leadingVotedProgressColor,
      voteInProgressColor: voteInProgressColor ?? this.voteInProgressColor,
      userVotedBackgroundColor: userVotedBackgroundColor ?? this.userVotedBackgroundColor,
      userVotedProgressColor: userVotedProgressColor ?? this.userVotedProgressColor,
      votedCheckmark: votedCheckmark ?? this.votedCheckmark,
      style: style ?? this.style,
      votedDuration: votedDuration ?? this.votedDuration,
      switchDuration: switchDuration ?? this.switchDuration,
      autoSize: autoSize ?? this.autoSize,
      votingProgressIndicator: votingProgressIndicator ?? this.votingProgressIndicator,
      contentWidth: contentWidth ?? this.contentWidth,
      contentPadding: contentPadding ?? this.contentPadding,
      contentSpacing: contentSpacing ?? this.contentSpacing,
      text: text ?? this.text,
      useText: useText ?? this.useText
    );
  }
}