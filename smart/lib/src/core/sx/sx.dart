import 'dart:async';

import 'package:flutter/cupertino.dart';

class Sx<T> {
  T _value;
  final List<VoidCallback> _listeners = [];

  Sx(this._value);

  T get value => _value;

  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      _tappyListeners();
    }
  }

  void _tappyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  void listen(VoidCallback callback) {
    _listeners.add(callback);
  }

  void unListen(VoidCallback callback) {
    _listeners.remove(callback);
  }

  void ever(void Function(T) callback) {
    listen(() => callback(_value));
  }

  void once(void Function(T) callback) {
    bool called = false;
    listen(() {
      if (!called) {
        callback(_value);
        called = true;
      }
    });
  }

  void debounce(void Function(T) callback, Duration duration) {
    Timer? timer;
    listen(() {
      timer?.cancel();
      timer = Timer(duration, () => callback(_value));
    });
  }

  void interval(void Function(T) callback, Duration duration) {
    bool canRun = true;
    listen(() {
      if (canRun) {
        callback(_value);
        canRun = false;
        Future.delayed(duration, () {
          canRun = true;
        });
      }
    });
  }
}