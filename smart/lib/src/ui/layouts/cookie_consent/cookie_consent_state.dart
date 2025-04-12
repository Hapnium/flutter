part of 'cookie_consent_layout.dart';

class _CookieConsentLayoutState extends State<CookieConsentLayout> {
  final CookieConsentController _consentController = CookieConsentController();

  @override
  void initState() {
    _init();

    super.initState();
  }

  void _init() {
    _consentController.init(
      cookie: widget.cookie,
      isWeb: widget.isWeb,
      onCookieRejected: widget.onCookieRejected
    );

    setState(() {});
  }

  @override
  void didUpdateWidget(covariant CookieConsentLayout oldWidget) {
    if(widget.cookie.notEquals(oldWidget.cookie)) {
      _init();
    }

    if(widget.isWeb.notEquals(oldWidget.isWeb)) {
      _init();
    }

    if(widget.onCookieRejected.notEquals(oldWidget.onCookieRejected)) {
      _init();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _consentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: widget.child,
        ),
        StreamBuilder<Boolean>(
          stream: _consentController.showConsentStream,
          builder: (_, snapshot) {
            Boolean showConsent = snapshot.data ?? false;
            Boolean resize = MediaQuery.sizeOf(context).width <= widget.cardWidth;

            if(showConsent) {
              return Positioned(
                bottom: widget.bottomCardPlacement,
                right: resize ? widget.rightResizedCardPlacement : widget.rightCardPlacement,
                left: resize ? widget.leftResizedCardPlacement : widget.leftCardPlacement,
                child: _buildConsentCard(_consentController, resize, widget.cardWidth),
              );
            }

            return SizedBox.shrink();
          },
        )
      ],
    );
  }

  Widget _buildConsentCard(CookieConsentController controller, Boolean resize, Double width) {
    Color cardColor = widget.cardColor ?? Theme.of(context).scaffoldBackgroundColor;
    Color textColor = widget.textColor ?? Theme.of(context).primaryColor;

    return SizedBox(
      width: resize ? MediaQuery.sizeOf(context).width : width,
      child: Card(
        elevation: widget.cardElevation,
        color: cardColor,
        shape: widget.cardShape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: widget.cardContentPadding ?? EdgeInsets.all(16),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextBuilder(text: "We use cookies", size: 24, weight: FontWeight.w900, color: textColor),
              StreamBuilder<Boolean>(
                stream: controller.settingsStream,
                builder: (BuildContext context, AsyncSnapshot<Boolean> snapshot) {
                  if(snapshot.hasData) {
                    Boolean showSettings = snapshot.data ?? false;

                    if(showSettings) {
                      return Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.views().map((tab) {
                          return StreamBuilder<CookieConsent>(
                            stream: controller.cookieStream,
                            builder: (_, snap) {
                              CookieConsent cookie = snap.data ?? controller.cookie;

                              return _buildSelector(context, tab, controller.isSelected(tab.index, cookie));
                            }
                          );
                        }).toList(),
                      );
                    }
                  }

                  return Column(
                    spacing: 3,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextBuilder(
                        text: [
                          "Click “Accept” to enable Hapnium to use cookies to personalize this site, and to deliver ads",
                          "and measure their effectiveness on other apps and websites, including social media. Customize your",
                          "preferences in your Cookie Settings or click “Reject” if you do not want us to use cookies for",
                          "this purpose."
                        ].join(" "),
                        size: 12,
                        weight: FontWeight.w500,
                        color: textColor
                      ),
                      InkWell(
                        onTap: () {
                          if(widget.visitCookiePolicy.isNotNull) {
                            widget.visitCookiePolicy!(LinkUtils.instance.cookiePolicy);
                          }
                        },
                        child: TextBuilder(
                          text: "See our cookie policy",
                          size: 12,
                          weight: FontWeight.bold,
                          color: textColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  );
                }
              ),
              SizedBox(height: 10),
              Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StreamBuilder<Boolean>(
                    stream: controller.settingsStream,
                    builder: (context, snapshot) {
                      Boolean showSettings = snapshot.data ?? false;

                      return InteractiveButton(
                        padding: EdgeInsets.all(Sizing.space(6)),
                        text: showSettings ? "Hide" : "Cookie Settings",
                        textColor: widget.settingsButtonTextColor ?? textColor,
                        buttonColor: widget.settingsButtonColor ?? Colors.transparent,
                        borderRadius: 8,
                        textSize: 12,
                        autoSize: false,
                        textWeight: FontWeight.bold,
                        onClick: controller.toggle,
                      );
                    }
                  ),
                  InteractiveButton(
                    padding: EdgeInsets.all(Sizing.space(6)),
                    text: "Reject",
                    textColor: widget.rejectButtonTextColor ?? textColor,
                    buttonColor: widget.rejectButtonColor ?? Theme.of(context).appBarTheme.backgroundColor,
                    borderRadius: 8,
                    textSize: 12,
                    autoSize: false,
                    textWeight: FontWeight.bold,
                    onClick: () => controller.reject(widget.onCookieRejected),
                  ),
                  InteractiveButton(
                    padding: EdgeInsets.all(Sizing.space(6)),
                    text: "Accept",
                    textColor: widget.acceptButtonTextColor ?? CommonColors.instance.lightTheme,
                    buttonColor: widget.acceptButtonColor ?? CommonColors.instance.darkTheme2,
                    borderRadius: 8,
                    textSize: 12,
                    autoSize: false,
                    textWeight: FontWeight.bold,
                    onClick: () => controller.accept(widget.onCookieAccepted),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelector(BuildContext context, ButtonView tab, Boolean isSelected) {
    Color cardColor = widget.cardColor ?? Theme.of(context).scaffoldBackgroundColor;
    Color textColor = widget.textColor ?? Theme.of(context).primaryColor;
    Color color = isSelected ? cardColor : textColor;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Material(
        color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
        child: InkWell(
          onTap: tab.onClick,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextBuilder(text: tab.header, size: 14, weight: FontWeight.bold, color: color),
                TextBuilder(text: tab.body, color: widget.hintColor ?? CommonColors.instance.hint, size: 12)
              ],
            ),
          ),
        ),
      ),
    );
  }
}