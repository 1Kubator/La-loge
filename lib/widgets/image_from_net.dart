import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import 'image_loading_animation.dart';

class ImageFromNet extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const ImageFromNet({Key key, this.imageUrl, this.width, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      imageUrl,
      height: height,
      fit: BoxFit.cover,
      width: width,
      loadStateChanged: (ExtendedImageState imageState) {
        switch (imageState.extendedImageLoadState) {
          case LoadState.loading:
            return LoadingAnimation();
            break;
          case LoadState.failed:
            return Icon(Icons.error);
            break;
          default:
            return null;
        }
      },
    );
  }
}
