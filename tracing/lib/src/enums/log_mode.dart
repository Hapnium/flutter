// ignore_for_file: constant_identifier_names

/// The [LogMode] enum defines various levels of logging severity for debugging purposes.
///
/// This enum is used to categorize log messages based on their importance and severity,
/// helping developers filter and manage output during application development and testing.
///
/// ### Values:
///
/// - **TRACE**: 
///   - Indicates detailed information, typically of interest only when diagnosing problems. 
///   - Used for tracing the execution of the application step by step.
/// 
/// - **WARN**: 
///   - Indicates a potentially harmful situation that should be looked at. 
///   - It signals a warning but does not necessarily indicate an error.
/// 
/// - **INFO**: 
///   - Used for informational messages that highlight the progress of the application at a high level. 
///   - Typically used to log significant events that occur during execution.
/// 
/// - **ERROR**: 
///   - Indicates serious errors that prevent the application from continuing to execute. 
///   - It signals that something has gone wrong and needs immediate attention.
/// 
/// - **DEBUG**: 
///   - Provides fine-grained informational events that are useful to debug an application. 
///   - It can include variables, parameters, and specific control flow events.
/// 
/// - **FATAL**: 
///   - Indicates very severe error events that will presumably lead the application to abort. 
///   - It is the highest level of severity and represents critical failure in the application.
enum LogMode {
  TRACE,
  WARN,
  INFO,
  ERROR,
  DEBUG,
  FATAL,
}