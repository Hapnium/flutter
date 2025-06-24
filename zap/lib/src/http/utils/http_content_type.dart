// ignore_for_file: constant_identifier_names, non_constant_identifier_names

/// {@template http_content_type}
/// Defines standard HTTP content (MIME) types used in web communications.
///
/// These constants can be used when setting the `Content-Type` or `Accept` headers
/// in HTTP requests or responses.
///
/// Example:
/// ```dart
/// final headers = {
///   'Content-Type': HttpContentType.APPLICATION_JSON,
/// };
/// ```
/// {@endtemplate}
abstract class HttpContentType {
  /// `application/json`
  ///
  /// Standard content type for JSON-encoded request and response bodies.
  ///
  /// Commonly used in RESTful APIs.
  static const String APPLICATION_JSON = 'application/json';

  /// `application/xml`
  ///
  /// Used for XML-formatted data in APIs or document exchanges.
  static const String APPLICATION_XML = 'application/xml';

  /// `application/x-www-form-urlencoded`
  ///
  /// Standard format for submitting HTML form fields as key-value pairs.
  ///
  /// Often used with `POST` requests from web forms.
  static const String APPLICATION_FORM_URLENCODED = 'application/x-www-form-urlencoded';

  /// `multipart/form-data`
  ///
  /// Used for file uploads and mixed content (e.g., file + text fields).
  ///
  /// Required when uploading files using HTML forms.
  static const String MULTIPART_FORM_DATA = 'multipart/form-data';

  /// `multipart/form-data` with charset
  ///
  /// Required when uploading files using HTML forms.
  static String MULTIPART_FORM_DATA_WITH_CHARSET([String? charset]) => '$MULTIPART_FORM_DATA; charset=${charset ?? 'utf-8'}';

  /// `multipart/form-data` with boundary
  ///
  /// Required when uploading files using HTML forms.
  static String MULTIPARET_FORM_DATA_WITH_BOUNDARY([String? boundary]) => '$MULTIPART_FORM_DATA; boundary=${boundary ?? '----ZapClientBoundary'}';

  /// `text/plain`
  ///
  /// Plain unformatted text. Often used for simple text-based payloads.
  static const String TEXT_PLAIN = 'text/plain';

  /// `text/html`
  ///
  /// HTML documents used in web pages and emails.
  static const String TEXT_HTML = 'text/html';

  /// `text/css`
  ///
  /// Stylesheets for HTML documents.
  static const String TEXT_CSS = 'text/css';

  /// `text/javascript`
  ///
  /// Deprecated but still seen in legacy apps for JavaScript content.
  static const String TEXT_JAVASCRIPT = 'text/javascript';

  /// `application/javascript`
  ///
  /// The modern MIME type for JavaScript files.
  static const String APPLICATION_JAVASCRIPT = 'application/javascript';

  /// `application/octet-stream`
  ///
  /// Binary stream of arbitrary data. Often used for file downloads.
  ///
  /// If you don’t know the specific MIME type, use this.
  static const String APPLICATION_OCTET_STREAM = 'application/octet-stream';

  /// `application/pdf`
  ///
  /// Standard content type for PDF documents.
  static const String APPLICATION_PDF = 'application/pdf';

  /// `image/png`
  ///
  /// Portable Network Graphics image.
  static const String IMAGE_PNG = 'image/png';

  /// `image/jpeg`
  ///
  /// JPEG image format, commonly used for photographs.
  static const String IMAGE_JPEG = 'image/jpeg';

  /// `image/gif`
  ///
  /// GIF image format, often used for animations.
  static const String IMAGE_GIF = 'image/gif';

  /// `audio/mpeg`
  ///
  /// MPEG audio file, such as MP3.
  static const String AUDIO_MPEG = 'audio/mpeg';

  /// `video/mp4`
  ///
  /// MP4 video format, widely supported in browsers and devices.
  static const String VIDEO_MP4 = 'video/mp4';

  /// `video/quicktime`
  ///
  /// QuickTime video format.
  static const String VIDEO_QUICKTIME = 'video/quicktime';

  /// `form-data`
  ///
  /// Form data transfer encoding.
  static const String FORM_DATA = 'form-data';

  /// `binary`
  ///
  /// Binary transfer encoding.
  static const String BINARY = 'binary';

  /// `charset`
  ///
  /// Character encoding.
  static const String CHARSET = 'charset';

  /// `charset=utf-8`
  ///
  /// UTF-8 character encoding.
  static const String CHARSET_UTF_8 = '$CHARSET=utf-8';

  /// `application/zip`
  ///
  /// ZIP archive file format.
  static const String APPLICATION_ZIP = 'application/zip';

  /// `application/vnd.api+json`
  ///
  /// JSON:API standard content type for APIs following the JSON:API spec.
  static const String APPLICATION_JSON_API = 'application/vnd.api+json';

  /// `application/graphql`
  ///
  /// Used to submit GraphQL queries.
  static const String APPLICATION_GRAPHQL = 'application/graphql';

  /// `application/ld+json`
  ///
  /// JSON for Linked Data. Used in semantic web and schema.org annotations.
  static const String APPLICATION_JSON_LD = 'application/ld+json';

  /// `application/msword`
  ///
  /// Microsoft Word `.doc` format.
  static const String APPLICATION_MSWORD = 'application/msword';

  /// `application/vnd.openxmlformats-officedocument.wordprocessingml.document`
  ///
  /// Microsoft Word `.docx` format (Office Open XML).
  static const String APPLICATION_MSWORD_DOCX = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';

  /// `application/vnd.ms-excel`
  ///
  /// Microsoft Excel `.xls` legacy format.
  static const String APPLICATION_MSEXCEL = 'application/vnd.ms-excel';

  /// `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`
  ///
  /// Microsoft Excel `.xlsx` format.
  static const String APPLICATION_MSEXCEL_XLSX = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

  /// `application/vnd.ms-powerpoint`
  ///
  /// Microsoft PowerPoint `.ppt` legacy format.
  static const String APPLICATION_MSPOWERPOINT = 'application/vnd.ms-powerpoint';

  /// `application/vnd.openxmlformats-officedocument.presentationml.presentation`
  ///
  /// Microsoft PowerPoint `.pptx` format.
  static const String APPLICATION_MSPOWERPOINT_PPTX = 'application/vnd.openxmlformats-officedocument.presentationml.presentation';

  /// `application/x-ndjson`
  ///
  /// Newline-delimited JSON. Each line is a separate JSON object.
  ///
  /// Useful for streaming large JSON datasets.
  static const String APPLICATION_NDJSON = 'application/x-ndjson';

  /// `application/x-yaml`
  ///
  /// YAML document format.
  static const String APPLICATION_YAML = 'application/x-yaml';

  /// `application/x-tar`
  ///
  /// TAR archive format.
  static const String APPLICATION_TAR = 'application/x-tar';

  /// `application/x-www-form-urlencoded`
  ///
  /// Standard format for submitting HTML form fields as key-value pairs.
  ///
  /// Often used with `POST` requests from web forms.
  static const String APPLICATION_X_WWW_FORM_URLENCODED = 'application/x-www-form-urlencoded';
}