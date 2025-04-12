class PemDelimiter {
  // General PEM delimiters
  static const BEGIN_PUBLIC_KEY = "-----BEGIN PUBLIC KEY-----";
  static const END_PUBLIC_KEY = "-----END PUBLIC KEY-----";
  static const BEGIN_PRIVATE_KEY = "-----BEGIN PRIVATE KEY-----";
  static const END_PRIVATE_KEY = "-----END PRIVATE KEY-----";

  // RSA PEM delimiters
  static const BEGIN_PUBLIC_RSA_KEY = "-----BEGIN RSA PUBLIC KEY-----";
  static const END_PUBLIC_RSA_KEY = "-----END RSA PUBLIC KEY-----";
  static const BEGIN_PRIVATE_RSA_KEY = "-----BEGIN RSA PRIVATE KEY-----";
  static const END_PRIVATE_RSA_KEY = "-----END RSA PRIVATE KEY-----";

  // EC PEM delimiters
  static const BEGIN_PUBLIC_EC_KEY = "-----BEGIN EC PUBLIC KEY-----";
  static const END_PUBLIC_EC_KEY = "-----END EC PUBLIC KEY-----";
  static const BEGIN_PRIVATE_EC_KEY = "-----BEGIN EC PRIVATE KEY-----";
  static const END_PRIVATE_EC_KEY = "-----END EC PRIVATE KEY-----";
}