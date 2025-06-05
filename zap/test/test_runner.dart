import 'package:flutter_test/flutter_test.dart';

import 'zap_utils_test.dart' as zap_utils_tests;
import 'zap_test.dart' as zap_tests;
import 'zap_pulse_test.dart' as zap_pulse_tests;
import 'zap_realtime_test.dart' as zap_realtime_tests;

void main() {
  group('Zap Library Test Suite', () {
    group('ZapUtils Tests', zap_utils_tests.main);
    group('Zap Tests', zap_tests.main);
    group('ZapPulse Tests', zap_pulse_tests.main);
    group('ZapRealtime Tests', zap_realtime_tests.main);
  });
}