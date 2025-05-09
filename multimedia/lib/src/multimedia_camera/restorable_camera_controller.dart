import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

class RestorableCameraController extends RestorableValue<CameraController> {
  @override
  CameraController createDefaultValue() {
    return CameraController(
      CameraDescription(
        name: 'camera_0',
        lensDirection: CameraLensDirection.front,
        sensorOrientation: 270,
      ),
      ResolutionPreset.high,
      enableAudio: false,
    );
  }

  @override
  CameraController fromPrimitives(Object? data) {
    return createDefaultValue(); // Restore with default settings
  }

  @override
  Object toPrimitives() {
    return value; // Save current controller state
  }
  
  @override
  void didUpdateValue(CameraController? oldValue) {
    // TODO: implement didUpdateValue
  }
}