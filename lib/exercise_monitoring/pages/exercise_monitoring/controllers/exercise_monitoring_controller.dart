import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:ema_v4/exercise_monitoring/controllers/session_controller.dart';
import 'package:ema_v4/exercise_monitoring/models/calib_data.dart';
import 'package:ema_v4/exercise_monitoring/models/ied.dart';
import 'package:ema_v4/exercise_monitoring/models/task_state.dart';
import 'package:ema_v4/exercise_monitoring/pages/exercise_monitoring/controllers/pose_detection_controller.dart';
import 'package:ema_v4/exercise_monitoring/pages/task_completion/task_completion_page.dart';
import 'package:ema_v4/exercise_monitoring/utils/engine/exercise_session_processor.dart';
import 'package:ema_v4/pigeon.dart';
import 'package:ema_v4/utils/hive_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:notification_center/notification_center.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../../../../constants/asset_paths.dart';
import '../../../../constants/broadcast_notifications.dart';
import '../../../../controllers/tasks_controller.dart';
import '../../../constants.dart';
import '../../../models/exercise_data_record.dart';
import '../../../utils/engine/engine_compute.dart';

import '../../../utils/engine/geometry_utils.dart';

class EMController extends GetxController {
  final poseController = Get.find<PoseDetectorController>();
  final sessionController = Get.find<SessionController>();

//region ENGINE
  late CalibData calibData;
  late ExerciseSessionProcessor processor;
  late EMTree engineTree;
  RxBool lateSafe = RxBool(false);

//endregion
//   late FlickManager flickManager;
  late StreamSubscription poseStream;
  bool forceClose = true;
  bool instructionPlayed = false;
  bool audioPlayerReady = false;
  bool playPlacementOnReady = false;
  late int singleRepDuration;

//region TIMERS
  Timer calibrationTimer = Timer(const Duration(seconds: 0), () {});
  Timer outOfFrameTimer = Timer(const Duration(seconds: 0), () {});
  Timer performanceTimer = Timer(const Duration(seconds: 0), () {});
  Timer repeatInstructionTimer = Timer(const Duration(seconds: 0), () {});

//endregion

//region AUDIO PLAYERS
  List<AudioPlayer> audioPlayers = [];
  List<List<AudioPlayer?>> instructionPlayers = [];
  final playerPlacementInstIndex = 0;
  final playerSuccessIndex = 1;
  final playerCalibStableIndex = 2;
  final playerOutOfFrameIndex = 3;
  final playerCountdown10Index = 4;
  final playerRepRewardIndex = 5;
  late Map<int, String> playerSources = {
    playerPlacementInstIndex:
        "$pathUserDocuments/${sessionController.task.exercise.identifier}$pathExercisePlacementInst",
    playerSuccessIndex: "$pathUserDocuments$pathCommonBase$pathCommonSuccess",
    playerCalibStableIndex:
        "$pathUserDocuments$pathCommonBase$pathCommonCalibrationStable",
    playerOutOfFrameIndex:
        "$pathUserDocuments$pathCommonBase$pathCommonOutOfFrame",
    playerCountdown10Index:
        "$pathUserDocuments$pathCommonBase$pathCommonCountDown10",
    playerRepRewardIndex:
        "$pathUserDocuments$pathCommonBase$pathCommonRepReward"
  };

//endregion

//region RX VARIABLES
  final RxBool _calibrated = RxBool(false);
  final RxBool isOutOfFrame = RxBool(false);
  final RxBool calibMatched = RxBool(false);
  final RxBool poi1Calibrated = RxBool(false);
  final RxBool poi2Calibrated = RxBool(false);
  final RxBool poseCalibrated = RxBool(false);
  final RxInt outOfFrameTimeLeft = RxInt(outOfFrameThresh + outOfFrameTime);
  final RxnInt currentScene = RxnInt(null);
  final RxBool preparingSceneChange = RxBool(false);
  final RxnString performSilhouettePath = RxnString();

//endregion

