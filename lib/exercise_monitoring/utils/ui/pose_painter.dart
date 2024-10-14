import 'package:flutter/material.dart';
import '../../../pigeon.dart';
import '../../utils/platform/pose.dart';
import 'coordinates_translator.dart';

class PosePainter extends CustomPainter {
  PosePainter(this.pose);

  final PlatformPose pose;
  final List<PoseLandmarkType> faceLandmarks = [
    PoseLandmarkType.nose,
    PoseLandmarkType.leftEyeInner,
    PoseLandmarkType.leftEye,
    PoseLandmarkType.leftEyeOuter,
    PoseLandmarkType.rightEyeInner,
    PoseLandmarkType.rightEye,
    PoseLandmarkType.rightEyeOuter,
    PoseLandmarkType.leftEar,
    PoseLandmarkType.rightEar,
    PoseLandmarkType.leftMouth,
    PoseLandmarkType.rightMouth,
  ];
  final List<PoseLandmarkType> leftLandmarks = [
    PoseLandmarkType.leftShoulder,
    PoseLandmarkType.leftElbow,
    PoseLandmarkType.leftWrist,
    PoseLandmarkType.leftPinky,
    PoseLandmarkType.leftIndex,
    PoseLandmarkType.leftThumb,
    PoseLandmarkType.leftHip,
    PoseLandmarkType.leftFootIndex,
    PoseLandmarkType.leftKnee,
    PoseLandmarkType.leftAnkle,
    PoseLandmarkType.leftHeel,
  ];
  final List<PoseLandmarkType> rightLandmarks = [
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.rightElbow,
    PoseLandmarkType.rightWrist,
    PoseLandmarkType.rightPinky,
    PoseLandmarkType.rightIndex,
    PoseLandmarkType.rightThumb,
    PoseLandmarkType.rightHip,
    PoseLandmarkType.rightFootIndex,
    PoseLandmarkType.rightKnee,
    PoseLandmarkType.rightAnkle,
    PoseLandmarkType.rightHeel,
  ];
  final List<LandmarkPair> pairs = [
    LandmarkPair(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip),
    LandmarkPair(PoseLandmarkType.leftAnkle, PoseLandmarkType.leftKnee),
    LandmarkPair(PoseLandmarkType.leftKnee, PoseLandmarkType.leftHip),
    LandmarkPair(PoseLandmarkType.rightAnkle, PoseLandmarkType.rightKnee),
    LandmarkPair(PoseLandmarkType.rightKnee, PoseLandmarkType.rightHip),
    LandmarkPair(PoseLandmarkType.leftWrist, PoseLandmarkType.leftElbow),
    LandmarkPair(PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder),
    LandmarkPair(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder),
    LandmarkPair(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow),
    LandmarkPair(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist),
    LandmarkPair(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip),
    LandmarkPair(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final skellyPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 7.0
      ..color = Colors.white;

    final leftCirclePaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 7.0
      ..color = const Color.fromARGB(255, 219, 22, 47);

    final rightCirclePaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 7.0
      ..color = const Color.fromARGB(255, 41, 51, 155);
    final faceCirclePaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 7.0
      ..color = Colors.black;

    void paintLine(
        PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
      final PlatformPoseLandmark joint1 = pose.landmarks[type1.index]!;
      final PlatformPoseLandmark joint2 = pose.landmarks[type2.index]!;
      canvas.drawLine(
          Offset(translateX(joint1.x, size), translateY(joint1.y, size)),
          Offset(translateX(joint2.x, size), translateY(joint2.y, size)),
          paintType);
    }

    // Y range = 0 to imageWidth , X range = 0 to imageHeight
    // Y runs along horizontal. So It becomes the X coordinate determiner
    // X runs along vertical. So It becomes the Y coordinate determiner

    for (var element in pairs) {
      paintLine(element.first, element.second, skellyPaint);
    }
    for (var element in leftLandmarks) {
      canvas.drawCircle(
          Offset(
            translateX(pose.landmarks[element.index]!.x, size),
            translateY(pose.landmarks[element.index]!.y, size),
          ),
          7.0,
          skellyPaint);
      canvas.drawCircle(
          Offset(
            translateX(pose.landmarks[element.index]!.x, size),
            translateY(pose.landmarks[element.index]!.y, size),
          ),
          5,
          leftCirclePaint);
    }
    for (var element in rightLandmarks) {
      canvas.drawCircle(
          Offset(
            translateX(pose.landmarks[element.index]!.x, size),
            translateY(pose.landmarks[element.index]!.y, size),
          ),
          7.0,
          skellyPaint);
      canvas.drawCircle(
          Offset(
            translateX(pose.landmarks[element.index]!.x, size),
            translateY(pose.landmarks[element.index]!.y, size),
          ),
          5,
          rightCirclePaint);
    }
    for (var element in faceLandmarks) {
      canvas.drawCircle(
          Offset(
            translateX(pose.landmarks[element.index]!.x, size),
            translateY(pose.landmarks[element.index]!.y, size),
          ),
          7.0,
          skellyPaint);
      canvas.drawCircle(
          Offset(
            translateX(pose.landmarks[element.index]!.x, size),
            translateY(pose.landmarks[element.index]!.y, size),
          ),
          5,
          faceCirclePaint);
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.pose != pose;
  }
}

class LandmarkPair {
  final PoseLandmarkType first;
  final PoseLandmarkType second;

  LandmarkPair(this.first, this.second);
}
