import 'dart:io' as io;

import '../interface/redirect_info.dart';

/// A wrapper for [io.RedirectInfo]
class IoRedirectInfo implements RedirectInfo {
  final io.RedirectInfo _redirectInfo;
  IoRedirectInfo({required io.RedirectInfo redirectInfo}) : _redirectInfo = redirectInfo;

  @override
  int get statusCode => _redirectInfo.statusCode;

  @override
  String get method => _redirectInfo.method;

  @override
  Uri get location => _redirectInfo.location;
}