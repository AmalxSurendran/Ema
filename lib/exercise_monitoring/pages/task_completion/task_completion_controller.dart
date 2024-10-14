import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:ema_v4/constants/asset_paths.dart';
import 'package:ema_v4/controllers/tasks_controller.dart';
import 'package:ema_v4/exercise_monitoring/models/session_update.dart';
import 'package:ema_v4/exercise_monitoring/models/task_state.dart';
import 'package:ema_v4/exercise_monitoring/pages/exercise_monitoring/exercise_monitoring_page.dart';
import 'package:ema_v4/models/inMemory/task_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:wakelock/wakelock.dart';

import '../../constants.dart';
import '../../controllers/session_controller.dart';
import '../tilt_calibration/tilt_calib_page.dart';

class TaskCompletionController extends GetxController {
  Rxn<TaskSession> sessionSummary = Rxn();
  Rxn<Task> upcomingTask = Rxn();
  late Task currentTask;

  ValueNotifier<double> upNextTime = ValueNotifier<double>(0);
  Timer nextTaskTimer = Timer(const Duration(seconds: 0), () {});
  RxBool immersiveCountdownMode = RxBool(false);
  RxBool nextUpMode = RxBool(false);

  bool autoLoop = false;
  bool allAttempted = false;

  RxBool updateFailed = RxBool(false);

//region AUDIO PLAYERS
  List<AudioPlayer> audioPlayers = [];
  final playerResultIndex = 0;
  final playerCheerIndex = 1;
  final playerGetReadyIndex = 2;
  final playerNextUpIndex = 3;
  late Map<int, String> playerSources = {};

//endregion

  @override
  void onInit() {
    super.onInit();
    debugPrint("Task completion trace: started");
    Wakelock.enable();
    Future.delayed(const Duration(milliseconds: 100), () {
      debugPrint("Task completion trace: executing post delay");
      currentTask = Get.find<SessionController>().task;
      debugPrint("Task completion trace: found a task");
      updateTaskSession();
    });
  }

