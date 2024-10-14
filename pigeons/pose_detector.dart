import 'package:pigeon/pigeon.dart';
@HostApi()
abstract class PlatformPoseDetector {
  @async
  PlatformPose processImage(PlatformInputImage inputImage);

  void closeDetector();
}
class PlatformPose {
  /// A map of all the landmarks in the detected pose.
  final Map<int?, PlatformPoseLandmark?> landmarks;

  /// Constructor to create an instance of [Pose].
  PlatformPose({required this.landmarks});
}
class PlatformPoseLandmark {
  /// The landmark type.
  final int type;

  /// Gives x coordinate of landmark in image frame.
  final double x;

  /// Gives y coordinate of landmark in image frame.
  final double y;

  /// Gives z coordinate of landmark in image space.
  final double z;

  /// Gives the likelihood of this landmark being in the image frame.
  final double likelihood;

  /// Constructor to create an instance of [PoseLandmark].
  PlatformPoseLandmark({
    required this.type,
    required this.x,
    required this.y,
    required this.z,
    required this.likelihood,
  });
  // Map<String, dynamic> toJson() => {
  //   "type": type,
  //   "x": x,
  //   "y": y,
  //   "z": z,
  //   "likelihood": likelihood,
  // };
}

class PlatformInputImage {

  /// The bytes of the image.
  late List<Uint8List?> planes;
  late InputImageData inputImageData;

}
class InputImageData {
  /// Size of image.
  late int height;
  late int width;

  final int imageRotation;

  /// Format of the input image.
  final int inputImageFormat;

  /// The plane attributes to create the image buffer on iOS.
  ///
  /// Not used on Android.
  final List<InputImagePlaneMetadata?> planeData;

  /// Constructor to create an instance of [InputImageData].
  InputImageData(
      {required this.height,required this.width,
        required this.imageRotation,
        required this.inputImageFormat,
        required this.planeData});

}
class InputImagePlaneMetadata {
  /// The row stride for this color plane, in bytes.
  final int bytesPerRow;

  final int? bytesPerPixel;

  /// Height of the pixel buffer on iOS.
  final int? height;

  /// Width of the pixel buffer on iOS.
  final int? width;

  /// Constructor to create an instance of [InputImagePlaneMetadata].
  InputImagePlaneMetadata({
    required this.bytesPerRow,
    this.height,
    this.width,
    this.bytesPerPixel
  });

}