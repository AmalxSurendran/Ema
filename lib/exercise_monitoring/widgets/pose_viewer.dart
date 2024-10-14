import 'package:ema_v4/exercise_monitoring/pages/exercise_monitoring/controllers/pose_detection_controller.dart';
import 'package:ema_v4/pigeon.dart';
import 'package:flutter/material.dart';
import '../utils/platform/input_image.dart';
import 'camera_view.dart';
import '../utils/ui/pose_painter.dart';
import 'package:get/get.dart';

class PoseDetectorView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  final poseController = Get.find<PoseDetectorController>();
  bool _canProcess = true;

  @override
  void dispose() async {
    _canProcess = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    return ClipRect(
        child: Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraView(
            onImage: (inputImage) {
              poseController.absoluteImageSize = Size(
                  inputImage.inputImageData.width.toDouble(),
                  inputImage.inputImageData.height.toDouble());
              poseController.rotation = InputImageRotationValue.fromRawValue(
                  inputImage.inputImageData.imageRotation)!;
              if (!_canProcess) return;
              poseController.processImage(inputImage);
            },
          ),
          StreamBuilder<PlatformPose?>(
            stream: poseController.currentNormPoseX.stream,
            builder: (context, snapshot) {
              return snapshot.data != null
                  ? CustomPaint(painter: PosePainter(snapshot.data!))
                  : Container(
                      color: Get.theme.colorScheme.background,
                      width: Get.width,
                      height: Get.height,
                      child: const Center(
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator()),
                      ),
                    );
            },
          )
        ],
      ),
    ));
  }
}
