import 'dart:async' show Completer;

import '../exceptions/exceptions.dart';

/// A token that can be used to cancel HTTP requests.
/// 
/// This class provides a way to cancel ongoing requests when they are no longer needed,
/// such as when a user navigates away from a page or wants to abort an operation.
/// 
/// Example usage:
/// ```dart
/// final cancelToken = CancelToken();
/// 
/// // Start a request
/// final future = zap.get<String>(
///   '/api/data',
///   cancelToken: cancelToken,
/// );
/// 
/// // Cancel the request if needed
/// cancelToken.cancel('User navigated away');
/// ```
class CancelToken {
  final Completer<String> _completer = Completer<String>();
  bool _isCancelled = false;
  String? _reason;

  /// Whether this token has been cancelled.
  bool get isCancelled => _isCancelled;

  /// The reason for cancellation, if any.
  String? get reason => _reason;

  /// Future that completes when the token is cancelled.
  Future<String> get future => _completer.future;

  /// Cancels the token with an optional reason.
  /// 
  /// Once cancelled, any requests using this token should be aborted.
  /// The [reason] parameter provides context for why the request was cancelled.
  void cancel([String reason = 'Request cancelled']) {
    if (!_isCancelled) {
      _isCancelled = true;
      _reason = reason;
      _completer.complete(reason);
    }
  }

  /// Throws a [ZapException] if the token has been cancelled.
  /// 
  /// This method should be called at various points during request processing
  /// to check if the operation should be aborted.
  void throwIfCancelled() {
    if (_isCancelled) {
      throw ZapException('Request cancelled: $_reason');
    }
  }
}