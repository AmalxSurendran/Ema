import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ema_v4/constants/colors.dart';
import 'package:ema_v4/constants/strings.dart';
import 'package:ema_v4/constants/ui/spacing.dart';
import 'package:ema_v4/exercise_monitoring/pages/task_completion/task_completion_controller.dart';
import 'package:ema_v4/models/inMemory/task_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../../constants/asset_paths.dart';
import '../../constants.dart';
import '../../models/task_state.dart';

class TaskCompletionPage extends GetView<TaskCompletionController> {
  const TaskCompletionPage({Key? key}) : super(key: key);
  static const routeName = "/taskCompletion";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => controller.sessionSummary.value != null
            ? Padding(
                padding: allPad4,
                child: controller.immersiveCountdownMode.isTrue
                    ? _getImmersiveView()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            _getTopText(),
                            style: Get.textTheme.headlineMedium!
                                .copyWith(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                if (controller.sessionSummary.value!.states.last
                                        .state ==
                                    TaskSessionState.completed)
                                  AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: _buildCenterLeft()),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 24.0, bottom: 24),
                                  child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: _buildCenterImage()),
                                ),
                                if (controller.upcomingTask.value != null)
                                  _buildCenterRight()
                              ],
                            ),
                          ),
                          Obx(() => _buildBottomText())
                        ],
                      ),
              )
            : Center(
                child: controller.updateFailed.isTrue
                    ? SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.updateTaskSession();
                          },
                          child: Text("taskCompletion.retryUpload".c),
                        ),
                      )
                    : const CircularProgressIndicator()),
      ),
    );
  }

  String _getTopText() {
    switch (controller.sessionSummary.value!.taskState) {
      case TaskState.incomplete:
        switch (controller.sessionSummary.value!.states.last.state) {
          case TaskSessionState.started:
          case TaskSessionState.calibrated:
          case TaskSessionState.interrupted:
            return "Looks like we were interrupted";
          case TaskSessionState.outOfFrame:
            return "Looks like you went out of the frame";
          case TaskSessionState.skipped:
            return "You have skipped the exercise";
          case TaskSessionState.completed:
            return "Sorry, we couldn't detect any reps.";
        }
      case TaskState.partial:
        return "Well done, you have earned a silver medal!";
      case TaskState.complete:
        return "Great job! you have earned a gold medal!";
    }
  }

  _getImmersiveView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24.0, bottom: 24),
                child: _buildCenterImage(),
              ),
            ],
          ),
        )
      ],
    );
  }

  _buildCenterRight() {
    return SimpleCircularProgressBar(
      valueNotifier: controller.upNextTime,
      maxValue: restTime.toDouble(),
      mergeMode: true,
      size: Get.textTheme.headlineLarge!.fontSize! * 4,
      progressColors: [Get.theme.colorScheme.primary],
      animationDuration: 2,
      onGetText: (double value) {
        return Text.rich(
          TextSpan(text: 'Next in\n', children: [
            TextSpan(
                text: "${restTime - value.toInt()}",
                style: TextStyle(
                  fontSize: Get.textTheme.headlineLarge!.fontSize,
                  fontWeight: FontWeight.bold,
                ))
          ]),
          style: TextStyle(
            fontSize: Get.textTheme.headlineSmall!.fontSize,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        );
      },
    );
  }

  _buildCenterImage() {
    if (controller.immersiveCountdownMode.isFalse) {
      if (controller.nextUpMode.isFalse) {
        switch (controller.sessionSummary.value!.taskState) {
          case TaskState.incomplete:
            switch (controller.sessionSummary.value!.states.last.state) {
              case TaskSessionState.started:
              case TaskSessionState.calibrated:
              case TaskSessionState.interrupted:
                return LottieBuilder.file(
                  File(
                      '$pathUserDocuments$pathCommonBase$pathCommonLottieResultInter'),
                  repeat: false,
                );
              case TaskSessionState.outOfFrame:
                return LottieBuilder.file(File(
                    '$pathUserDocuments$pathCommonBase$pathCommonLottieResultOOF'));
              case TaskSessionState.skipped:
                return LottieBuilder.file(File(
                    '$pathUserDocuments$pathCommonBase$pathCommonLottieResultSkipped'));
              case TaskSessionState.completed:
                return LottieBuilder.file(File(
                    '$pathUserDocuments$pathCommonBase$pathCommonLottieResultNoRep'));
            }
          case TaskState.partial:
            return LottieBuilder.file(
                File(
                    '$pathUserDocuments$pathCommonBase$pathCommonLottieResultSilver'),
                repeat: false);
          case TaskState.complete:
            return LottieBuilder.file(
                File(
                    '$pathUserDocuments$pathCommonBase$pathCommonLottieResultGold'),
                repeat: false);
        }
      } else {
        return AspectRatio(
          aspectRatio: 1 / 1,
          child: Image.file(
            width: Get.textTheme.headlineLarge!.fontSize! * 4,
            File(
                "$pathUserDocuments/${controller.upcomingTask.value?.exercise.identifier}$pathExerciseThumbnail"),
          ),
        );
      }
    } else {
      return DefaultTextStyle(
        style: Get.textTheme.headlineLarge!.copyWith(fontSize: 250),
        textAlign: TextAlign.center,
        child: AnimatedTextKit(
          pause: const Duration(milliseconds: 0),
          animatedTexts: [
            // ScaleAnimatedText('5',
            //     duration: const Duration(milliseconds: 1000)),
            // ScaleAnimatedText('4',
            //     duration: const Duration(milliseconds: 1000)),
            ScaleAnimatedText('3',
                duration: const Duration(milliseconds: 1000)),
            ScaleAnimatedText('2',
                duration: const Duration(milliseconds: 1000)),
            ScaleAnimatedText('1',
                duration: const Duration(milliseconds: 1000)),
          ],
          isRepeatingAnimation: false,
        ),
      );
    }
  }

  _buildCenterLeft() {
    if (controller.nextUpMode.isFalse) {
      return SimpleCircularProgressBar(
        valueNotifier: ValueNotifier<double>(
            controller.sessionSummary.value!.report.reps.toDouble()),
        maxValue: controller.currentTask.exerciseAttribs.reps.toDouble(),
        mergeMode: true,
        size: Get.textTheme.headlineLarge!.fontSize! * 4,
        progressColors: [themeGreen],
        animationDuration: 2,
        onGetText: (double value) {
          return Text.rich(
            TextSpan(text: 'Reps\n', children: [
              TextSpan(
                  text:
                      "${controller.sessionSummary.value!.report.reps} / ${controller.currentTask.exerciseAttribs.reps}",
                  style: TextStyle(
                    fontSize: Get.textTheme.headlineLarge!.fontSize,
                    fontWeight: FontWeight.bold,
                  ))
            ]),
            style: TextStyle(
              fontSize: Get.textTheme.headlineSmall!.fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          );
        },
      );
    } else {
      return SizedBox(
        width: Get.textTheme.headlineLarge!.fontSize! * 4,
        child: Text(
          "Upcoming : ${controller.upcomingTask.value?.exercise.name}",
          style: Get.textTheme.headlineMedium!
              .copyWith(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  _buildBottomText() {
    if (controller.upcomingTask.value == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text("taskCompletion.close".c),
            ),
          ),
          const SizedBox(width: 8),
          _buildSkipButton()
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  _buildSkipButton() {
    return SizedBox(
      width: 200,
      child: TextButton(
        onPressed: () {
          controller.skipCurrentTask();
        },
        child: Text("taskCompletion.skip".c),
      ),
    );
  }
}
