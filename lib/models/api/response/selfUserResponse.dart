// To parse this JSON data, do
//
//     final selfUserResponse = selfUserResponseFromJson(jsonString);

import 'package:ema_v4/models/inMemory/patient.dart';

import '../../inMemory/organisation.dart';

class SelfUserResponse {
  SelfUserResponse(
      {required this.user,
      required this.currentOrg,
      required this.additionalAssetUrls});

  Patient user;
  Organisation currentOrg;
  List<String> additionalAssetUrls;

  factory SelfUserResponse.fromJson(Map<String, dynamic> json) {
    List<String> urls = [];
    for (var element in (json["additionalAssetUrls"] as List<dynamic>)) {
      urls.add(element);
    }
    return SelfUserResponse(
      user: Patient.fromJson(json["user"]),
      currentOrg: Organisation.fromJson(json["currentOrg"]),
      additionalAssetUrls: urls,
    );
  }
}
