/// {@template zync_error_response}
/// Represents an error response from the WebSocket connection.
/// 
/// {@endtemplate}
class ZyncErrorResponse {
  /// Where the error occurred (e.g., "Connection Error", "Send Error").
  final String where;
  
  /// The actual error object or message.
  final dynamic error;
  
  /// Timestamp when the error occurred.
  final DateTime timestamp;

  /// Creates a new instance of [ZyncErrorResponse].
  /// 
  /// {@macro zync_error_response}
  ZyncErrorResponse({
    required this.where,
    required this.error,
  }) : timestamp = DateTime.now();

  Map<String, dynamic> toJson() => {
    'where': where,
    'error': error.toString(),
    'timestamp': timestamp.toIso8601String(),
  };

  @override
  String toString() => 'ZyncError[$where]: $error';
}