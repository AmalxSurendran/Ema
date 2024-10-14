import 'dart:convert';

import 'package:ema_v4/exercise_monitoring/models/task_state.dart';
import 'package:ema_v4/models/inMemory/task_model.dart';
import 'package:enum_to_string/enum_to_string.dart';

TaskSession taskSessionFromJson(String str) => TaskSession.fromJson(json.decode(str));

String taskSessionRequestToJson(TaskSession data) {
  return json.encode(data.toJson());
}

class TaskSession {
  TaskSession({
    this.sessionID,
    required this.duration,
    required this.framesCaptured,
    required this.states,
    required this.report,
    required this.taskState,
  });
  String? sessionID;
  int duration;
  int framesCaptured;
  List<SessionState> states;
  TaskReport report;
  TaskState taskState;

  factory TaskSession.fromJson(Map<String, dynamic> json) => TaskSession(
    sessionID: json["_id"],
    duration: json["duration"],
    framesCaptured: json["framesCaptured"],
    states: List<SessionState>.from(json["states"].map((x) => SessionState.fromJson(x))),
    report: json["report"]!=null?TaskReport.fromJson(json["report"]):TaskReport(reps: 0,sets: 0,times: 0,accuracy: 0),
    taskState: EnumToString.fromString(TaskState.values,json["taskState"])??TaskState.incomplete,
  );

  Map<String, dynamic> toJson() => {
    "duration": duration,
    "framesCaptured": framesCaptured,
    "states": List<dynamic>.from(states.map((x) => x.toJson())),
    "report": report.toJson(),
    "taskState": EnumToString.convertToString(taskState),
  };
}
