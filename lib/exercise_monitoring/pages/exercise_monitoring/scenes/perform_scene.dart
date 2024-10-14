import 'dart:io';

import 'package:ema_v4/constants/ui/spacing.dart';
import 'package:ema_v4/exercise_monitoring/pages/exercise_monitoring/controllers/exercise_monitoring_controller.dart';
import 'package:ema_v4/exercise_monitoring/widgets/pose_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../../../constants/asset_paths.dart';
import '../../../../constants/colors.dart';
import '../../../models/calib_data.dart';

class PerformScene extends GetView<EMController> {
  const PerformScene({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Obx(() => controller.preparingSceneChange.isTrue
                ? const Center()
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      PoseDetectorView(),
                      _buildPerformSilhouette(),
                    ],
                  ))),
        Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // SizedBox(
                //   width: Get.width * 0.25,
                //   child: FlickVideoPlayer(
                //     flickManager: controller.flickManager,
                //     preferredDeviceOrientation: [
                //       Platform.isIOS
                //           ? DeviceOrientation.landscapeRight
                //           : DeviceOrientation.landscapeLeft
                //     ],
                //     flickVideoWithControls: const FlickVideoWithControls(
                //       controls: null,
                //     ),
                //   ),
                // ),
                SimpleCircularProgressBar(
                  valueNotifier: controller.sessionController.repsDone,
                  size: Get.width * 0.15,
                  maxValue: controller
                      .sessionController.task.exerciseAttribs.reps
                      .toDouble(),
                  mergeMode: true,
                  progressColors: [calibBarBlue],
                  animationDuration: 2,
                  onGetText: (double value) {
                    return Text.rich(
                      TextSpan(
                        text:
                            '${value.toInt()} / ${controller.sessionController.task.exerciseAttribs.reps}\n',
                        children: <TextSpan>[
                          TextSpan(
                              text: 'reps',
                              style: TextStyle(
                                fontSize: Get.textTheme.headlineSmall!.fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                        ],
                      ),
                      style: TextStyle(
                        fontSize: Get.textTheme.headlineMedium!.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                Obx(
                  () => Opacity(
                    opacity: controller.processor.isHoldingClass.isTrue ? 1 : 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.file(
                          File(
                              '$pathUserDocuments$pathCommonBase$pathCommonLottieClock'),
                          height: 0.1 * Get.height,
                          fit: BoxFit.contain,
                        ),
                        horSpace2,
                        Text(
                          "${controller.processor.holdTimeLeft.value}",
                          style: Get.textTheme.headlineMedium!.copyWith(
                              fontWeight: FontWeight.w600, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  _buildPerformSilhouette() {
    if (controller.performSilhouettePath.value != null) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.file(File(controller.performSilhouettePath.value!),
            fit:
                controller.calibData.orientation == ExerciseOrientation.standing
                    ? BoxFit.fitHeight
                    : BoxFit.fitWidth,
            color: controller.processor.isHoldingClass.isTrue
                ? calibBarGreen.withOpacity(1)
                : const Color.fromRGBO(255, 255, 255, 1),
            colorBlendMode: BlendMode.modulate),
      );
    }
    return const SizedBox.shrink();
  }
}
