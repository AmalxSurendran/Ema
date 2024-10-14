
class CalibData {
  POIData poi1, poi2;
  String calibText;
  int entryNode, passClass, failClass;
  ExerciseOrientation orientation;

  CalibData(
      {required this.entryNode,
      required this.passClass,
      required this.failClass,
      required this.poi1,
      required this.poi2,
      required this.calibText,
      required this.orientation});

  factory CalibData.fromJson(Map<String, dynamic> json) => CalibData(
        entryNode: json["entryNode"],
        passClass: json["passClass"],
        failClass: json["failClass"],
        calibText: json["calibText"],
        orientation: EOX.fromValue(json["orientation"]),
        poi1: POIData.fromJson(json["poi1"]),
        poi2: POIData.fromJson(json["poi2"]),
      );
}

class POIData {
  double startX, endX, startY, endY;
  String name;
  String landmark;

  POIData(
      {required this.startX,
      required this.endX,
      required this.startY,
      required this.endY,
      required this.name,
      required this.landmark});

  factory POIData.fromJson(Map<String, dynamic> json) => POIData(
        startX: json["startX"].toDouble(),
        endX: json["endX"].toDouble(),
        startY: json["startY"].toDouble(),
        endY: json["endY"].toDouble(),
        name: json["name"],
        landmark: json["landmark"],
      );
}

enum ExerciseOrientation { standing, sleeping }

extension EOX on ExerciseOrientation {
  static ExerciseOrientation fromValue(String value) {
    switch (value) {
      case "sleeping":
        return ExerciseOrientation.sleeping;
      case "standing":
        return ExerciseOrientation.standing;
      default:
        throw 'Unsupported orientation $value';
    }
  }
}
