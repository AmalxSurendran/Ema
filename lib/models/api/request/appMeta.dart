import 'dart:convert';

String appMetaUpdateRequestToJson(AppMetaUpdateRequest data) => json.encode(data.toJson());

class AppMetaUpdateRequest {
  AppMetaUpdateRequest({
    required this.version,
    required this.build,
    required this.variant,
    required this.userPlatform,
    required this.fcmToken,
    required this.device,
  });

  String version;
  int build;
  String variant;
  String userPlatform;
  String fcmToken;
  String device;

  Map<String, dynamic> toJson() => {
    "version": version,
    "build": build,
    "variant": variant,
    "userPlatform": userPlatform,
    "fcmToken": fcmToken,
    "device": device,
  };
}