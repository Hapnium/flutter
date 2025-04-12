import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hapnium/hapnium.dart';
import 'package:smart/ui.dart';

part 'smart_poll_state.dart';

/// A stateful widget representing an interactive poll.
///
/// [SmartPoll] is a highly customizable poll widget that supports voting, displaying
/// options, headers, and metadata. It also allows enforcing voting rules, disabling polls,
/// and building custom UI for each option or the entire poll.
///
/// ### Example Usage:
/// ```dart
/// SmartPoll(
///   id: 'poll1',
///   options: [
///     SmartPollOption(label: 'Option 1', votes: 10),
///     SmartPollOption(label: 'Option 2', votes: 20),
///   ],
///   onVoted: (option, newTotalVotes) async {
///     // Handle vote logic here.
///     return true; // Indicate vote success.
///   },
/// )
/// ```
///
/// See the constructor for detailed explanations of all available parameters.
class SmartPoll<T> extends StatefulWidget {
  /// The id of the poll.
  ///
  /// This id is used to identify the poll.
  /// It is also used to check if a user has already voted in this poll.
  final String? id;

  /// Indicates if the user has already voted in this poll.
  ///
  /// If `true`, the user cannot vote again. If this is set to `true`, `votedOptionId` must also be provided.
  ///
  /// Defaults to `false`.
  final Boolean hasVoted;

  /// The ID of the option that the user has voted for.
  ///
  /// This value is only considered if `hasVoted` is `true`.
  final T? votedOptionId;

  /// Callback when the user votes for an option.
  ///
  /// This callback is called with the index of the voted option.
  /// If the callback returns `true`, the tapped option is marked as voted.
  final SmartPollVotingCallback? onVoted;

  /// Optional widget displayed as the poll's header.
  final Widget? header;

  /// The list of options in the poll.
  ///
  /// The first element is the option that is selected by default.
  /// The second element is the option that is selected by default.
  /// The rest of the elements are the options that are available.
  /// The list can have any number of elements.
  ///
  /// Poll options are displayed in the order they are in the list. Example:
  ///
  /// ```dart
  /// List<SmartPollOption> options = [
  ///  SmartPollOption(id: 1, title: Text('Option 1'), votes: 2),
  ///  SmartPollOption(id: 2, title: Text('Option 2'), votes: 5),
  ///  SmartPollOption(id: 3, title: Text('Option 3'), votes: 9),
  ///  SmartPollOption(id: 4, title: Text('Option 4'), votes: 2),
  /// ]
  ///```
  ///
  /// The [id] of each poll option is used to identify the option when the user votes.
  /// The [title] of each poll option is displayed to the user.
  /// [title] can be any widget with a bounded size.
  /// The [votes] of each poll option is the number of votes that the option has received.
  final List<SmartPollOption> options;

  /// Spacing between the header and the options.
  ///
  /// Defaults to `10`.
  final Double? spacingBetweenHeaderAndOptions;

  /// The metadata that adds extra information to the poll.
  ///
  /// Defaults to custom configuration.
  final SmartPollMetadata? metadata;

  /// Builder for metadata displayed at the bottom of the poll.
  ///
  /// Defaults to `SmartPollMetadataBuilder`.
  final SmartPollMetadataBuilder? metadataBuilder;

  /// Whether the poll is closed and no longer accepts votes.
  ///
  /// Defaults to `false`.
  final Boolean pollEnded;

  /// Builder for each [SmartPollOption].
  ///
  /// Defaults to [SmartPollOptionBuilder].
  final SmartPollOptionBuilder? itemBuilder;

  /// Callback for each [SmartPollOption] whenever it builds or rebuilds.
  ///
  /// Defaults to [SmartPollOptionBuilder].
  final SmartPollOptionBuilder? itemReader;

  /// A function that builds the [SmartPollOptionConfig] based on an existing configuration.
  ///
  /// The [SmartPollOptionConfigBuilder] typedef defines a function signature for
  /// functions that receive a [SmartPollOptionConfig] as input and return a
  /// modified [SmartPollOptionConfig] object. This allows for flexible and
  /// customizable configuration of all [SmartPollOption] objects.
  final SmartPollOptionConfigBuilder? configBuilder;

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

