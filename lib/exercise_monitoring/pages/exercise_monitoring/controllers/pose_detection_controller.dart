import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:notification_center/notification_center.dart';

import '../../../../constants/broadcast_notifications.dart';
import '../../../../pigeon.dart';
import '../../../utils/filter/pose_filter.dart';
import '../../../utils/platform/input_image.dart';
import '../../../utils/ui/coordinates_translator.dart';

class PoseDetectorController extends GetxController {
  late Size absoluteImageSize;
  late InputImageRotation rotation;
  final PlatformPoseDetector _poseDetector = PlatformPoseDetector();
  bool _isBusy = false;

  final List<PoseFilter> poseFilters =
      List.generate(33, (index) => PoseFilter());

  Rxn<PlatformPose> currentNormPoseX = Rxn();

  PlatformPose applySmoothing(PlatformPose pose) {
    pose.landmarks.forEach((key, value) {
      pose.landmarks[key] = poseFilters[key!].getFilteredLandmark(value!);
    });
    return pose;
  }

  PlatformPose normalizePose(PlatformPose pose) {
    pose.landmarks.forEach((key, value) {
      if (Platform.isAndroid) {
        double originalX = pose.landmarks[key]!.x;
        pose.landmarks[key]!.x =
            normalizeX(pose.landmarks[key]!.y, rotation, absoluteImageSize);
        pose.landmarks[key]!.y =
            normalizeY(originalX, rotation, absoluteImageSize);
      } else {
        pose.landmarks[key]!.x =
            normalizeX(pose.landmarks[key]!.x, rotation, absoluteImageSize);
        pose.landmarks[key]!.y =
            normalizeY(pose.landmarks[key]!.y, rotation, absoluteImageSize);
      }
    });
    return pose;
  }

  Future<void> processImage(PlatformInputImage inputImage) async {
    if (_isBusy) return;
    _isBusy = true;
    Timeline.startSync("blaze");
    PlatformPose pose = await _poseDetector.processImage(inputImage);
    Timeline.finishSync();
    if (pose.landmarks.isNotEmpty) {
      Timeline.startSync("smoothing");
      PlatformPose smoothPose = applySmoothing(pose);
      Timeline.finishSync();
      Timeline.startSync("normalize");
      PlatformPose normPose = normalizePose(smoothPose);
      Timeline.finishSync();
      if (currentNormPoseX.value == null) {
        NotificationCenter().notify(broadcastEngineReady);
      }
      currentNormPoseX(normPose);
    }else{
      currentNormPoseX(null);
    }
    _isBusy = false;
  }
}
