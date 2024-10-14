import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:ema_v4/exercise_monitoring/controllers/session_controller.dart';
import 'package:ema_v4/exercise_monitoring/pages/exercise_monitoring/controllers/exercise_monitoring_controller.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

import '../../../../constants/asset_paths.dart';
import '../../../../utils/hive_utils.dart';

class InstVideoScene extends StatefulWidget {
  const InstVideoScene({Key? key}) : super(key: key);

  @override
  State<InstVideoScene> createState() => _InstVideoSceneState();
}

class _InstVideoSceneState extends State<InstVideoScene> {
  late FlickManager flickManager;
  late AudioPlayer audioPlayer;
  @override
  void initState() {
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.file(
          File(
              "$pathUserDocuments/${Get.find<SessionController>().task.exercise.identifier}$pathExerciseMainVideo"),
        ),
        onVideoEnd: () {
          HiveUtils.setInstViewedStatus(Get.find<SessionController>().task.exercise.identifier,true);
          Get.find<EMController>().startSceneCalibration();
        },
        autoPlay: false
    );
    preparePlayer();
    super.initState();
  }
  preparePlayer() {
    audioPlayer = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    audioPlayer.play(DeviceFileSource("$pathUserDocuments$pathCommonBase$pathCommonLearnExercise"));
    audioPlayer.onPlayerComplete.listen((event) {
      flickManager.flickControlManager?.play();
    });
  }
  @override
  void dispose() {
    flickManager.dispose();
    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlickVideoPlayer(
      flickManager: flickManager,
      preferredDeviceOrientation: [
        Platform.isIOS
            ? DeviceOrientation.landscapeRight
            : DeviceOrientation.landscapeLeft
      ],
      flickVideoWithControls: const FlickVideoWithControls(
        controls: null,
      ),

    );
  }
}
