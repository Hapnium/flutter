part of 'permission_consent_layout.dart';

class _PermissionConsentLayoutState extends State<PermissionConsentLayout> {
  final PermissionConsentController _consentController = PermissionConsentController();

  @override
  void initState() {
    _init();

    super.initState();
  }

  void _init() {
    _consentController.init(
      isGranted: widget.isGranted,
      device: widget.device
    );

    setState(() {});
  }

  @override
  void didUpdateWidget(covariant PermissionConsentLayout oldWidget) {
    if(widget.isGranted.notEquals(oldWidget.isGranted)) {
      _consentController.init(isGranted: widget.isGranted, device: widget.device);
    }

    if(widget.device.notEquals(oldWidget.device)) {
      _consentController.init(isGranted: widget.isGranted, device: widget.device);
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
        StreamBuilder<PermissionConsent>(
          stream: _consentController.consentStream,
          builder: (BuildContext _, AsyncSnapshot<PermissionConsent> snapshot) {
            Boolean resize = MediaQuery.sizeOf(context).width <= widget.cardWidth;
            PermissionConsent? consent = snapshot.data;

            if(consent != null && consent.show) {
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

  Widget _buildConsentCard(PermissionConsentController controller, Boolean resize, Double width) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image(
                  image: widget.image,
                  width: widget.imageWidth ?? MediaQuery.sizeOf(context).width,
                  height: widget.imageHeight,
                ),
              ),
              TextBuilder(
                text: "In order to give you a smooth user experience, ${widget.name} requires some basic permissions to be granted.",
                size: Sizing.font(16),
                color: textColor,
              ),
              const SizedBox(height: 10),
              TextBuilder(text: "Some required permissions include:", size: Sizing.font(12), color: textColor),
              ...widget.permissions.map((item) {
                return TextBuilder(text: "* $item", size: Sizing.font(12), color: textColor);
              }),
              if(widget.isWeb) ...[
                const SizedBox(height: 10),
                TextBuilder(
                  text: "**NOTE** Permissions might take longer time in web before they show up or might even require you to click on `Grant` for them to show.",
                  size: Sizing.font(12),
                  color: textColor,
                )
              ],
              const SizedBox(height: 20),
              Center(
                child: InteractiveButton(
                  text: "Grant permissions",
                  borderRadius: 24,
                  width: widget.buttonWidth ?? MediaQuery.sizeOf(context).width,
                  textSize: Sizing.font(14),
                  buttonColor: widget.buttonColor ?? CommonColors.instance.darkTheme2,
                  textColor: widget.buttonTextColor ?? CommonColors.instance.lightTheme,
                  onClick: () => controller.grant(requestAccess: widget.requestAccess, onPermissionGranted: widget.onPermissionGranted),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}