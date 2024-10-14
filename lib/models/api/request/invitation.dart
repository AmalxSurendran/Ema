import 'dart:convert';

AcceptInviteRequest acceptInviteRequestFromJson(String str) => AcceptInviteRequest.fromJson(json.decode(str));

String acceptInviteRequestToJson(AcceptInviteRequest data) => json.encode(data.toJson());

class AcceptInviteRequest {
  AcceptInviteRequest({
    required this.nhsId,
    required this.password,
  });

  String nhsId;
  String password;

  factory AcceptInviteRequest.fromJson(Map<String, dynamic> json) => AcceptInviteRequest(
    nhsId: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "nhsId": nhsId,
    "password": password,
  };
}