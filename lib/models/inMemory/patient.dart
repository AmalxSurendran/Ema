import 'package:ema_v4/models/inMemory/user_model.dart';

import 'course.dart';

class Patient {
  Patient({
    required this.id,
    required this.nhsId,
    this.height,
    this.weight,
    required this.dob,
    required this.name,
    required this.telecom,
    required this.state,
    required this.createdOn,
    required this.lastUpdatedOn,
    required this.app,
    this.currentCourse,
  });

  String id;
  String nhsId;
  DateTime dob;
  Name name;
  Telecom telecom;
  String state;
  DateTime createdOn;
  DateTime lastUpdatedOn;
  double? height;
  double? weight;
  dynamic app;
  ProgramCourse? currentCourse;

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
      id: json["_id"],
      nhsId: json["nhsId"],
      height: json["height"] != null ? json["height"]!.toDouble() : null,
      weight: json["weight"] != null ? json["weight"]!.toDouble() : null,
      dob: DateTime.parse(json["dob"]),
      name: Name.fromJson(json["name"]),
      telecom: Telecom.fromJson(json["telecom"]),
      state: json["state"],
      createdOn: DateTime.parse(json["createdOn"]),
      lastUpdatedOn: DateTime.parse(json["lastUpdatedOn"]),
      app: json["app"],
      currentCourse: json["currentCourse"] != null ? ProgramCourse.fromJson(json["currentCourse"]) : null,
  );
}

class Telecom {
  Telecom({
    this.mobilePhone,
    this.email,
  });

  String? mobilePhone;
  String? email;

  factory Telecom.fromJson(Map<String, dynamic> json) =>
      Telecom(mobilePhone: json["mobilePhone"], email: json["email"]);
}
