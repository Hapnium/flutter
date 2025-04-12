import 'package:notify/notify.dart';

class NotifyAppInformation {
  final NotifyApp app;
  final String androidIcon;
  final String iosIcon;

  NotifyAppInformation({
    required this.app,
    required this.androidIcon,
    this.iosIcon = ""
  });
}