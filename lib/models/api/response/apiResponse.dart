import 'dart:convert';

ApiResponse apiResponseFromJson(String str) => ApiResponse.fromJson(json.decode(str));

class ApiResponse {
  ApiResponse({
    required this.type,
    required this.code,
    required this.success,
    this.data,
    this.appCode,
    this.error,
  });

  String type;
  int code;
  bool success;
  dynamic data;
  int? appCode;
  String? error;

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    type: json["type"],
    code: json["code"],
    success: json["success"],
    data: json["data"],
    appCode: json["appCode"] == null ? null : json["appCode"],
    error: json["error"] == null ? null : json["error"],
  );
}

