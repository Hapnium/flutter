import 'dart:developer' as developer;
import 'package:tracing/tracing.dart';

import 'smart.dart';

///VoidCallback from logs
typedef LogWriterCallback = void Function(String text, {bool isError});

/// default logger from Smart
void defaultLogWriterCallback(String value, {bool isError = false}) {
  if(Smart.isLogEnable) {
    if(Smart.usePrettyLog) {
      if(isError) {
        console.error(value, tag: "SMART");
      } else {
        console.debug(value, tag: "SMART");
      }
    } else {
      developer.log(value, name: 'SMART');
    }
  }
}