  @override
  void onClose() {
    super.onClose();
    if (!autoLoop) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      Get.find<TasksController>().clearAttemptedTasks();
      Get.delete<SessionController>(force: true);
      Wakelock.disable();
    }
    nextTaskTimer.cancel();
    _stopAllPlayers();
  }

  updateTaskSession() async {
    debugPrint("Task completion trace: trying to update task session");
    updateFailed(false);
    sessionSummary.value =
        await Get.find<SessionController>().updateTaskSession();
    if (sessionSummary.value != null) {
      await Get.delete<SessionController>(force: true);
      if (sessionSummary.value!.states.last.state ==
          TaskSessionState.completed) {
        upcomingTask.value = _getNextTask();
      }
      _playResultAudios();
      _handleNextTask(upcomingTask.value);
    } else {
      updateFailed(true);
    }
  }

  Task? _getNextTask() {
    final tc = Get.find<TasksController>();
    try {
      return tc.incompleteTasks.firstWhere((element) {
        try {
          tc.attemptedTasks.firstWhere((attempted) {
            return attempted.id == element.id;
          });
          return false;
        } catch (e) {
          return true;
        }
      });
    } catch (e) {
      allAttempted = true;
    }
    return null;
  }

  _playResultAudios() async {
    switch (sessionSummary.value!.taskState) {
      case TaskState.incomplete:
        switch (sessionSummary.value!.states.last.state) {
          case TaskSessionState.started:
          case TaskSessionState.calibrated:
          case TaskSessionState.interrupted:
            playerSources.addAll({playerResultIndex: "", playerCheerIndex: ""});
            break;
          case TaskSessionState.outOfFrame:
            playerSources.addAll({
              playerResultIndex:
                  "$pathUserDocuments$pathCommonBase$pathCommonResultOOF",
              playerCheerIndex: ""
            });
            break;
          case TaskSessionState.skipped:
            break;
          case TaskSessionState.completed:
            playerSources.addAll({
              playerResultIndex:
                  "$pathUserDocuments$pathCommonBase$pathCommonResultNoRep",
              playerCheerIndex: ""
            });
            break;
        }
        break;
      case TaskState.partial:
        playerSources.addAll({
          playerResultIndex:
              "$pathUserDocuments$pathCommonBase$pathCommonResultSilver",
          playerCheerIndex:
              "$pathUserDocuments$pathCommonBase$pathCommonCheerSilver"
        });
        break;
      case TaskState.complete:
        playerSources.addAll({
          playerResultIndex:
              "$pathUserDocuments$pathCommonBase$pathCommonResultGold",
          playerCheerIndex:
              "$pathUserDocuments$pathCommonBase$pathCommonCheerGold"
        });
        break;
    }
    if (upcomingTask.value != null) {
      playerSources.addAll({
        playerGetReadyIndex:
            "$pathUserDocuments$pathCommonBase$pathCommonGetReadyNext",
        playerNextUpIndex:
            "$pathUserDocuments/${upcomingTask.value?.exercise.identifier}$pathExerciseNextUp",
      });
    } else if (allAttempted == true) {
      playerSources.addAll({
        playerGetReadyIndex:
            "$pathUserDocuments$pathCommonBase$pathCommonAllAttempted",
        playerNextUpIndex: ""
      });
    } else {
      playerSources.addAll({playerGetReadyIndex: "", playerNextUpIndex: ""});
    }
    await _prepareAudioPlayers();

    audioPlayers[playerResultIndex].onPlayerComplete.listen((event) {
      _playPlayer(playerGetReadyIndex);
    });

    if (playerSources[playerCheerIndex]!.isNotEmpty) {
      audioPlayers[playerCheerIndex].setVolume(0.5);
      _playPlayer(playerCheerIndex);
    }
    if (playerSources.isNotEmpty) {
      _playPlayer(playerResultIndex);
    }
  }

  _prepareAudioPlayers() async {
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
  }

  _playPlayer(int playerIndex) async {
    await audioPlayers[playerIndex].stop();
    await audioPlayers[playerIndex].seek(const Duration(milliseconds: 0));
    audioPlayers[playerIndex].resume();
  }

  _stopAllPlayers() async {
    for (var element in audioPlayers) {
      await element.stop();
      await element.seek(const Duration(milliseconds: 0));
    }
  }

  skipCurrentTask() {
    Task? nextPendingTask = _getNextTask();
    if (nextPendingTask != null) {
      _handleNextTask(nextPendingTask, directStart: true);
    } else {
      Get.back();
    }
  }

  _handleNextTask(Task? nextTask, {bool directStart = false}) {
    if (nextTask != null) {
      nextTaskTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        double value = upNextTime.value;
        upNextTime.value = value + 1;
        if(upNextTime.value == restTime - 10){
          nextUpMode.value = true;
          _playPlayer(playerNextUpIndex);
        }
        if (upNextTime.value == (directStart ? 1 : (restTime - 3))) {
          immersiveCountdownMode.value = true;
        }
        if (upNextTime.value == (directStart ? 3 : restTime)) {
          _checkGyroAndContinue(nextTask);
        }
      });
    }
  }

  _checkGyroAndContinue(Task nextTask) async {
    autoLoop = true;
    bool correctTilt = false;
    late StreamSubscription<dynamic> gyroStream;
    gyroStream = accelerometerEvents.listen((event) {
      double diffY = event.y - requiredY;
      if (diffY.abs() < thresholdY) {
        // double diffZ = event.z - requiredZ;
        // if (diffZ.abs() < thresholdZ) {
        correctTilt = true;
        // }
      }
      if (correctTilt) {
        Get.put(SessionController(nextTask), permanent: true);
        Get.offNamed(ExerciseMonitoring.routeName);
      } else {
        Get.offNamed(TiltCalibPage.routeName, arguments: nextTask);
      }
      gyroStream.cancel();
    });
  }
}
