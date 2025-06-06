/// The provider used for HTTP operations.
/// 
/// This is used to identify the provider used for HTTP operations.
enum ZapProvider {
  /// The default provider used for IO operations.
  io,

  /// The default provider used for HTTP operations.
  http,

  /// The default provider used for Web operations.
  web,

  /// The default provider used for GraphQL operations.
  graphql,
}