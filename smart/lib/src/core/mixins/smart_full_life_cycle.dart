import 'package:flutter/cupertino.dart';

import '../main/flutter_engine.dart';
import '../state/smart_controller.dart';

mixin SmartFullLifeCycleMixin on SmartFullLifeCycleController {
  @mustCallSuper
  @override
  void onInit() {
    super.onInit();
    Engine.instance.addObserver(this);
  }

  @mustCallSuper
  @override
  void onClose() {
    Engine.instance.removeObserver(this);
    super.onClose();
  }

  @mustCallSuper
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.paused:
        onPaused();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
      case AppLifecycleState.hidden:
        onHidden();
        break;
    }
  }

  void onResumed() {}
  void onPaused() {}
  void onInactive() {}
  void onDetached() {}
  void onHidden() {}
}