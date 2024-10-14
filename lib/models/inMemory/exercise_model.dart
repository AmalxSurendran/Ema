import 'dart:convert';

class Exercise {
  Exercise({
    required this.id,
    required this.name,
    this.info,
    required this.steps,
    required this.order,
    required this.singleRepDuration,
    required this.state,
    required this.identifier,
    required this.thumbnail,
    required this.video,
  });

  final String id;
  final String name;
  final String? info;
  final List<String> steps;
  final int order;
  final int singleRepDuration;
  final String state;
  final String identifier;
  final String thumbnail;
  final String video;

  Exercise copyWith({
    String? id,
    String? name,
    String? info,
    List<String>? steps,
    int? order,
    int? singleRepDuration,
    String? state,
    String? identifier,
    String? thumbnail,
    String? video,
  }) =>
      Exercise(
        id: id ?? this.id,
        name: name ?? this.name,
        info: info ?? this.info,
        steps: steps ?? this.steps,
        order: order ?? this.order,
        singleRepDuration: singleRepDuration ?? this.singleRepDuration,
        state: state ?? this.state,
        identifier: identifier ?? this.identifier,
        thumbnail: thumbnail ?? this.thumbnail,
        video: video ?? this.video,
      );

  factory Exercise.fromRawJson(String str) =>
      Exercise.fromJson(json.decode(str));

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json["_id"],
        name: json["name"],
        info: json["info"],
        steps: List<String>.from(json["steps"].map((x) => x)),
        order: json["order"],
        singleRepDuration: json["singleRepDuration"],
        state: json["state"],
        identifier: json["identifier"],
        thumbnail: json["thumbnail"],
        video: json["video"],
      );

}
