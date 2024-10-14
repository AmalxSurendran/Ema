class Name {
  Name({
    required this.given,
    this.family,
    this.preferred,
    required this.title,
  });

  String given;
  String? family;
  String? preferred;
  String title;

  factory Name.fromJson(Map<String, dynamic> json) => Name(
    given: json["given"],
    family: json["family"],
    preferred: json["preferred"],
    title: json["title"],
  );
}