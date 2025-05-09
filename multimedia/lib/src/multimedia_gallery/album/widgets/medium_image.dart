import 'package:flutter/material.dart';
import 'package:smart/smart.dart';
import 'package:multimedia/multimedia.dart' show SelectedIndicator;

class MediumImage extends StatelessWidget {
  final IconData? icon;
  final Color? color;
  final ImageProvider image;
  final bool isSelected;
  final int selectedIndex;
  final SelectedIndicator? selectedIndicator;
  final double? imageHeight;
  final double? imageWidth;
  final BoxFit? imageFit;
  final bool showIcon;
  final Color? itemBackgroundColor;
  final double? itemWidth;
  final double? iconSize;

  const MediumImage({
    super.key,
    this.icon,
    this.color,
    required this.image,
    required this.isSelected,
    required this.selectedIndex,
    this.selectedIndicator,
    this.imageHeight,
    this.imageWidth,
    this.imageFit,
    this.showIcon = true,
    this.itemBackgroundColor,
    this.itemWidth,
    this.iconSize
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: itemBackgroundColor ?? Colors.grey[300],
      width: itemWidth ?? MediaQuery.sizeOf(context).width,
      child: Stack(
        children: [
          SizedBox(
            height: imageHeight ?? MediaQuery.sizeOf(context).height,
            width: imageWidth ?? MediaQuery.sizeOf(context).width,
            child: FadeInImage(fit: imageFit ?? BoxFit.cover, placeholder: image, image: image),
          ),
          if(isSelected) ...[
            selectedIndicator.isNotNull ? selectedIndicator!(selectedIndex.plus(1)) : Positioned(
              top: 4,
              left: 4,
              child: Badge(
                backgroundColor: color,
                textColor: Colors.white,
                label: TextBuilder(
                  text: "${selectedIndex.plus(1)}",
                  size: Sizing.font(14),
                  autoSize: false,
                ),
              )
            )
          ],
          if(showIcon) ...[
            Positioned(bottom: 2, right: 2, child: Icon(icon, size: iconSize ?? 20, color: color))
          ]
        ],
      ),
    );
  }
}
