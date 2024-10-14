import 'dart:io';

import 'package:ema_v4/constants/asset_paths.dart';
import 'package:ema_v4/constants/strings.dart';
import 'package:ema_v4/exercise_monitoring/pages/exercise_monitoring/controllers/exercise_monitoring_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/ui/spacing.dart';
import '../../../models/calib_data.dart';
import '../../../widgets/pose_viewer.dart';

class CalibrationScene extends GetView<EMController> {
  const CalibrationScene({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.lateSafe.value
          ? Stack(
              alignment: Alignment.center,
              children: [
                Obx(() => controller.preparingSceneChange.isTrue
                    ? const Center()
                    : PoseDetectorView()),
                if (controller.calibData.orientation ==
                    ExerciseOrientation.standing)
                  Obx(
                    () => Row(
                      children: [
                        Container(
                            color: Colors.black.withOpacity(0.8),
                            width:
                                (Get.width * controller.calibData.poi1.startX),
                            height: Get.height,
                            child: Padding(
                              padding: allPad1,
                              child: (controller.calibData.poi1.startX >=
                                      (1 - controller.calibData.poi2.endX))
                                  ? _buildMainInstruction(true, false)
                                  : _buildSecondaryInstruction(true),
                            )),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                color: Colors.black.withOpacity(0.8),
                                height: (Get.height *
                                    controller.calibData.poi1.startY),
                              ),
                              Expanded(
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    _buildSilhouette(),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: _getBorderColor(),
                                              width: 12)),
                                      height: Get.height,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            color: _getPOI1Color(),
                                            height: (Get.height *
                                                (controller
                                                        .calibData.poi1.endY -
                                                    controller.calibData.poi1
                                                        .startY)),
                                            child: Center(
                                              child: Padding(
                                                padding: allPad1,
                                                child: _buildPOI1Instruction(),
                                              ),
                                            ),
                                          ),
                                          Container(
                                              color: _getPOI2Color(),
                                              height: (Get.height *
                                                  (controller
                                                          .calibData.poi2.endY -
                                                      controller.calibData.poi2
                                                          .startY)),
                                              child: Center(
                                                child: Padding(
                                                  padding: allPad1,
                                                  child:
                                                      _buildPOI2Instruction(),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.black.withOpacity(0.8),
                                height: (Get.height *
                                    (1 - controller.calibData.poi2.endY)),
                              )
                            ],
                          ),
                        ),
                        Container(
                            color: Colors.black.withOpacity(0.8),
                            width: (Get.width *
                                (1 - controller.calibData.poi2.endX)),
                            height: Get.height,
                            child: Padding(
                              padding: allPad1,
                              child: (controller.calibData.poi1.startX <
                                      (1 - controller.calibData.poi2.endX))
                                  ? _buildMainInstruction(false, false)
                                  : _buildSecondaryInstruction(false),
                            )),
                      ],
                    ),
                  ),
                if (controller.calibData.orientation ==
                    ExerciseOrientation.sleeping)
                  Obx(
                    () => Column(
                      children: [
                        Container(
                          color: Colors.black.withOpacity(0.8),
                          width: Get.width,
                          height:
                              (Get.height * controller.calibData.poi1.startY),
                          child: Padding(
                              padding: allPad1,
                              child: (controller.calibData.poi1.startY >=
                                      (1 - controller.calibData.poi2.endY))
                                  ? _buildMainInstruction(
                                      true,
                                      (1 - controller.calibData.poi2.endY) <
                                          0.15)
                                  : controller.calibData.poi1.startY < 0.15
                                      ? null
                                      : _buildSecondaryInstruction(true)),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                color: Colors.black.withOpacity(0.8),
                                width: (Get.width *
                                    controller.calibData.poi1.startX),
                              ),
                              Expanded(
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    _buildSilhouette(),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: _getBorderColor(),
                                              width: 12)),
                                      height: Get.height,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            color: _getPOI1Color(),
                                            width: (Get.width *
                                                (controller
                                                        .calibData.poi1.endX -
                                                    controller.calibData.poi1
                                                        .startX)),
                                            child: Center(
                                              child: Padding(
                                                padding: allPad1,
                                                child: _buildPOI1Instruction(),
                                              ),
                                            ),
                                          ),
                                          Container(
                                              color: _getPOI2Color(),
                                              width: (Get.width *
                                                  (controller
                                                          .calibData.poi2.endX -
                                                      controller.calibData.poi2
                                                          .startX)),
                                              child: Center(
                                                child: Padding(
                                                  padding: allPad1,
                                                  child:
                                                      _buildPOI2Instruction(),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.black.withOpacity(0.8),
                                width: (Get.width *
                                    (1 - controller.calibData.poi2.endX)),
                              )
                            ],
                          ),
                        ),
                        Container(
                            color: Colors.black.withOpacity(0.8),
                            width: Get.width,
                            height: Get.height *
                                (1 - controller.calibData.poi2.endY),
                            child: Padding(
                                padding: allPad1,
                                child: (controller.calibData.poi1.startY <
                                        (1 - controller.calibData.poi2.endY))
                                    ? _buildMainInstruction(false,
                                        controller.calibData.poi1.startY < 0.15)
                                    : (1 - controller.calibData.poi2.endY) <
                                            0.15
                                        ? null
                                        : _buildSecondaryInstruction(false))),
                      ],
                    ),
                  )
              ],
            )
          : const Center(
              child: SizedBox(
                  height: 50, width: 50, child: CircularProgressIndicator()),
            ),
    );
  }

  _buildSilhouette() {
    if (!controller.calibMatched.value) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.file(
          File("$pathUserDocuments/${controller.sessionController.task.exercise.identifier}$pathExerciseCalibrationSil"),
          fit: controller.calibData.orientation == ExerciseOrientation.standing
              ? BoxFit.fitHeight
              : BoxFit.fitWidth,
            color: const Color.fromRGBO(255, 255, 255, 1),
            colorBlendMode: BlendMode.modulate
        ),
      );
    }
    return const SizedBox.shrink();
  }

  _buildMainInstruction(bool onFirstSpace, bool addSecondary) {
    List<Widget> children = [];

    if (controller.isOutOfFrame.isTrue || !controller.calibMatched.value) {
      children.add(
        Text(
          controller.isOutOfFrame.isTrue
              ? "em.outOfFrame.instruction".c
              : controller.calibData.calibText,
          style: Get.textTheme.headlineMedium!
              .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
          textAlign:
              controller.calibData.orientation == ExerciseOrientation.standing
                  ? onFirstSpace
                      ? TextAlign.left
                      : TextAlign.right
                  : TextAlign.center,
        ),
      );
    }
    if (addSecondary) {
      if(controller.isOutOfFrame.isTrue){
        children.add(_buildSecondaryInstruction(onFirstSpace));
      }
    }
    if (children.isNotEmpty) {
      return Center(
        child: controller.calibData.orientation == ExerciseOrientation.sleeping
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: children,
              )
            : children.first,
      );
    }
    return const SizedBox.shrink();
  }

  _buildSecondaryInstruction(bool onFirstSpace) {
    if (controller.isOutOfFrame.isTrue) {
      List<Widget> children = [
        LottieBuilder.file(
          File('$pathUserDocuments$pathCommonBase$pathCommonLottieCaution'),
          height: 0.14 * Get.height,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.file(
              File('$pathUserDocuments$pathCommonBase$pathCommonLottieClock'),
              height: 0.1 * Get.height,
              fit: BoxFit.contain,
            ),
            horSpace2,
            Text(
              "${controller.outOfFrameTimeLeft.value}",
              style: Get.textTheme.headlineMedium!
                  .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ];
      return controller.calibData.orientation == ExerciseOrientation.sleeping
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: children,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: children,
            );
    }
    return const SizedBox.shrink();
  }

  _buildPOI1Instruction() {
    if (!controller.calibMatched.value) {
      return Text(
        "Your ${controller.calibData.poi1.name}",
        style: Get.textTheme.headlineSmall!
            .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
        textAlign: TextAlign.center,
      );
    }
  }

  _buildPOI2Instruction() {
    if (!controller.calibMatched.value) {
      return Text(
        "Your ${controller.calibData.poi2.name}",
        style: Get.textTheme.headlineSmall!
            .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
        textAlign: TextAlign.center,
      );
    }
  }

  _getBorderColor() {
    if (controller.isOutOfFrame.isFalse) {
      if (controller.calibMatched.value) {
        return calibBarGreen;
      } else {
        if(controller.poi1Calibrated.value && controller.poi2Calibrated.value){
          return calibBarYellow;
        }else{
          return calibBarBlue;
        }
      }
    } else {
      return calibBarRed;
    }
  }

  _getPOI1Color() {
    if (controller.isOutOfFrame.isFalse) {
      if (controller.poi1Calibrated.value) {
        if(controller.poseCalibrated.value){
          return calibBarGreen.withOpacity(0.6);
        }else{
          return calibBarYellow.withOpacity(0.6);
        }
      } else {
        return calibBarBlue.withOpacity(0.6);
      }
    } else {
      return calibBarRed.withOpacity(0.6);
    }
  }

  _getPOI2Color() {
    if (controller.isOutOfFrame.isFalse) {
      if (controller.poi2Calibrated.value) {
        if(controller.poseCalibrated.value){
          return calibBarGreen.withOpacity(0.6);
        }else{
          return calibBarYellow.withOpacity(0.6);
        }
      } else {
        return calibBarBlue.withOpacity(0.6);
      }
    } else {
      return calibBarRed.withOpacity(0.6);
    }
  }
}
