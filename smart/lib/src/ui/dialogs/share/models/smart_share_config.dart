/// Configuration class for the SmartShare widget, defining which sharing options are enabled and the content to be shared.
///
/// This class allows you to customize the behavior of the SmartShare widget by
/// specifying which sharing platforms are available and providing the content
/// to be shared. It offers granular control over which social media platforms
/// and sharing functionalities are included in the widget.
///
/// **Purpose:**
///
/// The `SmartShareConfig` class is designed to be used with the `SmartShare`
/// widget to configure its sharing capabilities. It allows developers to
/// easily enable or disable specific sharing options and provide the content
/// that users can share.
///
/// **Usage:**
///
/// Create an instance of `SmartShareConfig` to configure the sharing options
/// for the `SmartShare` widget. You can enable or disable specific sharing
/// platforms and provide the content to be shared.
///
/// **Example:**
///
/// ```dart
/// SmartShareConfig(
///   enableWhatsApp: true,
///   enableTwitter: false,
///   message: "Check out this awesome content!",
///   data: "[https://example.com/content](https://www.google.com/search?q=https://example.com/content)",
/// )
/// ```
///
/// **Customization:**
///
/// You can customize the sharing options by setting the boolean flags for each
/// platform and functionality. The `message` and `data` properties allow you
/// to provide the content that will be shared or copied.
///
/// **Parameters:**
///
/// * `enableWhatsApp`: Whether to enable sharing via WhatsApp. Defaults to `true`.
/// * `enableSnapchat`: Whether to enable sharing via Snapchat. Defaults to `true`.
/// * `enableInstagram`: Whether to enable sharing via Instagram. Defaults to `true`.
/// * `enableTwitter`: Whether to enable sharing via Twitter. Defaults to `true`.
/// * `enableFacebook`: Whether to enable sharing via Facebook. Defaults to `true`.
/// * `enableMoreOptions`: Whether to enable "More Options" sharing. Defaults to `true`.
/// * `enableCopyLink`: Whether to enable "Copy Link" functionality. Defaults to `true`.
/// * `message`: The message to be shared across the enabled platforms. Defaults to an empty string.
/// * `data`: The data to be copied when the "Copy Link" option is used. Defaults to an empty string.
class SmartShareConfig {
  /// Enables or disables sharing via WhatsApp. Defaults to `true`.
  final bool enableWhatsApp;

  /// Enables or disables sharing via Snapchat. Defaults to `true`.
  final bool enableSnapchat;

  /// Enables or disables sharing via Instagram. Defaults to `true`.
  final bool enableInstagram;

  /// Enables or disables sharing via Twitter. Defaults to `true`.
  final bool enableTwitter;

  /// Enables or disables sharing via Facebook. Defaults to `true`.
  final bool enableFacebook;

  /// Enables or disables the "More Options" sharing functionality. Defaults to `true`.
  final bool enableMoreOptions;

  /// Enables or disables the "Copy Link" functionality. Defaults to `true`.
  final bool enableCopyLink;

  /// The message to be shared across the enabled platforms. Defaults to an empty string.
  final String message;

  /// The data to be copied when the "Copy Link" option is used. Defaults to an empty string.
  final String data;

  /// Whether to link the first part of the message. Defaults to `true`.
  final bool linkFirst;

  /// Whether to add spacing between content. Defaults to `true`.
  final bool addSpacingBetweenContent;

  /// Creates a [SmartShareConfig] instance.
  ///
  /// Allows you to configure the sharing options and content. All parameters
  /// are optional and have default values.
  ///
  /// **Parameters:**
  ///
  /// * [enableWhatsApp]: Whether to enable WhatsApp sharing. Defaults to `true`.
  /// * [enableSnapchat]: Whether to enable Snapchat sharing. Defaults to `true`.
  /// * [enableInstagram]: Whether to enable Instagram sharing. Defaults to `true`.
  /// * [enableTwitter]: Whether to enable Twitter sharing. Defaults to `true`.
  /// * [enableFacebook]: Whether to enable Facebook sharing. Defaults to `true`.
  /// * [enableMoreOptions]: Whether to enable "More Options" sharing. Defaults to `true`.
  /// * [enableCopyLink]: Whether to enable "Copy Link" functionality. Defaults to `true`.
  /// * [message]: The message to be shared. Defaults to an empty string.
  /// * [data]: The data to be copied. Defaults to an empty string.
  /// * [linkFirst]: Whether to link the first part of the message. Defaults to `true`.
  /// * [addSpacingBetweenContent]: Whether to add spacing between content. Defaults to `true`.
  const SmartShareConfig({
    this.enableWhatsApp = true,
    this.enableSnapchat = true,
    this.enableInstagram = true,
    this.enableTwitter = true,
    this.enableFacebook = true,
    this.enableMoreOptions = true,
    this.enableCopyLink = true,
    this.message = "",
    this.data = "",
    this.linkFirst = true,
    this.addSpacingBetweenContent = true,
  });
}