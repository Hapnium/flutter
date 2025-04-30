import 'package:flutter/material.dart';
import 'package:smart/smart.dart';

/// A widget that displays an exploration section for the Smart app, allowing
/// users to navigate different sections and download the app.
class AppExplore extends StatelessWidget {
  /// The application instance being explored.
  final SmartApp app;

  /// Indicates whether the app is being used on the web.
  final bool isWeb;

  /// The optional light primary color override.
  final Color? primaryColorLight;

  /// The optional primary color override.
  final Color? primaryColor;

  /// The optional subtitle text color override.
  final Color? textSubtitleColor;

  /// The optional background container color.
  final Color? containerColor;

  /// The optional width of the image.
  final double? imageWidth;

  /// The optional header text size.
  final double? headerTextSize;

  /// The optional subtitle text size.
  final double? subtitleTextSize;

  /// List of apps to exclude
  final List<SmartApp> exclude;

  /// The optional border radius for images.
  final BorderRadiusGeometry? imageBorderRadius;

  /// Callback triggered when an app section is clicked.
  final AppDetailsSelector? onAppClicked;

  /// Creates an instance of [AppExplore].
  ///
  /// The [app] parameter is required.
  /// Optional parameters allow customization of colors, text sizes, image size, and interactions.
  const AppExplore({
    super.key,
    required this.app,
    this.isWeb = false,
    this.primaryColorLight,
    this.primaryColor,
    this.textSubtitleColor,
    this.containerColor,
    this.imageWidth,
    this.headerTextSize,
    this.subtitleTextSize,
    this.imageBorderRadius,
    this.onAppClicked,
    this.exclude = const [],
  });

  @override
  Widget build(BuildContext context) {
    List<ButtonView> more = [
      if(!app.isUser && !exclude.contains(SmartApp.user)) ...[
        ButtonView(
          header: "Hapnium",
          body: "Find service providers that can fix the issues you're having easily.",
          image: SmartAppAssets.user,
          index: 0
        )
      ],
      if(!app.isProvider && !exclude.contains(SmartApp.provider)) ...[
        ButtonView(
          header: "Hapnium Provider",
          body: "Earn, grow and get certified with your skill as a service provider.",
          image: SmartAppAssets.provider,
          index: 1
        )
      ],
      if(!app.isBusiness && !exclude.contains(SmartApp.business)) ...[
        ButtonView(
          header: "Hapnium Business",
          body: "Increase your revenue by moving your organization to our business platform.",
          image: SmartAppAssets.business,
          index: 2
        )
      ],
      if(!app.isNearby && !exclude.contains(SmartApp.nearby)) ...[
        ButtonView(
          header: "Nearby",
          body: "Find nearby places that suits your style and taste.",
          image: SmartAppAssets.nearby,
          index: 3
        )
      ],
      if(!app.isBlink && !exclude.contains(SmartApp.blink)) ...[
        ButtonView(
          header: "Blink",
          body: "Your personal AI powered security guard, helping you protect you and your assets.",
          image: SmartAppAssets.blink,
          index: 4
        )
      ],
    ];

    void handle(ButtonView view) {
      DomainAppLink appLink;

      if(view.index.equals(0)) {
        appLink = LinkUtils.instance.user;
      } else if(view.index.equals(1)) {
        appLink = LinkUtils.instance.provider;
      } else if(view.index.equals(2)) {
        appLink = LinkUtils.instance.business;
      } else {
        appLink = LinkUtils.instance.nearby;
      }

      if(onAppClicked.isNotNull) {
        onAppClicked!(appLink);
      }
    }

    String appImage = app.isBusiness
        ? SmartAppAssets.business
        : app.isProvider ? SmartAppAssets.provider
        : app.isNearby ? SmartAppAssets.nearby
        : app.isBlink ? SmartAppAssets.blink
        : SmartAppAssets.user;
    DomainAppLink appLink = app.isBusiness
        ? LinkUtils.instance.business
        : app.isProvider ? LinkUtils.instance.provider
        : app.isNearby ? LinkUtils.instance.nearby
        : LinkUtils.instance.user;
    Color _primaryColorLight = primaryColorLight ?? Theme.of(context).primaryColorLight;
    Color _primaryColor = primaryColor ?? Theme.of(context).primaryColor;
    BorderRadiusGeometry _imageBorderRadius = imageBorderRadius ?? BorderRadius.circular(10);
    double _headerTextSize = headerTextSize ?? Sizing.font(14);
    double _subtitleTextSize = subtitleTextSize ?? Sizing.font(12);

    return Column(
      spacing: 10,
      children: [
        if(more.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextBuilder(
                  text: "More from Hapnium",
                  size: _headerTextSize,
                  color: _primaryColorLight
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: Theme.of(context).textSelectionTheme.selectionColor,
                    child: Column(
                      children: more.map((view) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => handle(view),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                              child: Row(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: _imageBorderRadius,
                                    child: Image.asset(view.image, width: imageWidth ?? 45)
                                  ),
                                  Expanded(
                                    child: Column(
                                      spacing: 2,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextBuilder(
                                          text: view.header,
                                          size: _headerTextSize,
                                          color: _primaryColor
                                        ),
                                        TextBuilder(
                                          text: view.body,
                                          size: _subtitleTextSize,
                                          flow: TextOverflow.ellipsis,
                                          color: _primaryColorLight
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
        if(isWeb) ...[
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextBuilder(
                  text: "It is more easier in the app",
                  size: _headerTextSize,
                  color: _primaryColorLight
                ),
                ClipRRect(
                  borderRadius: _imageBorderRadius,
                  child: SmartButton(
                    tab: ButtonView(
                      header: "Download the ${app.type} app",
                      body: "Click to download from your favorite stores",
                      image: appImage
                    ),
                    bodyTextSize: _subtitleTextSize,
                    headerTextSize: _headerTextSize,
                    onTap: () {
                      if(onAppClicked.isNotNull) {
                        onAppClicked!(appLink);
                      }
                    },
                    color: _primaryColor,
                  ),
                )
              ],
            ),
          )
        ],
      ],
    );
  }
}