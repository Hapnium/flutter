import 'package:flutter/material.dart';
import 'package:multimedia/multimedia.dart';
import 'package:smart/smart.dart';

class AlbumInformation extends StatelessWidget {
  final Album album;
  final Color? newestColor;
  final Color? oldestColor;
  final Color? infoColor;
  final double? infoSize;
  final EdgeInsetsGeometry? infoPadding;
  final BorderRadiusGeometry? infoRadius;

  const AlbumInformation({
    super.key,
    required this.album,
    this.newestColor,
    this.oldestColor,
    this.infoColor,
    this.infoSize,
    this.infoPadding,
    this.infoRadius
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: infoPadding ?? EdgeInsets.only(top: 4, bottom: 2, left: 4, right: 4),
      decoration: BoxDecoration(
        color: album.newest ? (newestColor ?? Colors.blue) : (oldestColor ?? Colors.red),
        borderRadius: infoRadius ?? BorderRadius.circular(4)
      ),
      child: TextBuilder(
        text: album.newest ? "NEWEST" : "OLDEST",
        size: infoSize ?? 9,
        autoSize: false,
        color: infoColor ?? Colors.white,
        flow: TextOverflow.ellipsis,
      ),
    );
  }
}