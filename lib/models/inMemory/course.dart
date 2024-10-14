// To parse this JSON data, do
//
//     final programCourse = programCourseFromJson(jsonString);

import 'dart:convert';

import 'package:ema_v4/models/inMemory/user_model.dart';

class ProgramCourse {
  ProgramCourse({
    required this.doctor,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.endedOn,
    this.endedBy,
    required this.cycles,
    required this.state,
    required this.adherence,
    required this.medicalDetails,
    required this.createdOn,
    this.lastUpdated,
    required this.program,
    required this.prescription,
  });

  Doctor doctor;
  String name;
  DateTime startDate;
  DateTime endDate;
  DateTime? endedOn;
  String? endedBy;
  int cycles;
  String state;
  Adherence adherence;
  MedicalDetails medicalDetails;
  DateTime createdOn;
  DateTime? lastUpdated;
  CourseProgram program;
  List<ProgramCoursePrescriptionItem> prescription;

  ProgramCourse copyWith({
    String? patient,
    Doctor? doctor,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? endedOn,
    String? endedBy,
    int? cycles,
    String? state,
    Adherence? adherence,
    MedicalDetails? medicalDetails,
    DateTime? createdOn,
    DateTime? lastUpdated,
    CourseProgram? program,
    List<ProgramCoursePrescriptionItem>? prescription,
  }) =>
      ProgramCourse(
        doctor: doctor ?? this.doctor,
        name: name ?? this.name,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        endedOn: endedOn ?? this.endedOn,
        endedBy: endedBy ?? this.endedBy,
        cycles: cycles ?? this.cycles,
        state: state ?? this.state,
        adherence: adherence ?? this.adherence,
        medicalDetails: medicalDetails ?? this.medicalDetails,
        createdOn: createdOn ?? this.createdOn,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        program: program ?? this.program,
        prescription: prescription ?? this.prescription,
      );

  factory ProgramCourse.fromRawJson(String str) =>
      ProgramCourse.fromJson(json.decode(str));

  factory ProgramCourse.fromJson(Map<String, dynamic> json) => ProgramCourse(
        doctor: Doctor.fromJson(json["doctor"]),
        name: json["name"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        endedOn:
            json["endedOn"] != null ? DateTime.parse(json["endedOn"]) : null,
        endedBy: json["endedBy"],
        cycles: json["cycles"],
        state: json["state"],
        adherence: Adherence.fromJson(json["adherence"]),
        medicalDetails: MedicalDetails.fromJson(json["medicalDetails"]),
        createdOn: DateTime.parse(json["createdOn"]),
        lastUpdated: json["lastUpdated"] != null
            ? DateTime.parse(json["lastUpdated"])
            : null,
        program: CourseProgram.fromJson(json["program"]),
        prescription: List<ProgramCoursePrescriptionItem>.from(
            json['prescription']
                .map((e) => ProgramCoursePrescriptionItem.fromJson(e))),
      );
}

class Adherence {
  Adherence({
    required this.totalDays,
    required this.fullyAdherentDays,
    required this.partiallyAdherentDays,
    required this.nonAdherentDays,
    required this.totalScore,
    required this.trend,
    this.previousScore,
  });

  int totalDays;
  int fullyAdherentDays;
  int partiallyAdherentDays;
  int nonAdherentDays;
  double totalScore;
  int trend;
  double? previousScore;

  Adherence copyWith({
    int? totalDays,
    int? fullyAdherentDays,
    int? partiallyAdherentDays,
    int? nonAdherentDays,
    double? totalScore,
    int? trend,
    double? previousScore,
  }) =>
      Adherence(
        totalDays: totalDays ?? this.totalDays,
        fullyAdherentDays: fullyAdherentDays ?? this.fullyAdherentDays,
        partiallyAdherentDays:
            partiallyAdherentDays ?? this.partiallyAdherentDays,
        nonAdherentDays: nonAdherentDays ?? this.nonAdherentDays,
        totalScore: totalScore ?? this.totalScore,
        trend: trend ?? this.trend,
        previousScore: previousScore ?? this.previousScore,
      );

  factory Adherence.fromRawJson(String str) =>
      Adherence.fromJson(json.decode(str));

  factory Adherence.fromJson(Map<String, dynamic> json) => Adherence(
        totalDays: json["totalDays"],
        fullyAdherentDays: json["fullyAdherentDays"],
        partiallyAdherentDays: json["partiallyAdherentDays"],
        nonAdherentDays: json["nonAdherentDays"],
        totalScore: json["totalScore"].toDouble(),
        trend: json["trend"],
        previousScore: json["previousScore"] != null
            ? json["previousScore"]!.toDouble()
            : null,
      );
}

class Doctor {
  Doctor({
    required this.id,
    required this.name,
    required this.userType,
  });

  String id;
  Name name;
  String userType;

  Doctor copyWith({
    String? id,
    Name? name,
    String? userType,
  }) =>
      Doctor(
        id: id ?? this.id,
        name: name ?? this.name,
        userType: userType ?? this.userType,
      );

  factory Doctor.fromRawJson(String str) => Doctor.fromJson(json.decode(str));

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json["_id"],
        name: Name.fromJson(json["name"]),
        userType: json["userType"],
      );
}

class MedicalDetails {
  MedicalDetails({
    required this.painRating,
  });

  final PainRating painRating;

