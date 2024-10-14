import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:ema_v4/exercise_monitoring/pages/exercise_monitoring/exercise_monitoring_page.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:wakelock/wakelock.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../constants/asset_paths.dart';
import '../../../controllers/tasks_controller.dart';
import '../../../utils/ui/snackbars.dart';
import '../../constants.dart';
import '../../controllers/session_controller.dart';

class TiltCalibController extends GetxController {
  final RxBool checkingGyro = false.obs;
  final RxBool tiltCalibrated = false.obs;
  final RxBool isLandscape = false.obs;
  final RxDouble ballVerConstraint = 0.0.obs;

  late StreamSubscription<dynamic> gyroStream;

  double ballSize = 0, verCenter = 0;
  int lastShownWarning = DateTime.now().millisecondsSinceEpoch;
  bool canShowWarning = true;

  Timer timer = Timer(const Duration(seconds: 0), () {});
  final playerCountdownIndex = 0;
  final playerSuccessIndex = 1;
  late Map<int, String> playerSources = {
    playerCountdownIndex: "$pathUserDocuments$pathCommonBase$pathCommonCountDown3",
    playerSuccessIndex: "$pathUserDocuments$pathCommonBase$pathCommonSuccess"
  };

  List<AudioPlayer> audioPlayers = List.generate(2, (i) {
    return AudioPlayer()
      ..setReleaseMode(ReleaseMode.stop)
      ..setPlayerMode(PlayerMode.lowLatency);
  });
  bool forceClose = true;

  @override
  Future<void> onInit() async {
    SystemChrome.setPreferredOrientations([
      Platform.isIOS
          ? DeviceOrientation.landscapeRight
          : DeviceOrientation.landscapeLeft
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    if(!lazyDebug){
      VolumeController().setVolume(0.75);
    }
     Wakelock.enable();
    for(int i=0 ;i<playerSources.length;i++){
      if(playerSources[i]!.isNotEmpty){
        if (playerSources[i]!.contains(pathUserDocuments)) {
          await audioPlayers[i].setSource(DeviceFileSource(playerSources[i]!));
        } else {
          await audioPlayers[i].setSource(AssetSource(playerSources[i]!));
        }
      }
    }
    gyroStream = accelerometerEvents
        .throttle(const Duration(milliseconds: 300))
        .listen((AccelerometerEvent event) {
      double diffY = event.y - requiredY;
      if (diffY.abs() < thresholdY) {
        canShowWarning = true;
        isLandscape(true);
        if (checkingGyro.value) {
          double diffZ = event.z - requiredZ;
          double increment = (diffZ.abs() / requiredZ) * (verCenter);
          if (diffZ.abs() < thresholdZ) {
            if (!timer.isActive) {
              ballVerConstraint(verCenter);
              tiltCalibrated(true);
              audioPlayers[playerSuccessIndex].resume();
              timer= Timer.periodic(const Duration(seconds: 1), (timer) {
                if(timer.tick==1){
                    audioPlayers[playerCountdownIndex].resume();
                }
                if(timer.tick==4){
                  moveToExerciseMonitoring();

                }
              });
            }
          } else {
            _stopTimer();
            tiltCalibrated(false);
            if (diffZ > 0) {
              ballVerConstraint(min((Get.height-(ballSize/2)),verCenter + increment));
            } else {
              ballVerConstraint(max((0-(ballSize/2)),verCenter - increment));
            }
          }
        }
      } else {
        _stopTimer();
        isLandscape(false);
        if (checkingGyro.value && canShowWarning) {
          if ((DateTime.now().millisecondsSinceEpoch - lastShownWarning) >
              3000) {
            showWarningSnackbar(
                "Please ensure you are in landscape orientation");
            lastShownWarning = DateTime.now().millisecondsSinceEpoch;
            canShowWarning = false;
          }
        }
      }
    });
    super.onInit();
  }
  void _stopTimer(){
    for (var element in audioPlayers) {
      element.stop();
      element.seek(const Duration(milliseconds: 0));
    }
    if (timer.isActive) {
      timer.cancel();
    }
  }
  void refreshUI() {
    ballSize = (Get.width) / 12;
    verCenter = (Get.height / 2) - (ballSize / 2);
    ballVerConstraint(verCenter);
    checkingGyro.refresh();
  }
  moveToExerciseMonitoring(){
    forceClose = false;
    gyroStream.cancel();
    _stopTimer();
    Get.put(SessionController(Get.arguments), permanent: true);
    Get.offNamed(ExerciseMonitoring.routeName);
  }
  @override
  void onClose() {
    if (forceClose) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      Wakelock.disable();
      Get.find<TasksController>().clearAttemptedTasks();
    }
    try {
      gyroStream.cancel();
    } catch(_){}
    _stopTimer();
    super.onClose();
  }
}
