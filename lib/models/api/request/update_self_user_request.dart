import 'dart:convert';

class UpdateSelfUserRequest {
  UpdateSelfUserRequest({
    this.height,
    this.weight,
  });

  final double? height;
  final double? weight;

  UpdateSelfUserRequest copyWith({
    double? height,
    double? weight,
  }) =>
      UpdateSelfUserRequest(
        height: height ?? this.height,
        weight: weight ?? this.weight,
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
    "height": height,
    "weight": weight,
  };
}
