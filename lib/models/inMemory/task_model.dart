// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';

import 'exercise_model.dart';

class Task {
  Task({
    required this.exerciseAttribs,
    required this.report,
    required this.id,
    required this.patient,
    required this.exercise,
    required this.dueDate,
    required this.year,
    required this.month,
    required this.dayOfMonth,
    required this.dayOfWeek,
    required this.taskState,
    required this.course,
    required this.createdOn,
    this.lastUpdated,
  });

  ExerciseAttribs exerciseAttribs;
  TaskReport report;
  String id;
  String patient;
  Exercise exercise;
  DateTime dueDate;
  int year;
  int month;
  int dayOfMonth;
  int dayOfWeek;
  TaskState taskState;
  String course;
  DateTime createdOn;
  DateTime? lastUpdated;

  Task copyWith({
    ExerciseAttribs? exerciseAttribs,
    TaskReport? report,
    String? id,
    String? patient,
    Exercise? exercise,
    DateTime? dueDate,
    int? year,
    int? month,
    int? dayOfMonth,
    int? dayOfWeek,
    TaskState? taskState,
    String? course,
    DateTime? createdOn,
    DateTime? lastUpdated,
  }) =>
      Task(
        exerciseAttribs: exerciseAttribs ?? this.exerciseAttribs,
        report: report ?? this.report,
        id: id ?? this.id,
        patient: patient ?? this.patient,
        exercise: exercise ?? this.exercise,
        dueDate: dueDate ?? this.dueDate,
        year: year ?? this.year,
        month: month ?? this.month,
        dayOfMonth: dayOfMonth ?? this.dayOfMonth,
        dayOfWeek: dayOfWeek ?? this.dayOfWeek,
        taskState: taskState ?? this.taskState,
        course: course ?? this.course,
        createdOn: createdOn ?? this.createdOn,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );

  factory Task.fromRawJson(String str) => Task.fromJson(json.decode(str));


  factory Task.fromJson(Map<String, dynamic> json) => Task(
        exerciseAttribs: ExerciseAttribs.fromJson(json["exerciseAttribs"]),
        report: TaskReport.fromJson(json["report"]),
        id: json["_id"],
        patient: json["patient"],
        exercise: Exercise.fromJson(json["exercise"]),
        dueDate: DateTime.parse(json["dueDate"]),
        year: json["year"],
        month: json["month"],
        dayOfMonth: json["dayOfMonth"],
        dayOfWeek: json["dayOfWeek"],
        taskState: EnumToString.fromString(TaskState.values,json["taskState"])??TaskState.incomplete,
        course: json["course"],
        createdOn: DateTime.parse(json["createdOn"]),
        lastUpdated: json["lastUpdated"] != null ? DateTime.parse(json["lastUpdated"]) : null,
      );

}
enum TaskState{
  incomplete,
  partial,
  complete
}


class ExerciseAttribs {
  ExerciseAttribs({
    required this.reps,
    required this.sets,
    required this.times,
  });

  final int reps;
  final int sets;
  final int times;

  ExerciseAttribs copyWith({
    int? reps,
    int? sets,
    int? times,
  }) =>
      ExerciseAttribs(
        reps: reps ?? this.reps,
        sets: sets ?? this.sets,
        times: times ?? this.times,
      );

  factory ExerciseAttribs.fromRawJson(String str) =>
      ExerciseAttribs.fromJson(json.decode(str));

  factory ExerciseAttribs.fromJson(Map<String, dynamic> json) =>
      ExerciseAttribs(
        reps: json["reps"],
        sets: json["sets"],
        times: json["times"],
      );

}

class TaskReport {
  TaskReport({
    required this.reps,
    required this.sets,
    required this.times,
    required this.accuracy,
  });

  final int reps;
  final int sets;
  final int times;
  final double accuracy;

  TaskReport copyWith({
    int? reps,
    int? sets,
    int? times,
    double? accuracy,
  }) =>
      TaskReport(
        reps: reps ?? this.reps,
        sets: sets ?? this.sets,
        times: times ?? this.times,
        accuracy: accuracy ?? this.accuracy,
      );

  factory TaskReport.fromRawJson(String str) =>
      TaskReport.fromJson(json.decode(str));

  factory TaskReport.fromJson(Map<String, dynamic> json) =>
      TaskReport(
        reps: json["reps"],
        sets: json["sets"],
        times: json["times"],
        accuracy: json["accuracy"].toDouble(),
      );
  Map<String, dynamic> toJson() => {
    "reps": reps ,
    "sets": sets,
    "times": times ,
    "accuracy": accuracy,
  };
}