  @override
  Future<void> onInit() async {
    NotificationCenter().subscribe(broadcastEngineReady, () {
      if (currentScene.value != null &&
          currentScene.value == sceneCalibration &&
          isOutOfFrame.isFalse) {
        if (audioPlayerReady) {
          _playPlayer(playerPlacementInstIndex);
        } else {
          playPlacementOnReady = true;
        }
      } else if (currentScene.value != null &&
          currentScene.value == scenePerform) {
        _startPerformance();
      }
    });
    await _readIED();
    _setupPoseListener();
    await _setupAudioPlayers();
    await _setupInstructionPlayers();
    // await _setupPerformanceVideo();
    NotificationCenter().subscribe(broadcastExitPerformance, () async {
      await _stopAllInstructionPlayers();
      await _stopAllPlayers();
      sessionController.updateSessionState(TaskSessionState.completed);
      Future.delayed(const Duration(seconds: 1), () => _handleExit());
    });
    NotificationCenter().subscribe(broadcastLifecycleInactive, () {
      sessionController.updateSessionState(TaskSessionState.interrupted);
      _handleExit();
      Get.delete<EMController>();
    });
    _startSceneInstVideo();
    super.onInit();
  }

  @override
  void onClose() {
    if (forceClose) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      Wakelock.disable();
      Get.find<TasksController>().clearAttemptedTasks();
    }
    NotificationCenter().unsubscribe(broadcastEngineReady);
    NotificationCenter().unsubscribe(broadcastExitPerformance);
    NotificationCenter().unsubscribe(broadcastLifecycleInactive);
    poseStream.cancel();
    // flickManager.dispose();
    _cancelAllTimers();
    _stopAllPlayers();
    super.onClose();
  }

  _readIED() async {
    File iedFile = File(
        "$pathUserDocuments/${sessionController.task.exercise.identifier}$pathExerciseIED");
    debugPrint("IED exists? ${iedFile.existsSync()} ");
    debugPrint(
        "IED content ${jsonDecode(iedFile.readAsStringSync())["engineConfig"]} ");
    ExerciseSessionProcessor test = ExerciseSessionProcessor.fromJson(
        jsonDecode(iedFile.readAsStringSync())["engineConfig"]);
    debugPrint(
        "Engine trace : processor sequence = ${test.repSequence.toString()}");
    IED ied = IED.fromJson(jsonDecode(File(
            "$pathUserDocuments/${sessionController.task.exercise.identifier}$pathExerciseIED")
        .readAsStringSync()));
    debugPrint("Engine trace : calib failClass = ${ied.calibConfig.failClass}");
    debugPrint(
        "Engine trace : tree 1st node mode = ${ied.engine.nodes.first.decisionMode}");
    debugPrint(
        "Engine trace : processor sequence = ${ied.processor.repSequence.toString()}");
    processor = ied.processor;
    calibData = ied.calibConfig;
    engineTree = ied.engine;
    processor.onRepDetected = () {
      _playPlayer(playerRepRewardIndex);
      sessionController.handleRepDetected();
    };
    processor.goToClass = (int classID) async {
      if (sessionController.repsDone.value <
          sessionController.task.exerciseAttribs.reps) {
        debugPrint("repeat timer trace: Requesting move to class $classID");
        performSilhouettePath(
            "$pathUserDocuments/${sessionController.task.exercise.identifier}/em/$classID/1.png");
        debugPrint(
            "repeat timer trace: moving to class $classID timer is ${repeatInstructionTimer.isActive}");
        if (repeatInstructionTimer.isActive) {
          debugPrint("repeat timer trace: cancelling the timer $classID");
          repeatInstructionTimer.cancel();
        }
        _playGoToInstruction(classID);
        repeatInstructionTimer = Timer(const Duration(seconds: 8), () {
          debugPrint("repeat timer trace: repeating the timer $classID");
          processor.goToClass(classID);
        });
      }
    };
    processor.onStartHolding = (int classID) async {
      if (repeatInstructionTimer.isActive) {
        repeatInstructionTimer.cancel();
      }
      _playHoldInstruction(classID);
    };
    lateSafe(true);
  }

  _setupPoseListener() {
    poseStream = poseController.currentNormPoseX.listen((pose) {
      if (currentScene.value != null &&
          currentScene.value != sceneInstructionVideo) {
        if (_isBodyInFrame(pose)) {
          sessionController.recordedPoints.add(pose!);
          sessionController.absoluteImageSize =
              poseController.absoluteImageSize;
          _handleBodyBackInFrame();
          if (!_calibrated.value) {
            _handlePoseCalibration(pose);
          } else {
            _processFrame();
          }
        } else {
          if (pose != null) {
            sessionController.recordedPoints.add(pose);
            if (kDebugMode) {
              sessionController.absoluteImageSize =
                  poseController.absoluteImageSize;
              sessionController.sessionFrameLogs.add([]);
            }
          }
          _handleBodyOutOfFrame();
        }
      }
    });
  }

  _processFrame() async {
    List<EMTreeNodeResult> frameLogs = [];
    int currentClass = engineTree
        .process(poseController.currentNormPoseX.value!, frameLogs: frameLogs);
    debugPrint("Engine trace : Current class is $currentClass");
    debugPrint("Engine trace : Frame log $frameLogs");
    processor.add(currentClass);
    if (kDebugMode) {
      sessionController.sessionFrameLogs.add(frameLogs);
    }
  }