  MedicalDetails copyWith({
    PainRating? painRating,
  }) =>
      MedicalDetails(
        painRating: painRating ?? this.painRating,
      );

  factory MedicalDetails.fromRawJson(String str) =>
      MedicalDetails.fromJson(json.decode(str));

  factory MedicalDetails.fromJson(Map<String, dynamic> json) => MedicalDetails(
        painRating: PainRating.fromJson(json["painRating"]),
      );
}

class PainRating {
  PainRating({
    required this.value,
    this.lastModified,
  });

  int value;
  DateTime? lastModified;

  PainRating copyWith({
    int? value,
    DateTime? lastModified,
  }) =>
      PainRating(
        value: value ?? this.value,
        lastModified: lastModified ?? this.lastModified,
      );

  factory PainRating.fromRawJson(String str) =>
      PainRating.fromJson(json.decode(str));

  factory PainRating.fromJson(Map<String, dynamic> json) => PainRating(
        value: json["value"],
        lastModified: json["lastModified"] != null
            ? DateTime.parse(json["lastModified"])
            : null,
      );
}

class CourseProgram {
  CourseProgram({
    required this.name,
    required this.doctor,
    required this.patient,
    required this.courses,
    required this.startDate,
    this.endDate,
    this.endedOn,
    this.endedBy,
    required this.state,
    this.currentCourse,
    required this.createdOn,
    this.lastUpdated,
  });

  String name;
  Doctor doctor;
  String patient;
  List<String> courses;
  DateTime startDate;
  DateTime? endDate;
  DateTime? endedOn;
  String? endedBy;
  String state;
  String? currentCourse;
  DateTime createdOn;
  DateTime? lastUpdated;

  CourseProgram copyWith({
    String? name,
    Doctor? doctor,
    String? patient,
    List<String>? courses,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? endedOn,
    String? endedBy,
    String? state,
    String? currentCourse,
    DateTime? createdOn,
    DateTime? lastUpdated,
  }) =>
      CourseProgram(
        name: name ?? this.name,
        doctor: doctor ?? this.doctor,
        patient: patient ?? this.patient,
        courses: courses ?? this.courses,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        endedOn: endedOn ?? this.endedOn,
        endedBy: endedBy ?? this.endedBy,
        state: state ?? this.state,
        currentCourse: currentCourse ?? this.currentCourse,
        createdOn: createdOn ?? this.createdOn,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );

  factory CourseProgram.fromRawJson(String str) =>
      CourseProgram.fromJson(json.decode(str));

  factory CourseProgram.fromJson(Map<String, dynamic> json) => CourseProgram(
        name: json["name"],
        doctor: Doctor.fromJson(json["doctor"]),
        patient: json["patient"],
        courses: List<String>.from(json["courses"].map((x) => x)),
        startDate: DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] != null ? DateTime.parse(json["endDate"]) : null,
        endedOn:
            json["endedOn"] != null ? DateTime.parse(json["endedOn"]) : null,
        endedBy: json["endedBy"],
        state: json["state"],
        currentCourse: json["currentCourse"],
        createdOn: DateTime.parse(json["createdOn"]),
        lastUpdated: json["lastUpdated"] != null
            ? DateTime.parse(json["lastUpdated"])
            : null,
      );
}

class ProgramCoursePrescriptionItem {
  ProgramCoursePrescriptionItem({
    required this.exercise,
    required this.reps,
    required this.sets,
    required this.times,
    required this.days,
  });

  final PrescriptionExercise exercise;
  final int reps;
  final int sets;
  final int times;
  final List<bool> days;

  ProgramCoursePrescriptionItem copyWith({
    PrescriptionExercise? exercise,
    int? reps,
    int? sets,
    int? times,
    List<bool>? days,
  }) =>
      ProgramCoursePrescriptionItem(
        exercise: exercise ?? this.exercise,
        reps: reps ?? this.reps,
        sets: sets ?? this.sets,
        times: times ?? this.times,
        days: days ?? this.days,
      );

  factory ProgramCoursePrescriptionItem.fromRawJson(String str) =>
      ProgramCoursePrescriptionItem.fromJson(json.decode(str));

  factory ProgramCoursePrescriptionItem.fromJson(Map<String, dynamic> json) =>
      ProgramCoursePrescriptionItem(
        exercise: PrescriptionExercise.fromJson(json["exercise"]),
        reps: json["reps"],
        sets: json["sets"],
        times: json["times"],
        days: List<bool>.from(json["days"].map((x) => x)),
      );
}

class PrescriptionExercise {
  PrescriptionExercise(
      {required this.id,
      required this.name,
      required this.identifier,
      required this.assets});

  final String id;
  final String name;
  final String identifier;
  final String assets;

  PrescriptionExercise copyWith(
          {String? id, String? name, String? identifier, String? assets}) =>
      PrescriptionExercise(
          id: id ?? this.id,
          name: name ?? this.name,
          identifier: identifier ?? this.identifier,
          assets: assets ?? this.assets);

  factory PrescriptionExercise.fromRawJson(String str) =>
      PrescriptionExercise.fromJson(json.decode(str));

  factory PrescriptionExercise.fromJson(Map<String, dynamic> json) =>
      PrescriptionExercise(
          id: json["_id"],
          name: json["name"],
          identifier: json["identifier"],
          assets: json["assets"]);
}
