import 'dart:ui';

import '../../utils/platform/input_image.dart';

double translateX(
    double x,Size size) {
      return x * size.width;
}

double translateY(double y, Size size) {
  return y * size.height ;
}

double normalizeX(double x, InputImageRotation rotation, Size absoluteImageSize){
  switch (rotation) {
    case InputImageRotation.rotation90deg:
    // return size.width -
    //     x *
    //     size.width /
    //     (Platform.isIOS
    //         ? absoluteImageSize.height
    //         : absoluteImageSize.width);
    case InputImageRotation.rotation270deg:
      return x /absoluteImageSize.width;
    default:
      return x / absoluteImageSize.height;
  }
}
double normalizeY(double y, InputImageRotation rotation, Size absoluteImageSize){
  switch (rotation) {
    case InputImageRotation.rotation90deg:
    // return size.height - y *
    //     size.height /
    //     (Platform.isIOS ? absoluteImageSize.width : absoluteImageSize.height);
    case InputImageRotation.rotation270deg:
      return y /absoluteImageSize.height;
    default:
      return y / absoluteImageSize.width;
  }
}