//region CALIBRATION
  _handlePoseCalibration(PlatformPose pose) {
    List<EMTreeNodeResult> frameLogs = [];
    List<double> poi1 = getPoint(pose, calibData.poi1.landmark).cast<double>();
    List<double> poi2 = getPoint(pose, calibData.poi2.landmark).cast<double>();
    if ((poi1[0] >= calibData.poi1.startX && poi1[0] <= calibData.poi1.endX) &&
        (poi1[1] >= calibData.poi1.startY && poi1[1] <= calibData.poi1.endY)) {
      poi1Calibrated(true);
    } else {
      poi1Calibrated(false);
    }
    if ((poi2[0] >= calibData.poi2.startX && poi2[0] <= calibData.poi2.endX) &&
        (poi2[1] >= calibData.poi2.startY && poi2[1] <= calibData.poi2.endY)) {
      poi2Calibrated(true);
    } else {
      poi2Calibrated(false);
    }
    bool pointsCalibrated = lazyDebug
        ? (poi1Calibrated.value || poi2Calibrated.value)
        : (poi1Calibrated.value && poi2Calibrated.value);
    if (pointsCalibrated) {
      int calibClassResult = engineTree.process(
          poseController.currentNormPoseX.value!,
          nodeIndex: calibData.entryNode,
          frameLogs: frameLogs);
      if (kDebugMode) {
        sessionController.sessionFrameLogs.add(frameLogs);
      }
      debugPrint(
          "Engine trace : Current calibration class is $calibClassResult with entry node is ${calibData.entryNode}");
      poseCalibrated(calibClassResult == calibData.passClass);
    } else {
      if (kDebugMode) {
        sessionController.sessionFrameLogs.add([]);
      }
      poseCalibrated(false);
    }
    _handleCalibrationValue(lazyDebug
        ? (pointsCalibrated || poseCalibrated.value)
        : (pointsCalibrated && poseCalibrated.value));
  }

  _handleCalibrationValue(bool calibrated) {
    if (calibrated) {
      if (!calibrationTimer.isActive) {
        calibMatched(true);
        _playPlayer(playerSuccessIndex);
        calibrationTimer =
            Timer(const Duration(seconds: calibrationTime + 1), () {
          _calibrated(true);
          sessionController.updateSessionState(TaskSessionState.calibrated);
          _stopCalibrationPlayers();
          _startScenePerform();
        });
        Future.delayed(const Duration(seconds: 1), () {
          if (calibMatched.value) {
            _stopPlayer(playerPlacementInstIndex);
            _playPlayer(playerCalibStableIndex);
          }
        });
      }
    } else {
      if (calibrationTimer.isActive) {
        _stopCalibrationPlayers();
        calibrationTimer.cancel();
      }
      calibMatched(false);
    }
  }

//endregion

