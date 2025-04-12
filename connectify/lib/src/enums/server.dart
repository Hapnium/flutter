// ignore_for_file: constant_identifier_names

/// The [Server] enum defines the different modes in which the Connectify
/// platform can operate. This can be useful for configuring environment-specific
/// behaviors, API endpoints, and features.
/// 
/// The available modes are:
/// 
/// - **PRODUCTION**: This mode represents the live production environment. 
///   It is used for real users and real transactions. This mode should be used
///   when the application is fully deployed and running in a live environment.
/// 
/// - **SANDBOX**: This is a testing environment that simulates production behavior 
///   but without real-world consequences (e.g., no real transactions are made).
///   Typically used for QA, testing, and developer purposes.
/// 
/// - **PORTAL**: This mode is intended for administrative interfaces, such as 
///   dashboards or management portals, where access and functionality might differ
///   from regular user environments.
enum Server {
  /// Represents the live production environment.
  PRODUCTION,

  /// Represents the sandbox environment for testing without real effects.
  SANDBOX,

  /// Represents the administrative portal environment.
  PORTAL
}