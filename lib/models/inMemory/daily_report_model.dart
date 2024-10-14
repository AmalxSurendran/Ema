import 'dart:convert';


import 'package:enum_to_string/enum_to_string.dart';

import 'task_model.dart';

class DailyReport {
  DailyReport({
    required this.id,
    required this.patient,
    required this.date,
    required this.score,
    required this.tasks,
    required this.course,
    required this.createdOn,
  });

  final String id;
  final String patient;
  final DateTime date;
  final double score;
  final List<DailyReportTask> tasks;
  final String course;
  final DateTime createdOn;

  DailyReport copyWith({
    String? id,
    String? patient,
    DateTime? date,
    double? score,
    List<DailyReportTask>? tasks,
    String? course,
    DateTime? createdOn,
  }) =>
      DailyReport(
        id: id ?? this.id,
        patient: patient ?? this.patient,
        date: date ?? this.date,
        score: score ?? this.score,
        tasks: tasks ?? this.tasks,
        course: course ?? this.course,
        createdOn: createdOn ?? this.createdOn,
      );

  factory DailyReport.fromRawJson(String str) =>
      DailyReport.fromJson(json.decode(str));

  factory DailyReport.fromJson(Map<String, dynamic> json) => DailyReport(
      id: json["_id"],
      patient: json["patient"],
      date: DateTime.parse(json["date"]),
      score: json["score"].toDouble(),
      tasks: List<DailyReportTask>.from(json["tasks"].map((x) => DailyReportTask.fromJson(x))),
      course: json["course"],
      createdOn: DateTime.parse(json["createdOn"]),
    );
}

class DailyReportTaskExercise {
  DailyReportTaskExercise({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  DailyReportTaskExercise copyWith({
    String? id,
    String? name,
  }) =>
      DailyReportTaskExercise(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory DailyReportTaskExercise.fromRawJson(String str) =>
      DailyReportTaskExercise.fromJson(json.decode(str));

  factory DailyReportTaskExercise.fromJson(Map<String, dynamic> json) => DailyReportTaskExercise(
        id: json["_id"],
        name: json["name"],
      );
}

class DailyReportTask {
  DailyReportTask({
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
  });

  final ExerciseAttribs exerciseAttribs;
  final TaskReport report;
  final String id;
  final String patient;
  final DailyReportTaskExercise exercise;
  final DateTime dueDate;
  final int year;
  final int month;
  final int dayOfMonth;
  final int dayOfWeek;
  final TaskState taskState;
  final String course;
  final DateTime createdOn;

  DailyReportTask copyWith({
    ExerciseAttribs? exerciseAttribs,
    TaskReport? report,
    String? id,
    String? patient,
    DailyReportTaskExercise? exercise,
    DateTime? dueDate,
    int? year,
    int? month,
    int? dayOfMonth,
    int? dayOfWeek,
    TaskState? taskState,
    String? course,
    String? program,
    DateTime? createdOn,
  }) =>
      DailyReportTask(
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
      );

  factory DailyReportTask.fromRawJson(String str) => DailyReportTask.fromJson(json.decode(str));

  factory DailyReportTask.fromJson(Map<String, dynamic> json) => DailyReportTask(
    exerciseAttribs: ExerciseAttribs.fromJson(json["exerciseAttribs"]),
    report: TaskReport.fromJson(json["report"]),
    id: json["_id"],
    patient: json["patient"],
    exercise: DailyReportTaskExercise.fromJson(json["exercise"]),
    dueDate: DateTime.parse(json["dueDate"]),
    year: json["year"],
    month: json["month"],
    dayOfMonth: json["dayOfMonth"],
    dayOfWeek: json["dayOfWeek"],
    taskState: EnumToString.fromString(TaskState.values, json["taskState"])??TaskState.incomplete,
    course: json["course"],
    createdOn: DateTime.parse(json["createdOn"]),
  );
}
