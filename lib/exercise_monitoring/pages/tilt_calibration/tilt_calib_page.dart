import 'dart:io';

import 'package:ema_v4/constants/asset_paths.dart';
import 'package:ema_v4/constants/colors.dart';
import 'package:ema_v4/exercise_monitoring/pages/tilt_calibration/tilt_calib_controller.dart';
import 'package:ema_v4/utils/ui/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/ui/spacing.dart';

class TiltCalibPage extends GetView<TiltCalibController> {
  const TiltCalibPage({Key? key}) : super(key: key);
  static const routeName = "/gyroCalibration";

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        controller.refreshUI();
        return Scaffold(
          body: SafeArea(
            child: Obx(
              () => Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    width:
                        (Get.width) / (controller.checkingGyro.value ? 3 : 2),
                    height: Get.height - 64,
                    left: 0,
                    child: Padding(
                      padding: pageHorOnlyPadding,
                      child: Image(
                          image: FileImage(File(controller.checkingGyro.value
                              ? "$pathUserDocuments$pathCommonBase$pathCommonGifTiltInst"
                              : "$pathUserDocuments$pathCommonBase$pathCommonGifTiltLand")),
                          fit: BoxFit.contain),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    width:
                        controller.checkingGyro.value ? ((Get.width) / 6) : 0,
                    height: Get.height - 64,
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.isLandscape.value
                            ? (controller.tiltCalibrated.value
                                ? themeGreenLight
                                : themeRedLight)
                            : themeYellowLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    width:
                        controller.checkingGyro.value ? controller.ballSize : 0,
                    height: controller.ballSize,
                    top: controller.ballVerConstraint.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.isLandscape.value
                            ? (controller.tiltCalibrated.value
                                ? themeGreen
                                : themeRed)
                            : themeYellow,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    width:
                        (Get.width) / (controller.checkingGyro.value ? 3 : 2),
                    height: Get.height - 64,
                    right: 0,
                    child: Padding(
                      padding: allPad4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              controller.checkingGyro.value
                                  ? "Tilt your phone to move the smaller circle towards the center of the bigger circle"
                                  : "Tilt your phone at an angle and place it against the wall",
                              style: Get.textTheme.headlineSmall,
                              textAlign: controller.checkingGyro.value
                                  ? TextAlign.left
                                  : TextAlign.center,
                            ),
                          ),
                          controller.checkingGyro.value
                              ? const SizedBox.shrink()
                              : Column(
                                  children: [
                                    space4,
                                    ElevatedButton(
                                        onPressed: () {
                                          if (controller.isLandscape.value) {
                                            // if(lazyDebug){
                                              controller.moveToExerciseMonitoring();
                                            // }else{
                                            //   controller.checkingGyro(true);
                                            // }
                                          } else {
                                            showWarningSnackbar(
                                                "Please ensure you are in landscape orientation");
                                          }
                                        },
                                        child: const Text("Okay")),
                                  ],
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