  /// The overall configuration to be applied to all options.
  final SmartPollOptionConfig? globalConfig;

  /// Whether to use the `globalConfig` for this specific option.
  ///
  /// If `true`, the `globalConfig` will be applied to this option,
  /// overriding any specific configurations defined for this option.
  final Boolean useGlobalConfig;

  /// A stateful widget representing an interactive poll.
  ///
  /// [SmartPoll] is a highly customizable poll widget that supports voting, displaying
  /// options, headers, and metadata. It also allows enforcing voting rules, disabling polls,
  /// and building custom UI for each option or the entire poll.
  ///
  /// ### Example Usage:
  /// ```dart
  /// SmartPoll(
  ///   id: 'poll1',
  ///   options: [
  ///     SmartPollOption(label: 'Option 1', votes: 10),
  ///     SmartPollOption(label: 'Option 2', votes: 20),
  ///   ],
  ///   onVoted: (option, newTotalVotes) async {
  ///     // Handle vote logic here.
  ///     return true; // Indicate vote success.
  ///   },
  /// )
  /// ```
  ///
  /// See the constructor for detailed explanations of all available parameters.
  SmartPoll({
    super.key,
    this.id,
    this.hasVoted = false,
    this.votedOptionId,
    this.onVoted,
    this.header,
    this.spacingBetweenHeaderAndOptions,
    this.metadataBuilder,
    this.pollEnded = false,
    this.itemBuilder,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.globalConfig,
    this.itemReader,
    this.metadata,
    this.useGlobalConfig = false,
    this.configBuilder,
    required this.options,
  }) : assert(!hasVoted || votedOptionId != null, '>>>SmartPoll Error: [votedOptionId] must be provided if [hasVoted] is true.<<<'),
        assert(!useGlobalConfig || globalConfig.isNotNull, '>>>SmartPoll Error: [globalConfig] must be provided if [useGlobalConfig] is true.<<<');

  @override
  State<SmartPoll<T>> createState() => _SmartPollState<T>();

  /// Adds properties for Flutter's debugging tools.
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    // Core properties
    properties.add(StringProperty('id', id));
    properties.add(FlagProperty('hasVoted', value: hasVoted, ifTrue: 'User has voted', ifFalse: 'User has not voted'));
    properties.add(DiagnosticsProperty('votedOptionId', votedOptionId, defaultValue: null, ifNull: 'No option selected by user'));

    // Poll state properties
    properties.add(IntProperty('numberOfOptions', options.length, ifNull: 'No options available'));
    properties.add(FlagProperty('pollEnded', value: pollEnded, ifTrue: 'Poll is closed', ifFalse: 'Poll is open'));

    // UI-related properties
    properties.add(DiagnosticsProperty<Widget>('header', header, ifNull: 'No header provided'));
    properties.add(DoubleProperty('spacingBetweenHeaderAndOptions', spacingBetweenHeaderAndOptions, defaultValue: 10.0));
    properties.add(DiagnosticsProperty<SmartPollMetadataBuilder>('metadataBuilder', metadataBuilder, ifNull: 'No metadata builder provided'));
    properties.add(DiagnosticsProperty<SmartPollOptionBuilder>('itemBuilder', itemBuilder, ifNull: 'No item builder provided'));
    properties.add(DiagnosticsProperty<SmartPollOptionConfig>('globalConfig', globalConfig, ifNull: 'No global config provided'));
    properties.add(FlagProperty('useGlobalConfig', value: useGlobalConfig, ifTrue: 'Using global config', ifFalse: 'Not using global config'));
    properties.add(DiagnosticsProperty<SmartPollOptionConfigBuilder>('configBuilder', configBuilder, ifNull: 'No config builder provided'));

    // New alignment properties
    properties.add(EnumProperty<MainAxisAlignment>('mainAxisAlignment', mainAxisAlignment));
    properties.add(EnumProperty<MainAxisSize>('mainAxisSize', mainAxisSize));
    properties.add(EnumProperty<CrossAxisAlignment>('crossAxisAlignment', crossAxisAlignment));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection, defaultValue: null));
    properties.add(EnumProperty<VerticalDirection>('verticalDirection', verticalDirection));
    properties.add(EnumProperty<TextBaseline>('textBaseline', textBaseline, defaultValue: null));
  }
}