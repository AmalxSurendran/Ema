import 'dart:convert';
import 'dart:io';
import 'package:ema_v4/exercise_monitoring/models/exercise_data_record.dart';
import 'package:ema_v4/exercise_monitoring/models/session_update.dart';
import 'package:ema_v4/services/apiService.dart';
import 'package:ema_v4/utils/ui/snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:notification_center/notification_center.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants/broadcast_notifications.dart';
import '../../controllers/tasks_controller.dart';
import '../../models/inMemory/task_model.dart';
import '../../pigeon.dart';
import '../models/task_state.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class SessionController extends GetxController {
  Task task;

  SessionController(this.task) {
    // task =
    //     task.copyWith(exerciseAttribs: task.exerciseAttribs.copyWith(reps: 3));
  }

  List<SessionState> states = [];
  List<PlatformPose> recordedPoints = [];
  Size absoluteImageSize = const Size(0, 0);
  int performanceDuration = 0;
  final ValueNotifier<double> repsDone = ValueNotifier<double>(0.0);
  List<List<EMTreeNodeResult>> sessionFrameLogs = [];

  String sessionID = "";
  String sessionUploadURl = "";

  @override
  void onInit() {
    states.add(SessionState(
        state: TaskSessionState.started, timestamp: _getTimestamp));
    super.onInit();
  }

  handleRepDetected() {
    repsDone.value = repsDone.value + 1;
    if (repsDone.value >= task.exerciseAttribs.reps) {
      NotificationCenter().notify(broadcastExitPerformance);
    }
  }

  updateSessionState(TaskSessionState state) {
    states.add(SessionState(state: state, timestamp: _getTimestamp));
  }

  Future<TaskSession?> updateTaskSession() async {
    TaskSession sessionUpdateRequest = TaskSession(
        duration: performanceDuration,
        framesCaptured: recordedPoints.length,
        states: states,
        report: TaskReport(
          reps: repsDone.value.toInt(),
          accuracy: 100,
          sets: 1,
          times: 1,
        ),
        taskState: _getTaskState);
    if (sessionID.isEmpty) {
      var (TaskSession? session, String? uploadUrl) =
          await ApiService().createTaskSession(sessionUpdateRequest, task.id);
      debugPrint("got upload url $uploadUrl");
      Get.find<TasksController>()
          .updateLocalTask(sessionUpdateRequest, task.id);
      if (session != null && uploadUrl != null) {
        sessionID = session.sessionID!;
        sessionUploadURl = uploadUrl;
      }
    }
    if (sessionID.isNotEmpty) {
      if (recordedPoints.isNotEmpty) {
        String pathFile = "${(await getTemporaryDirectory()).path}/$sessionID";
        File exerciseDataFile = File(pathFile);
        ExerciseDataRecord exerciseDataRecord = ExerciseDataRecord(
          recordedPoints: recordedPoints,
          imageSize: absoluteImageSize,
          startTime: states.first.timestamp,
          endTime: states.last.timestamp,
        );
        if (sessionFrameLogs.isNotEmpty) {
          exerciseDataRecord.log = sessionFrameLogs;
        }
        // print('SESSION FRAME LOGS: ${sessionFrameLogs.length}');
        exerciseDataFile
            .writeAsStringSync(jsonEncode(exerciseDataRecord.toJson()));
        if (await uploadFile(
            dataFile: exerciseDataFile, uploadURL: sessionUploadURl)) {
          return sessionUpdateRequest;
        } else {
          return null;
        }
      } else {
        return sessionUpdateRequest;
      }
    } else {
      return null;
    }
  }

  DateTime get _getTimestamp {
    return DateTime.now();
  }

  TaskState get _getTaskState {
    if (states.last.state == TaskSessionState.completed) {
      if (repsDone.value == 0) {
        return TaskState.incomplete;
      }
      if ((repsDone.value / task.exerciseAttribs.reps) >= 0.5) {
        return TaskState.complete;
      } else {
        return TaskState.partial;
      }
    } else {
      if (repsDone.value >= task.exerciseAttribs.reps) {
        return TaskState.complete;
      } else {
        return TaskState.incomplete;
      }
    }
  }

  Future<bool> uploadFile(
      {required File dataFile, required String uploadURL}) async {
    debugPrint("session data upload trace : uploading to $uploadURL");
    var postUri = Uri.parse(uploadURL);
    var request = http.MultipartRequest("PUT", postUri);
    request.headers.addAll({
      'Content-Type': 'application/json',
    });
    request.files.add(http.MultipartFile.fromBytes(
        'file', await dataFile.readAsBytes(),
        contentType: MediaType('application', 'json')));
    try {
      http.StreamedResponse response = await request.send();
      debugPrint(
          "session data upload trace : server trace is ${response.statusCode}");
      if (response.statusCode == 200) {
        return true;
      } else {
        showErrorSnackbar("Error uploading data file ${response.reasonPhrase}");
        return false;
      }
    } on FlutterError catch (e) {
      showErrorSnackbar("Error uploading data file ${e.message}");
      return false;
    }
  }
}
