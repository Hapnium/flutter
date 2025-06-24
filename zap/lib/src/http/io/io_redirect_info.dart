import 'dart:io' as io;

import '../interface/redirect_info.dart';

/// {@template io_redirect_info}
/// A wrapper for [io.RedirectInfo]
/// 
/// This class is used to wrap [io.RedirectInfo] to implement [RedirectInfo].
/// 
/// {@endtemplate}
class IoRedirectInfo implements RedirectInfo {
  /// The wrapped [io.RedirectInfo].
  final io.RedirectInfo _redirectInfo;

  /// {@macro io_redirect_info}
  IoRedirectInfo({required io.RedirectInfo redirectInfo}) : _redirectInfo = redirectInfo;

  @override
  int get statusCode => _redirectInfo.statusCode;

  @override
  String get method => _redirectInfo.method;

  @override
  Uri get location => _redirectInfo.location;
}