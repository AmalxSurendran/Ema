import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../constants/asset_paths.dart';
import '../../controllers/app_controller.dart';
import '../../models/inMemory/task_model.dart';

class TaskDetailPageController extends GetxController {

  AppController ac = Get.find();

  late FlickManager flickManager;
  late Task task;

  @override
  void onInit() {

    task = Get.arguments;

    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.file(
        File(
            "$pathUserDocuments/${task.exercise.identifier}$pathExerciseMainVideo"),
      ),
      autoPlay: false,
    );

    super.onInit();
  }

  @override
  void onClose() {
    flickManager.dispose();
    super.onClose();
  }

}
