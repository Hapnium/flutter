import 'dart:async';

import 'package:hapnium/hapnium.dart';

import '../../../export.dart';

class CookieConsentController {
  final StreamController<Boolean> _showConsentController = StreamController.broadcast();
  Stream<Boolean> get showConsentStream => _showConsentController.stream;

  CookieConsent _cookie = CookieConsent.empty();
  CookieConsent get cookie => _cookie;

  final StreamController<CookieConsent> _cookieController = StreamController.broadcast();
  Stream<CookieConsent> get cookieStream => _cookieController.stream;

  Boolean _showSettings = false;
  Boolean get showSettings => _showSettings;

  final StreamController<Boolean> _settingsController = StreamController.broadcast();
  Stream<Boolean> get settingsStream => _settingsController.stream;

  void init({required Boolean isWeb, required CookieConsent cookie, CookieConsentHandler? onCookieRejected}) {
    if(isWeb) {
      if(cookie.isAnalytics && cookie.isAdvertising && cookie.isEssential) {
        return;
      } else if(cookie.isEssential) {
        return;
      } else if(!(cookie.isAnalytics && cookie.isAdvertising && cookie.isEssential)) {
        if(onCookieRejected.isNotNull) {
          onCookieRejected!(cookie);
        }

        _cookie = CookieConsent.empty().copyWith(isEssential: true);
        Future.microtask(() {
          _cookieController.add(_cookie);
          _showConsentController.add(true);
          _settingsController.add(false);
        });
      } else if(!cookie.isRejected) {
        if(onCookieRejected.isNotNull) {
          onCookieRejected!(cookie);
        }
        // _cookie = cookie;
        // _showSettings = false;
        //
        // Future.microtask(() {
        //   _cookieController.add(cookie);
        //   _showConsentController.add(true);
        //   _settingsController.add(_showSettings);
        // });
      }
    }
  }

  void toggle() {
    _showSettings = !_showSettings;
    _settingsController.add(_showSettings);
  }

  void reject(CookieConsentHandler onCookieRejected) {
    _cookie = _cookie.copyWith(isRejected: true);
    onCookieRejected(_cookie);

    _cookieController.add(cookie);
    _showConsentController.add(false);
  }

  void accept(CookieConsentHandler onCookieAccepted) {
    _cookie = _cookie.copyWith(isRejected: false);
    onCookieAccepted(_cookie);

    _cookieController.add(cookie);
    _showConsentController.add(false);
  }

  List<ButtonView> views() {
    return [
      if(!_cookie.isEssential) ...[
        ButtonView(
          header: "Essential",
          body: "Essential cookies are necessary for features which are essential to your use of our site or services, such as account login, authentication, and site security.",
          index: 0,
          onClick: () {
            _cookie = _cookie.copyWith(isEssential: true);
            _cookieController.add(_cookie);
          }
        )
      ],
      if(!_cookie.isAdvertising) ...[
        ButtonView(
          header: "Targeted Advertising",
          body: "Targeted advertising cookies allow Hapnium to share your data with advertising partners, including social media companies, to send you more relevant ads on other apps and websites, and for purposes determined by those partners.",
          index: 1,
          onClick: () {
            _cookie = _cookie.copyWith(isAdvertising: !_cookie.isAdvertising);
            _cookieController.add(_cookie);
          }
        )
      ],
      if(!_cookie.isAnalytics) ...[
        ButtonView(
          header: "Analytics",
          body: "Analytics cookies allow Hapnium to analyze your visits and actions on our and third-party apps and websites to understand your interests and be able to offer you more relevant ads on other apps and websites.",
          index: 2,
          onClick: () {
            _cookie = _cookie.copyWith(isAnalytics: !_cookie.isAnalytics);
            _cookieController.add(_cookie);
          }
        )
      ],
    ];
  }

  Boolean isSelected(Integer index, CookieConsent cookie) {
    if(index == 0) {
      return cookie.isEssential;
    } else if(index == 1) {
      return cookie.isAdvertising;
    } else {
      return cookie.isAnalytics;
    }
  }

  void dispose() {
    _cookieController.close();
    _settingsController.close();
  }
}