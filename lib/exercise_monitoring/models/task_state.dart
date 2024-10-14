import 'package:enum_to_string/enum_to_string.dart';

class SessionState{
  DateTime timestamp;
  TaskSessionState state;
  SessionState({required this.state, required this.timestamp});
  factory SessionState.fromJson(Map<String, dynamic> json) => SessionState(
    timestamp: DateTime.parse(json["timestamp"]),
    state: EnumToString.fromString(TaskSessionState.values,json["state"])!,
  );

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp.toIso8601String(),
    "state": EnumToString.convertToString(state),
  };
}

enum TaskSessionState{
  started,
  calibrated,
  completed,
  interrupted,
  outOfFrame,
  skipped
}