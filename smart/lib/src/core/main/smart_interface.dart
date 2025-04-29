import 'package:flutter/foundation.dart';

import 'log.dart';
import 'smart_management.dart';

/// SmartInterface allows any auxiliary package to be merged into the "Smart"
/// class through extensions
abstract class SmartInterface {
  SmartManagement smartManagement = SmartManagement.full;
  bool isLogEnable = kDebugMode;
  bool usePrettyLog = true;
  LogWriterCallback log = defaultLogWriterCallback;
}