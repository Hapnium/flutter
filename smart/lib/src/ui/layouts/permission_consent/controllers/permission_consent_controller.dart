import 'dart:async';

import 'package:hapnium/hapnium.dart';

import '../../../export.dart';

class PermissionConsentController {
  PermissionConsent? _consent;
  PermissionConsent get consent => _consent ?? PermissionConsent(sdk: 0, show: false, canPop: true);

  final StreamController<PermissionConsent> _consentController = StreamController.broadcast();
  Stream<PermissionConsent> get consentStream => _consentController.stream;

  void init({required Boolean isGranted, required int sdk}) {
    if (!isGranted) {
      PermissionConsent consent = PermissionConsent(sdk: sdk, show: true, canPop: false);

      _consent = consent;
      Future.microtask(() => _consentController.add(consent));
    }
  }

  void grant({required PermissionAccessHandler requestAccess, OnActionInvoked? onPermissionGranted}) async {
    PermissionConsent update = consent.copyWith(canPop: false);

    _consent = update;
    _consentController.add(update);

    Boolean hasAccess = await requestAccess();
    if(hasAccess) {
      PermissionConsent event = update.copyWith(canPop: true, show: false);
      _consent = event;
      _consentController.add(event);

      if(onPermissionGranted.isNotNull) {
        onPermissionGranted!();
      }
    } else {
      grant(requestAccess: requestAccess, onPermissionGranted: onPermissionGranted);
    }
  }

  void dispose() {
    _consentController.close();
  }
}