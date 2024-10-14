import 'dart:math';

import 'package:ema_v4/exercise_monitoring/pages/exercise_monitoring/controllers/exercise_monitoring_controller.dart';
import 'package:ema_v4/exercise_monitoring/pages/exercise_monitoring/scenes/calibration_scene.dart';
import 'package:ema_v4/exercise_monitoring/pages/exercise_monitoring/scenes/instruction_scene.dart';
import 'package:ema_v4/exercise_monitoring/pages/exercise_monitoring/scenes/perform_scene.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class ExerciseMonitoring extends GetView<EMController> {
  const ExerciseMonitoring({Key? key}) : super(key: key);
  static const routeName = "/exerciseMonitoring";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        controller.backPressed();
        return Future.value(false);
      },
      child: Scaffold(
        body: Obx(() => AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: __transitionBuilder,
              child: _buildScene(controller.currentScene.value),
              switchInCurve: Curves.easeInBack,
              switchOutCurve: Curves.easeInBack.flipped,
            )),
      ),
    );
  }

  _buildScene(int? currentScene) {
    if(currentScene != null){
      switch (currentScene) {
        case sceneCalibration:
          return const CalibrationScene();
        case sceneInstructionVideo:
          return const InstVideoScene();
        case scenePerform:
          return const PerformScene();
        default:
          return const SizedBox.shrink();
      }
    }else{
      return const SizedBox.shrink();
    }
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= -1.0;
        final value = min(rotateAnim.value, pi / 2);
        return Transform(
          transform: (Matrix4.rotationY(value)..setEntry(3, 0, tilt)),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }
}
