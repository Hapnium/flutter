import 'package:flutter/cupertino.dart' show IconData;
import 'package:hapnium/hapnium.dart';

import 'smart_share_item_config.dart';

/// Represents a single share item within the SmartShare widget.
///
/// This class encapsulates the data and configuration for a share item,
/// including its icon, label, URL, and styling. It also provides utility
/// methods to determine the type of share item (e.g., WhatsApp, Facebook,
/// copy link, share).
class SmartShareItem {
  /// The index of the share item within the SmartShare widget.
  final int index;

  /// The icon data for the share item.
  final IconData? icon;

  /// The asset path for an image to be used as the share item's icon.
  final String asset;

  /// The label text for the share item.
  final String label;

  /// The URL associated with the share item.
  final String url;

  /// The configuration for customizing the appearance of the share item.
  final SmartShareItemConfig? config;

  /// Creates a [SmartShareItem] instance.
  ///
  /// At least one of `icon` or `asset` must be provided to define the visual
  /// representation of the share item.
  ///
  /// **Parameters:**
  ///
  /// * `index`: The index of the share item.
  /// * `icon`: The icon data for the share item.
  /// * `asset`: The asset path for an image to be used as the share item's icon.
  /// * `label`: The label text for the share item.
  /// * `url`: The URL associated with the share item.
  /// * `config`: The configuration for customizing the appearance of the share item.
  SmartShareItem({
    required this.index,
    this.icon,
    this.asset = "",
    this.label = "",
    this.url = "",
    this.config,
  }) : assert(icon != null || asset.isNotEmpty, "You must provide an icon or an image asset for the Smart Share Item");

  /// Creates a copy of this SmartShareItem but with the given fields replaced with new values.
  SmartShareItem copyWith({
    IconData? icon,
    String? asset,
    String? label,
    String? url,
    SmartShareItemConfig? config,
  }) {
    return SmartShareItem(
      index: index,
      icon: icon ?? this.icon,
      asset: asset ?? this.asset,
      label: label ?? this.label,
      url: url ?? this.url,
      config: config ?? this.config,
    );
  }

  /// Returns the parsed URI from the share item's URL.
  Uri get uri => Uri.parse(url);

  /// Returns `true` if the share item is a link to a social media platform.
  Boolean get _isLink => isCopy.isFalse && isShare.isFalse;

  /// Returns `true` if the share item is for WhatsApp.
  bool get isWhatsApp => _isLink && uri.host.containsIgnoreCase("whatsapp");

  /// Returns `true` if the share item is for Facebook.
  bool get isFacebook => _isLink && uri.host.containsIgnoreCase("facebook");

  /// Returns `true` if the share item is for Instagram.
  bool get isInstagram => _isLink && uri.host.containsIgnoreCase("instagram");

  /// Returns `true` if the share item is for Twitter (or X).
  bool get isTwitter => _isLink && uri.host.containsIgnoreCase("twitter") || uri.host.containsIgnoreCase("x");

  /// Returns `true` if the share item is for Snapchat.
  bool get isSnapchat => _isLink && uri.scheme.equalsIgnoreCase("snapchat");

  /// Returns `true` if the share item is for copying a link.
  bool get isCopy => index.equals(0);

  /// Returns `true` if the share item is a generic share item.
  bool get isShare => isCopy.isFalse && icon.isNotNull;
}