// region OUT OF FRAME
  bool _isBodyInFrame(PlatformPose? pose) {
    int landmarksOutOfFrame = 0;
    if (pose != null) {
      pose.landmarks.forEach((key, value) {
        if (value!.x >= 0 && value.x <= 1 && value.y >= 0 && value.y <= 1) {
        } else {
          landmarksOutOfFrame++;
        }
      });
    } else {
      landmarksOutOfFrame = 33;
    }
    return (lazyDebug && pose != null) ? true : (landmarksOutOfFrame < 15);
  }

  _handleBodyOutOfFrame() {
    if (!outOfFrameTimer.isActive) {
      outOfFrameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        outOfFrameTimeLeft((outOfFrameThresh + outOfFrameTime) - timer.tick);
        if (timer.tick == outOfFrameThresh) {
          if (repeatInstructionTimer.isActive) {
            repeatInstructionTimer.cancel();
          }
          isOutOfFrame(true);
          _stopPlayer(playerPlacementInstIndex);
          _playPlayer(playerOutOfFrameIndex);
          startSceneCalibration();
          sessionController.updateSessionState(TaskSessionState.outOfFrame);
        }
        if (timer.tick == (outOfFrameThresh + outOfFrameTime) - 10) {
          _playPlayer(playerCountdown10Index);
        }
        if (timer.tick == (outOfFrameThresh + outOfFrameTime)) {
          _handleExit();
        }
      });
    }
  }

  _handleBodyBackInFrame() {
    if (outOfFrameTimer.isActive) {
      outOfFrameTimer.cancel();
      if (isOutOfFrame.isTrue) {
        _stopOutOfFramePlayers();
        isOutOfFrame(false);
        _calibrated(false);
        _playPlayer(playerPlacementInstIndex);
      }
    }
  }

//endregion

// region AUDIO PLAYER UTILS
  _setupAudioPlayers() async {
    audioPlayers = List.generate(playerSources.length, (i) {
      return AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    });
    for (int i = 0; i < playerSources.length; i++) {
      if (playerSources[i]!.isNotEmpty) {
        if (playerSources[i]!.contains(pathUserDocuments)) {
          await audioPlayers[i].setSource(DeviceFileSource(playerSources[i]!));
        } else {
          await audioPlayers[i].setSource(AssetSource(playerSources[i]!));
        }
      }
    }
    audioPlayerReady = true;
    if (playPlacementOnReady) {
      _playPlayer(playerPlacementInstIndex);
      playPlacementOnReady = false;
    }
  }

  _setupInstructionPlayers() async {
    List<int> discreteClassIDs = [];
    for (var element in processor.repSequence) {
      if (!discreteClassIDs.contains(element.classID)) {
        discreteClassIDs.add(element.classID);
      }
    }
    debugPrint("Instruction player debug: discrete ids $discreteClassIDs");
    instructionPlayers = List.generate(discreteClassIDs.length, (i) {
      return List.generate(2, (i) {
        return AudioPlayer()..setReleaseMode(ReleaseMode.stop);
      });
    });
    for (int i in discreteClassIDs) {
      for (int j = 0; j < 2; j++) {
        String path =
            "$pathUserDocuments/${sessionController.task.exercise.identifier}/em/$i/${j + 2}.mp3";
        debugPrint("Instruction player debug: path $path");
        if (File(path).existsSync()) {
          try {
            if (path.contains(pathUserDocuments)) {
              await instructionPlayers[i - 1][j]
                  ?.setSource(DeviceFileSource(path));
            } else {
              await instructionPlayers[i - 1][j]?.setSource(AssetSource(path));
            }
          } catch (e) {
            instructionPlayers[i - 1][j] = null;
          }
        } else {
          instructionPlayers[i - 1][j] = null;
        }
      }
    }
    debugPrint("Instruction player debug final players:");
    debugPrint(instructionPlayers.toString());
  }

  _playPlayer(int playerIndex) async {
    await audioPlayers[playerIndex].stop();
    await audioPlayers[playerIndex].seek(const Duration(milliseconds: 0));
    audioPlayers[playerIndex].resume();
  }

  _playGoToInstruction(int classID) async {
    debugPrint("Playing Go to instruction! for $classID");
    await _stopAllInstructionPlayers();
    await instructionPlayers[classID - 1][0]?.stop();
    await instructionPlayers[classID - 1][0]
        ?.seek(const Duration(milliseconds: 0));
    instructionPlayers[classID - 1][0]?.resume();
  }

  _playHoldInstruction(int classID) async {
    await _stopAllInstructionPlayers();
    await instructionPlayers[classID - 1][1]?.stop();
    await instructionPlayers[classID - 1][1]
        ?.seek(const Duration(milliseconds: 0));
    instructionPlayers[classID - 1][1]?.resume();
  }

  _stopPlayer(int playerIndex) async {
    await audioPlayers[playerIndex].stop();
    await audioPlayers[playerIndex].seek(const Duration(milliseconds: 0));
  }

  _stopAllPlayers() async {
    for (var element in audioPlayers) {
      await element.stop();
      await element.seek(const Duration(milliseconds: 0));
    }
  }

  _stopAllInstructionPlayers() async {
    for (var element in instructionPlayers) {
      for (var element in element) {
        await element?.stop();
      }
    }
  }

  _stopOutOfFramePlayers() async {
    _stopPlayer(playerOutOfFrameIndex);
    _stopPlayer(playerCountdown10Index);
  }

  _stopCalibrationPlayers() async {
    _stopPlayer(playerCalibStableIndex);
    _stopPlayer(playerSuccessIndex);
  }

