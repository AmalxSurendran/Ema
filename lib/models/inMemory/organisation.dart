class Organisation {
  Organisation({
    required this.id,
    required this.name,
    required this.createdOn,
    required this.state,
  });

  String id;
  String name;
  DateTime createdOn;
  String state;

  factory Organisation.fromJson(Map<String, dynamic> json) => Organisation(
    id: json["_id"],
    name: json["name"],
    createdOn: DateTime.parse(json["createdOn"]),
    state: json["state"],
  );
}