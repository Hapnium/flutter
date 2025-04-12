import 'package:dio/dio.dart' show CancelToken;

/// An abstract service interface for managing tokens and their cancellation.
///
/// This interface defines a contract for services that handle tokens,
/// particularly in scenarios where asynchronous operations or subscriptions
/// need to be cancelled.
abstract class TokenManagerService {
  CancelToken getToken();

  /// Cancels all active tokens or operations managed by this service.
  ///
  /// This method is used to terminate any ongoing asynchronous tasks or
  /// subscriptions associated with the tokens managed by this service.
  ///
  /// Implementations should ensure that calling this method safely cancels
  /// all relevant operations and releases any associated resources.
  void cancelAll();
}