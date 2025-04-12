/**
 * A class containing constants for notification sound names.
 *
 * This class provides a centralized and type-safe way to manage
 * the names of notification sounds used in the application.  Using
 * constants makes it easier to change sound names later and helps
 * prevent typos.
 */
class NotifySound {
  /**
   * Sound name for connection events.
   */
  static const String connect = "connect";

  /**
   * Sound name for incoming calls or requests.
   */
  static const String incoming = "incoming";

  /**
   * Sound name for new messages.
   */
  static const String message = "message";

  /**
   * Sound name for general notifications.
   */
  static const String notify = "notify";

  /**
   * Sound name for schedule reminders or alerts.
   */
  static const String schedule = "schedule";
}