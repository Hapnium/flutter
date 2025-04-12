import '../../../enums/ui/feedback_type.dart';

/// Provides expressive boolean checks for [FeedbackType].
///
/// This extension simplifies status checks by replacing `==` comparisons
/// with readable getters.
///
/// Example:
/// ```dart
/// if (feedbackType.isAccount) {
///   // Handle account feedback
/// } else if (feedbackType.isShop) {
///   // Handle shop feedback
/// }
/// ```
extension FeedbackTypeExtension on FeedbackType {
  /// Returns `true` if the feedback type is [FeedbackType.account].
  bool get isAccount => this == FeedbackType.account;

  /// Returns `true` if the feedback type is [FeedbackType.shop].
  bool get isShop => this == FeedbackType.shop;

  /// Returns `true` if the feedback type is [FeedbackType.trip].
  bool get isTrip => this == FeedbackType.trip;

  /// Returns `true` if the feedback type is [FeedbackType.app].
  bool get isApp => this == FeedbackType.app;

  /// Returns `true` if the feedback type is [FeedbackType.call].
  bool get isCall => this == FeedbackType.call;

  /// Returns `true` if the feedback type is [FeedbackType.event].
  bool get isEvent => this == FeedbackType.event;

  /// Returns `true` if the feedback type is [FeedbackType.club].
  bool get isClub => this == FeedbackType.club;

  /// Returns `true` if the feedback type is [FeedbackType.community].
  bool get isCommunity => this == FeedbackType.community;
}