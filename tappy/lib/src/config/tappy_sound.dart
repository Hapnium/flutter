/// {@template tappy_sound}
/// A class containing constants for notification sound names.
///
/// This class provides a centralized and type-safe way to manage
/// the names of notification sounds used in the application.  Using
/// constants makes it easier to change sound names later and helps
/// prevent typos.
///
/// {@endtemplate}
class TappySound {
  /// The sound name.
  final String _key;

  /// {@macro tappy_sound}
  const TappySound._(this._key);

  /// Returns the sound name.
  String getKey() => _key;

  /// Sound name for connection events.
  static const TappySound CONNECT = TappySound._("connect");

  /// Sound name for incoming calls or requests.
  static const TappySound INCOMING = TappySound._("incoming");

  /// Sound name for new messages.
  static const TappySound MESSAGE = TappySound._("message");

  /// Sound name for general notifications.
  static const TappySound NOTIFY = TappySound._("tappy");

  /// Sound name for schedule reminders or alerts.
  static const TappySound SCHEDULE = TappySound._("schedule");

  /// Sound name for custom sounds.
  static TappySound CUSTOM(String key) => TappySound._(key);
}