import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  CachedImage(this.path,
      {this.height, this.fit = BoxFit.fitHeight, this.width});

  final String path;
  final BoxFit fit;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 90),
      child: ExtendedImage.network(
        path,
        cache: true,
        clearMemoryCacheIfFailed: true,
        height: height,
        width: width,
        fit: fit,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.failed:
              return Text('Hata');
              break;
            case LoadState.completed:
              return ExtendedRawImage(
                image: state.extendedImageInfo?.image,
              );
            default:
              return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
