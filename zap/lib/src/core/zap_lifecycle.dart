import 'package:flutter/foundation.dart' show nonVirtual;
import 'package:flutter/widgets.dart' show WidgetsBinding, WidgetsFlutterBinding, protected, mustCallSuper;

/// {@template zap_lifecycle}
/// The [ZapLifecycle]
/// 
/// This mixin provides a simple way to manage the lifecycle of a controller.
/// 
/// ```dart
/// class SomeController with ZapLifecycle {
///   SomeController() {
///     configureLifeCycle();
///   }
/// }
/// ```
/// 
/// {@endtemplate}
mixin ZapLifecycle {
  /// Called immediately after the widget is allocated in memory.
  /// You might use this to initialize something for the controller.
  @protected
  @mustCallSuper
  void onInit() {
    Engine.instance.addPostFrameCallback((_) => onReady());
  }

  /// Called 1 frame after onInit(). It is the perfect place to enter
  /// navigation events, like snackbar, dialogs, or a new route, or
  /// async request.
  void onReady() {}

  /// Called before [onDelete] method. [onClose] might be used to
  /// dispose resources used by the controller. Like closing events,
  /// or streams before the controller is destroyed.
  /// Or dispose objects that can potentially create some memory leaks,
  /// like TextEditingControllers, AnimationControllers.
  /// Might be useful as well to persist some data on disk.
  void onClose() {}

  bool _initialized = false;

  /// Checks whether the controller has already been initialized.
  bool get initialized => _initialized;

  /// Called at the exact moment the widget is allocated in memory.
  /// It uses an internal "callable" type, to avoid any @overrides in subclasses.
  /// This method should be internal and is required to define the
  /// lifetime cycle of the subclass.
  @mustCallSuper
  @nonVirtual
  void onStart() {
    if (_initialized) return;
    onInit();
    _initialized = true;
  }

  bool _isClosed = false;

  /// Checks whether the controller has already been closed.
  bool get isClosed => _isClosed;

  // Called when the controller is removed from memory.
  @mustCallSuper
  @nonVirtual
  void onDelete() {
    if (_isClosed) return;
    _isClosed = true;
    onClose();
  }
}

class Engine {
  static WidgetsBinding get instance {
    return WidgetsFlutterBinding.ensureInitialized();
  }
}