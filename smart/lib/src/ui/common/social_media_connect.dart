import 'package:flutter/material.dart';

import '../../../../smart.dart';

/// A customizable widget for displaying social media connection buttons.
///
/// This widget allows you to display a set of social media icons with a title. The icons are arranged in a
/// wrap layout, and you can specify various styling properties such as padding, spacing, and alignment.
/// The widget also allows you to define a custom action to be triggered when a social media icon is clicked.
///
/// - **[isCentered]**: If true, the widget will be centered on the screen.
/// - **[domain]**: The domain (e.g., `example.com`) used to fetch the social media links.
/// - **[padding]**: The padding around the entire widget.
/// - **[iconPadding]**: Padding around each social media icon.
/// - **[titleTextSize]**: The font size of the title text.
/// - **[titleTextColor]**: The color of the title text.
/// - **[socialAssetWidth]**: The width of the social media icons.
/// - **[socialAssetHeight]**: The height of the social media icons.
/// - **[socialAssetColor]**: The color applied to the social media icon images.
/// - **[iconSplashSize]**: The splash size when an icon is clicked.
/// - **[spacing]**: The horizontal space between icons.
/// - **[runSpacing]**: The vertical space between icons (in case they wrap to a new line).
/// - **[title]**: The title text to be displayed above the social media icons.
/// - **[mainAxisAlignment]**: Alignment of children along the main axis (vertical alignment in this case).
/// - **[mainAxisSize]**: Determines the main axis size for the column (min or max).
/// - **[crossAxisAlignment]**: Alignment of children along the cross axis (horizontal alignment).
/// - **[alignment]**: Alignment of the icons within the wrap (horizontal axis).
/// - **[runAlignment]**: Alignment of the icons within the wrap (vertical axis).
/// - **[wrapCrossAxisAlignment]**: Cross-axis alignment of the icons in the wrap.
/// - **[onSocialClicked]**: The callback function to be triggered when a social media icon is clicked.
///   It receives the social media path as a parameter.
class SocialMediaConnect extends StatelessWidget {
  /// Determines whether the widget should be centered on the screen.
  final Boolean isCentered;

  /// The domain (e.g., `example.com`) used to fetch the social media links.
  final String? domain;

  /// The padding around the entire widget.
  final EdgeInsetsGeometry? padding;

  /// Padding around each social media icon.
  final EdgeInsetsGeometry? iconPadding;

  /// The font size of the title text.
  final Double? titleTextSize;

  /// The color of the title text.
  final Color? titleTextColor;

  /// The width of the social media icons.
  final Double? socialAssetWidth;

  /// The height of the social media icons.
  final Double? socialAssetHeight;

  /// The color applied to the social media icon images.
  final Color? socialAssetColor;

  /// The splash size when an icon is clicked.
  final Double? iconSplashSize;

  /// The horizontal space between icons.
  final Double? spacing;

  /// The vertical space between icons (in case they wrap to a new line).
  final Double? runSpacing;

  /// The title text to be displayed above the social media icons.
  final String? title;

  /// Alignment of children along the main axis (vertical alignment).
  final MainAxisAlignment? mainAxisAlignment;

  /// Determines the main axis size for the column (min or max).
  final MainAxisSize? mainAxisSize;

  /// Alignment of children along the cross axis (horizontal alignment).
  final CrossAxisAlignment? crossAxisAlignment;

  /// Alignment of the icons within the wrap (horizontal axis).
  final WrapAlignment? alignment;

  /// Alignment of the icons within the wrap (vertical axis).
  final WrapAlignment? runAlignment;

  /// Cross-axis alignment of the icons in the wrap.
  final WrapCrossAlignment? wrapCrossAxisAlignment;

  /// The callback function to be triggered when a social media icon is clicked.
  /// It receives the social media path as a parameter.
  final UrlHandler onSocialClicked;

  /// Creates a [SocialMediaConnect] widget.
  ///
  /// All parameters are optional, and if not provided, default values will be used.
  ///
  /// - [isCentered] centers the widget if true. Defaults to false.
  /// - [domain] can be used to specify the domain for social media links.
  /// - [padding] provides padding around the entire widget.
  /// - [iconPadding] defines padding for each icon.
  /// - [titleTextSize] allows setting the font size for the title.
  /// - [titleTextColor] sets the title text color.
  /// - [socialAssetWidth] controls the width of the social media icons.
  /// - [socialAssetHeight] controls the height of the social media icons.
  /// - [socialAssetColor] sets the color for the social media icons.
  /// - [iconSplashSize] defines the splash size for icon presses.
  /// - [spacing] sets the horizontal spacing between icons.
  /// - [runSpacing] sets the vertical spacing between icons.
  /// - [title] allows setting the title text.
  /// - [mainAxisAlignment] and [crossAxisAlignment] control the layout.
  /// - [alignment] and [runAlignment] customize the wrap's alignment.
  /// - [wrapCrossAxisAlignment] adjusts the cross-axis alignment of the wrap.
  /// - [onSocialClicked] specifies the callback for social media icon clicks.
  const SocialMediaConnect({
    super.key,
    this.isCentered = false,
    this.domain,
    this.padding,
    this.iconPadding,
    this.titleTextSize,
    this.titleTextColor,
    this.socialAssetWidth,
    this.socialAssetHeight,
    this.socialAssetColor,
    this.iconSplashSize,
    this.spacing,
    this.runSpacing,
    this.title,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.alignment,
    this.runAlignment,
    this.wrapCrossAxisAlignment,
    required this.onSocialClicked,
  });

  @override
  Widget build(BuildContext context) {
    if (isCentered) {
      return Center(child: _build(context));
    } else {
      return _build(context);
    }
  }

  Widget _build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(Sizing.space(12)),
      child: Column(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
        mainAxisSize: mainAxisSize ?? MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        children: [
          TextBuilder.center(
            text: title ?? "Connect with us",
            size: Sizing.font(titleTextSize ?? 11),
            color: titleTextColor ?? Theme.of(context).primaryColorLight,
          ),
          Wrap(
            runAlignment: runAlignment ?? WrapAlignment.spaceBetween,
            crossAxisAlignment: wrapCrossAxisAlignment ?? WrapCrossAlignment.center,
            spacing: spacing ?? 5,
            runSpacing: runSpacing ?? 5,
            children: LinkUtils.instance.media(domain: domain).map((media) {
              return IconButton(
                splashRadius: iconSplashSize ?? 16,
                padding: iconPadding ?? EdgeInsets.all(Sizing.space(5)),
                tooltip: media.header,
                onPressed: () => onSocialClicked(media.path),
                icon: Image.asset(
                  media.image,
                  color: socialAssetColor ?? Theme.of(context).primaryColor,
                  width: Sizing.space(socialAssetWidth ?? 16),
                  height: socialAssetHeight,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}