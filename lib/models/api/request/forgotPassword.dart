import 'dart:convert';

String passwordResetRequestToJson(PasswordResetRequest data) => json.encode(data.toJson());

class PasswordResetRequest {
  PasswordResetRequest({
    required this.nhsId,
    required this.email,
  });

  String nhsId;
  String email;

  Map<String, dynamic> toJson() => {
    "nhsId": nhsId,
    "email": email,
  };
}