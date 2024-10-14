// To parse this JSON data, do
//
//     final tokenResponse = tokenResponseFromJson(jsonString);

import 'dart:convert';

TokenResponse tokenResponseFromJson(String str) => TokenResponse.fromJson(json.decode(str));

String tokenResponseToJson(TokenResponse data) => json.encode(data.toJson());

class TokenResponse {
  TokenResponse({
    required this.refreshToken,
    required this.accessToken,
    required this.expiresAt,
  });

  String refreshToken;
  String accessToken;
  int expiresAt;

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
    refreshToken: json["refreshToken"],
    accessToken: json["accessToken"],
    expiresAt: json["expiresAt"],
  );

  Map<String, dynamic> toJson() => {
    "refreshToken": refreshToken,
    "accessToken": accessToken,
    "expiresAt": expiresAt,
  };
}