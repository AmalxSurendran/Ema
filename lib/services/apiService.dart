import 'dart:convert';

import 'package:ema_v4/controllers/auth_controller.dart';
import 'package:ema_v4/exercise_monitoring/models/session_update.dart';
import 'package:ema_v4/models/api/request/appMeta.dart';
import 'package:ema_v4/models/api/request/forgotPassword.dart';
import 'package:ema_v4/models/api/request/invitation.dart';
import 'package:ema_v4/models/api/request/login.dart';
import 'package:ema_v4/models/api/response/apiResponse.dart';
import 'package:ema_v4/models/api/response/selfUserResponse.dart';
import 'package:ema_v4/models/api/response/tokens.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants/api_constants.dart';
import '../models/api/request/create_feedback.dart';
import '../models/api/request/update_self_user_request.dart';
import '../models/inMemory/daily_report_model.dart';
import '../models/inMemory/task_model.dart';
import '../utils/ui/dialog.dart';
import '../utils/ui/snackbars.dart';

class ApiService {
  final AuthController authController = Get.find<AuthController>();

  Future<TokenResponse?> login(LoginRequest loginRequest) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getTokens);
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // 'Authorization': 'Bearer $token',
          },
          body: loginRequestToJson(loginRequest));
      final ApiResponse apiResponse = apiResponseFromJson(response.body);
      if (apiResponse.type == "success") {
        return TokenResponse.fromJson(apiResponse.data);
      } else {
        showApiError("Error logging in", apiResponse);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  passwordReset(PasswordResetRequest passwordResetRequest) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.forgotPassword);
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: passwordResetRequestToJson(passwordResetRequest));
      final ApiResponse apiResponse = apiResponseFromJson(response.body);
      if (apiResponse.type == "success") {
        Get.back();
        showCustomDialog(
          title: "Password recovery email sent",
          description:
              "If this email is registered with EMA, you'll receive a password reset link in this email\n\nPlease check your email for next steps",
          confirmText: "Okay",
        );
      } else {
        showApiError("Error requesting password reset", apiResponse);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<TokenResponse?> refreshTokens(String refreshToken) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.refreshTokens);
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $refreshToken',
      });
      final ApiResponse apiResponse = apiResponseFromJson(response.body);
      if (apiResponse.type == "success") {
        return TokenResponse.fromJson(apiResponse.data);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<TokenResponse?> acceptInvite(
      AcceptInviteRequest acceptInviteRequest, String inviteCode) async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.acceptInvitation(inviteCode));
      final response = await http.put(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // 'Authorization': 'Bearer $token',
          },
          body: acceptInviteRequestToJson(acceptInviteRequest));
      final ApiResponse apiResponse = apiResponseFromJson(response.body);
      if (apiResponse.type == "success") {
        return TokenResponse.fromJson(apiResponse.data);
      } else {
        showApiError("Error accepting invite", apiResponse);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<bool?> updateAppMeta(AppMetaUpdateRequest appMetaUpdateRequest) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.updateAppMeta);
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${authController.accessToken.value}',
          },
          body: appMetaUpdateRequestToJson(appMetaUpdateRequest));
      final ApiResponse apiResponse = apiResponseFromJson(response.body);
      if (apiResponse.type == "success") {
        return apiResponse.data;
      } else {
        showApiError("Error updating app meta data", apiResponse);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<SelfUserResponse?> getSelfUser() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getSelfUser);
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authController.accessToken.value}',
      });
      final ApiResponse apiResponse = apiResponseFromJson(response.body);
      if (apiResponse.type == "success") {
        return SelfUserResponse.fromJson(apiResponse.data);
      } else {
        showApiError("Error Getting self user", apiResponse);
      }
    } catch (e) {
      debugPrint("Error Getting self user ${e.toString()}");
    }
    return null;
  }

  Future<List<Task>?> getTasksForTheDay() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl +
          ApiConstants.getTasksForTheDay(
              DateFormat('yyyy-MM-dd').format(DateTime.now())));
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authController.accessToken.value}',
      });
      final ApiResponse apiResponse = apiResponseFromJson(response.body);
      if (apiResponse.type == "success") {
        return List<Task>.from(apiResponse.data.map((x) => Task.fromJson(x)));
      } else {
        showApiError("Error Getting tasks for the day:", apiResponse);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<List<DailyReport>?> getDailyReports() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getDailyReports);
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authController.accessToken.value}',
      });
      final ApiResponse apiResponse = apiResponseFromJson(response.body);
      if (apiResponse.type == "success") {
        return List<DailyReport>.from(
            apiResponse.data.map((x) => DailyReport.fromJson(x)));
      } else {
        showApiError("Error Getting tasks for the day", apiResponse);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<bool?> createFeedback(CreateFeedbackRequest request) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.createFeedback);
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${authController.accessToken.value}',
          },
          body: jsonEncode(request.toJson()));
      final ApiResponse apiResponse = apiResponseFromJson(response.body);
      if (apiResponse.type == "success") {
        return true;
      } else {
        showApiError("Error Getting tasks for the day", apiResponse);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<bool?> updateSelfUser(UpdateSelfUserRequest request) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.updateSelfUser);
      final response = await http.put(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${authController.accessToken.value}',
          },
          body: request.toRawJson());
      final ApiResponse apiResponse = apiResponseFromJson(response.body);
      if (apiResponse.type == "success") {
        return true;
      } else {
        showApiError('Error updating profile', apiResponse);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<(TaskSession?, String?)> createTaskSession(
      TaskSession sessionSummary, String taskID) async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.createTaskSession(taskID));
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authController.accessToken.value}',
        },
        body: taskSessionRequestToJson(sessionSummary),
      );
      final ApiResponse apiResponse = apiResponseFromJson(response.body);
      if (apiResponse.type == "success") {
        return (TaskSession.fromJson(apiResponse.data["session"]),apiResponse.data["dataFileUrl"] as String);
      } else {
        showApiError('Error updating profile', apiResponse);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return (null,null);
  }

  Future<bool?> logout() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.revokeTokens);
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authController.accessToken.value}',
      });
      final ApiResponse apiResponse = apiResponseFromJson(response.body);
      if (apiResponse.type == "success") {
        return true;
      } else {
        showApiError("Error logging out", apiResponse);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  showApiError(String message, ApiResponse response) {
    showErrorSnackbar('$message (${response.appCode!}): ${response.error!}');
  }
}