//endregion

//region SCENE CONTROL
  startSceneCalibration() async {
    if (currentScene.value == null || currentScene.value != sceneCalibration) {
      performanceTimer.cancel();
      // flickManager.flickControlManager?.pause();
      _changeToScene(sceneCalibration);
    }
  }

  _startSceneInstVideo() {
    bool playVideo = true;
    if (instructionPlayed) {
      playVideo = false;
    } else {
      if (!(HiveUtils.getUserPreference(HiveUtils.viewInstVideo) ?? true) &&
          HiveUtils.getInstViewedStatus(
              sessionController.task.exercise.identifier)) {
        playVideo = false;
      }
    }
    if (playVideo) {
      instructionPlayed = true;
      _changeToScene(sceneInstructionVideo);
    } else {
      startSceneCalibration();
    }
  }

  _startScenePerform() async {
    if (currentScene.value != null && currentScene.value != scenePerform) {
      await _changeToScene(scenePerform);
      // flickManager.flickControlManager?.seekTo(const Duration(seconds: 0));
    }
  }

  _startPerformance() {
    // flickManager.flickControlManager?.play();
    performSilhouettePath(
        "$pathUserDocuments/${sessionController.task.exercise.identifier}/em/1/1.png");
    processor.goToClass(
        processor.repSequence[processor.expectedSequenceIndex].classID);
    performanceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      sessionController.performanceDuration++;
    });
  }

  _changeToScene(int scene) async {
    preparingSceneChange.value = true;
    await Future.delayed(
        const Duration(milliseconds: 300), () => {currentScene(scene)});
    await Future.delayed(const Duration(milliseconds: 900), () {
      poseController.currentNormPoseX.value = null;
      preparingSceneChange.value = false;
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      Wakelock.enable();
    });
  }

// endregion
//region EXIT EM
  _cancelAllTimers() {
    calibrationTimer.cancel();
    outOfFrameTimer.cancel();
    performanceTimer.cancel();
    repeatInstructionTimer.cancel();
  }

  _handleExit() {
    forceClose = false;
    performanceTimer.cancel();
    if (repeatInstructionTimer.isActive) {
      repeatInstructionTimer.cancel();
    }
    try {
      // flickManager.flickControlManager!.pause();
    } catch (_) {}
    Get.offNamed(TaskCompletionPage.routeName);
  }

  backPressed() {
    sessionController.updateSessionState(TaskSessionState.interrupted);
    _handleExit();
  }

// endregion

  _setupPerformanceVideo() async {
    VideoPlayerController videoPlayerController = VideoPlayerController.file(
      File(
          "$pathUserDocuments/${sessionController.task.exercise.identifier}$pathExerciseSingleRepVideo"),
    );
    await videoPlayerController.initialize();
    singleRepDuration =
        ((videoPlayerController.value.duration.inMilliseconds) / 1000).ceil();
    // flickManager = FlickManager(
    //   videoPlayerController: videoPlayerController,
    //   autoPlay: false,
    //   onVideoEnd: () {},
    // );
  }
//region ENGINE CALLBACKS

// endregion
}
