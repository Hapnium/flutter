part of 'notify_wrapper.dart';

class _NotifyWrapperState extends State<NotifyWrapper> {
  InAppConfig _config = InAppConfig();
  final _notificationService = Notify.instance.remote();

  @override
  void initState() {
   _init();

    super.initState();
  }

  void _init() {
    // Initialize platform-specific settings.
    PlatformEngine.instance.init(widget.platform);

    // Skip initialization for web platforms.
    if (!PlatformEngine.instance.isWeb) {
      _notificationService.init(
        widget.info,
        widget.showInitializationLogs,
        widget.handler,
        widget.backgroundHandler
      );

      // Handle app launches triggered by notifications.
      _notificationService.onAppLaunchedByNotification((note) {
        process(widget.onLaunchedByNotification, onProcess: (value) => value(note));
      });
    }

    // Update the notification permission status.
    process(widget.onPermitted, onProcess: (value) async => value(await _notificationService.isPermitted));
  }

  @override
  void didUpdateWidget(covariant NotifyWrapper oldWidget) {
    if(widget.inAppConfigurer != oldWidget.inAppConfigurer) {
      _init();
      setState(() {});
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    ToastificationConfig c = ToastificationConfigProvider.maybeOf(context)?.config ?? const ToastificationConfig();

    if(widget.inAppConfigurer != null) {
      InAppConfig built = widget.inAppConfigurer!(_config);

      c = c.copyWith(
        alignment: built.alignment,
        itemWidth: built.itemWidth,
        clipBehavior: built.clipBehavior,
        animationDuration: built.animationDuration,
        animationBuilder: built.animationBuilder,
        marginBuilder: built.marginBuilder,
        applyMediaQueryViewInsets: built.applyMediaQueryViewInsets,
      );

      setState(() {
        _config = built;
      });
    }

    return ToastificationWrapper(
      config: c,
      child: widget.child,
    );
  }
}