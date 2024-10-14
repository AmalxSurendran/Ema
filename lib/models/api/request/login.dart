import 'dart:convert';

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
  LoginRequest({
    required this.nhsId,
    required this.password,
  });

  String nhsId;
  String password;
  String userType="Patient";

  Map<String, dynamic> toJson() => {
    "nhsId": nhsId,
    "password": password,
    "userType": userType,
  };
}