import 'package:linkify/linkify.dart' as linkify;

import '../link_preview_interface.dart';
import '../v1/url_linkifier.dart';

extension LinkifierExtension on LinkPreviewInterface {
  /// Returns an instance of the URL linkifier. A custom URL linkifier.
  UrlLinkifier get customUrlLinkifier => UrlLinkifier();

  /// Returns an instance of the email linkifier.
  linkify.EmailLinkifier get emailLinkifier => linkify.EmailLinkifier();

  /// Returns an instance of the phone number linkifier.
  linkify.PhoneNumberLinkifier get phoneNumberLinkifier => linkify.PhoneNumberLinkifier();

  /// Returns an instance of the user tag linkifier.
  linkify.UserTagLinkifier get userTagLinkifier => linkify.UserTagLinkifier();

  /// Returns an instance of the URL linkifier.
  linkify.UrlLinkifier get urlLinkifier => linkify.UrlLinkifier();
}