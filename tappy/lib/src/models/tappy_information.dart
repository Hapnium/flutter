import '../enums/app.dart';

/// A data model representing essential configuration details about the host application
/// used within the Tappy notification framework.
///
/// This class encapsulates platform-specific information (such as app icon references)
/// along with the logical classification of the app through the [TappyApp] enum.
/// It is intended to be provided during the initialization of [TappyApplication],
/// enabling consistent setup and rendering of notifications across platforms.
///
/// ---
/// ### Properties:
/// - [app]: The logical role or type of the app (e.g., user-facing, provider, admin),
///   typically defined by the [TappyApp] enum.
/// - [androidIcon]: The resource name of the notification icon for Android.
///   This should refer to a drawable asset included in the Android project under
///   `res/drawable`, excluding the file extension. Example: `"ic_notification"`.
/// - [iosIcon]: *(Optional)* The name of the app icon asset to use for iOS notifications.
///   This value may be empty if platform customization is not needed.
///
/// ---
/// ### Example Usage:
/// ```dart
/// TappyInformation(
///   app: TappyApp.user,
///   androidIcon: 'ic_user_notification',
///   iosIcon: 'AppIcon',
/// );
/// ```
///
/// This model is passed into [TappyApplication] and accessed internally through
/// [TappyInterface.appInformation].
///
/// ---
/// ### See Also:
/// - [TappyApp]
/// - [TappyApplication]
/// - [TappyPlatform]
class TappyInformation {
  /// The logical classification of the app within the Tappy ecosystem.
  ///
  /// This is used to differentiate between user, provider, or other roles
  /// for purposes of analytics, permissions, and UI behavior.
  final TappyApp app;

  /// The name of the Android notification icon (drawable resource).
  ///
  /// Must be a valid name of a resource located under the Android module's
  /// `res/drawable` folder, without file extension.
  ///
  /// For example: `'ic_notification'` for `res/drawable/ic_notification.png`.
  final String androidIcon;

  /// The name of the iOS notification icon asset, if applicable.
  ///
  /// If not specified, it defaults to an empty string, and the system default icon
  /// or fallback behavior will apply.
  final String iosIcon;

  /// Creates a new [TappyInformation] object to define app-level metadata
  /// used by the Tappy notification framework.
  ///
  /// [app] and [androidIcon] are required; [iosIcon] is optional.
  TappyInformation({
    required this.app,
    required this.androidIcon,
    this.iosIcon = "",
  });
}