import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:ema_v4/models/inMemory/course.dart';
import 'package:ema_v4/services/apiService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../controllers/app_controller.dart';
import '../../models/api/request/create_feedback.dart';
import '../../utils/ui/dialog.dart';
import '../../utils/ui/snackbars.dart';

class FeedbackTopic {
  final String topic;
  final String? exerciseId;

  FeedbackTopic(this.topic, this.exerciseId);

  @override
  int get hashCode => Object.hash(topic, exerciseId);

  @override
  bool operator ==(dynamic other) {
    return other is FeedbackTopic &&
        other.topic == topic &&
        other.exerciseId == exerciseId;
  }
}

class FeedbackPageController extends GetxController {
  AppController ac = Get.find();

  List<FeedbackTopic> topics = [FeedbackTopic('General', null)];

  Rx<FeedbackTopic> selectedTopic = Rx(FeedbackTopic('General', null));
  RxBool isCommentMandatory = true.obs;
  double rating = 1;
  String? exerciseId;
  String? taskId;
  String? taskSessionId;

  TextEditingController commentInputController = TextEditingController();

  @override
  void onInit() {
    selectedTopic(topics[0]);

    _populateExercisesInTopics();

    if (Get.arguments != null) {
      exerciseId = Get.arguments['exerciseId'];
      taskId = Get.arguments['taskId'];
      taskSessionId = Get.arguments['taskSessionId'];
    }

    if (exerciseId != null) {
      selectedTopic(
          topics.firstWhereOrNull((e) => e.exerciseId == exerciseId) ??
              topics[0]);
    }

    super.onInit();
  }

  _populateExercisesInTopics() {
    if (ac.patient.currentCourse != null) {
      for (ProgramCoursePrescriptionItem e
          in ac.patient.currentCourse!.prescription) {
        topics.add(FeedbackTopic(e.exercise.name, e.exercise.id));
      }
    }
  }

  onTopicSelected(FeedbackTopic? sTopic) {
    selectedTopic(sTopic);
  }

  onRatingChange(double r) {
    rating = r;

    isCommentMandatory(rating < 3);
  }

  bool _validateForm() {
    if (rating < 3 && commentInputController.text.length < 50) {
      showErrorSnackbar('Please comment on your issues more. At least 50 characters ${commentInputController.text.length}');
      return false;
    }

    return true;
  }

  onSubmitClick() async {
    if (_validateForm()) {
      showProgressDialog(message: 'Submitting feedback ...');
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String userPlatform = Platform.isAndroid ? "android" : "ios";
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      String deviceName;
      String platformVersion;
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.model != null
            ? '${androidInfo.brand} (${androidInfo.model})'
            : "unknown";
        platformVersion =
            'Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})';
      } else {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.utsname.machine ?? "unknown";
        platformVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
      }

      bool? res = await ApiService().createFeedback(CreateFeedbackRequest(
        topic: selectedTopic.value.topic,
        rating: rating,
        exerciseId: selectedTopic.value.exerciseId,
        taskId: taskId,
        taskSessionId: taskSessionId,
        environment: CreateFeedbackRequestEnvironment(
          appStage: kDebugMode?"development":"production",
          appVersion: '$version ($buildNumber)',
          device: deviceName,
          platform: userPlatform,
          platformVersion: platformVersion,
        ),
      ));

      dismissDialog();
      if (res != null) {
        Get.back();
        showSuccessSnackbar('Thank you for your feedback!');
      }
    }
  }

  @override
  void onClose() {
    commentInputController.dispose();

    super.onClose();
  }
}
