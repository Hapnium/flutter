import 'package:flutter/widgets.dart';
import 'package:hapnium/hapnium.dart';

import '../../typedefs.dart';

/// Represents a single option in a smart poll.
///
/// Each `SmartPollOption` can have a title, description, vote count,
/// and configuration for its appearance and behavior.
class SmartPollOption<T> {
  /// Unique identifier for the option.
  final T id;

  /// The title displayed for the option.
  final Widget? title;

  /// An optional description for the option.
  final String? description;

  /// Whether the option has been voted for by the user.
  ///
  /// Defaults to `false`.
  final Boolean isVoted;

  /// Whether the option is currently in the process of being voted for.
  ///
  /// Defaults to `false`.
  final Boolean isVoting;

  /// Whether the option is currently the leading vote.
  ///
  /// Defaults to `false`.
  final Boolean isLeading;

  /// The percentage of this option's votes compared to the total number of votes.
  ///
  /// Defaults to 0.0
  final Double percent;

  /// The total number of votes the option has received.
  final Integer votes;

  /// Configuration settings builder for the appearance and behavior of the option.
  final SmartPollOptionConfigBuilder? configBuilder;

  /// Creates a new `SmartPollOption`.
  ///
  /// Either the `title` or `description` must be provided.
  /// The number of votes must be specified.
  SmartPollOption({
    required this.id,
    this.title,
    this.description,
    required this.votes,
    this.configBuilder,
  })  : isVoted = false,
        isVoting = false,
        isLeading = false,
        percent = 0.0,
        assert(title.isNotNull || (description.isNotNull && description!.isNotEmpty), ">>>SmartPollOption: Either title or description must be provided.<<<", );

  /// Private constructor used for `copyWith`.
  SmartPollOption._internal({
    required this.id,
    required this.title,
    required this.description,
    required this.votes,
    required this.isVoting,
    required this.isVoted,
    required this.configBuilder,
    required this.percent,
    required this.isLeading,
  });

  /// Creates a copy of the current `SmartPollOption` with optional overrides.
  ///
  /// This method allows you to clone the current option and selectively
  /// change certain properties, such as the vote count or configuration.
  SmartPollOption<T> copyWith({
    T? id,
    Widget? title,
    String? description,
    Boolean? isVoted,
    Boolean? isVoting,
    Boolean? isLeading,
    Integer? votes,
    SmartPollOptionConfigBuilder? configBuilder,
    Double? percent,
  }) {
    return SmartPollOption._internal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isVoted: isVoted ?? this.isVoted,
      isVoting: isVoting ?? this.isVoting,
      votes: votes ?? this.votes,
      configBuilder: configBuilder ?? this.configBuilder,
      percent: percent ?? this.percent,
      isLeading: isLeading ?? this.isLeading,
    );
  }
}