
import 'dart:io';
import 'package:ema_v4/constants/preferences.dart';
import 'package:ema_v4/constants/strings.dart';
import 'package:ema_v4/constants/ui/durations.dart';
import 'package:ema_v4/pages/permissions/widgets/permission_item.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

import '../../../controllers/app_controller.dart';
import '../../../utils/ui/dialog.dart';

class PermissionsPageController extends GetxController {
  late PageController pageController = PageController();
  late final SharedPreferences _prefs;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  List<PermissionItem> pageItems = [];

  int pageIndex = 0;
  RxString buttonText = RxString("");
  RxString skipButtonText = RxString("");

  static Future<bool> requiresAnyPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_requiresAppTour(prefs)) {
      return true;
    }
    if (await _requiresCameraPage(prefs)) {
      return true;
    }
    if (await _requiresNotificationsPage(prefs, messaging)) {
      return true;
    }
    if (await _requiresBiometricsPage(prefs)) {
      return true;
    }
    return false;
  }

  static bool _requiresAppTour(SharedPreferences prefs){
    return !(prefs.getBool(PreferenceKey.appTourDone) ?? false);
  }
  static Future<bool> _requiresCameraPage(SharedPreferences prefs) async {
    var status = await Permission.camera.status;
    return !status.isGranted;
  }
  static Future<bool> _requiresNotificationsPage(SharedPreferences prefs,FirebaseMessaging messaging) async{
    NotificationSettings settings = await messaging.getNotificationSettings();
    return !(settings.authorizationStatus == AuthorizationStatus.authorized ||
        (prefs.getBool(PreferenceKey.notificationsRequested) ?? false));
  }
  static Future<bool> _requiresBiometricsPage(SharedPreferences prefs) async{
    return !((prefs.getBool(PreferenceKey.biometricRequested) ?? false) ||
        (prefs.getBool(PreferenceKey.biometricEnabled) ?? false));
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
    if (_requiresAppTour(_prefs)) {
      pageItems.add(const PermissionItem(
        headingString: "permissions.page.intro.heading",
        descriptionString: "permissions.page.intro.desc",
        assetPath: "assets/images/permissions/Welcome.svg",
        identifier: "intro",
      ));
    }
    if (await _requiresNotificationsPage(_prefs, messaging)) {
      pageItems.add(const PermissionItem(
        headingString: "permissions.page.notifications.heading",
        descriptionString: "permissions.page.notifications.desc",
        assetPath: "assets/images/permissions/Notifications.svg",
        identifier: "notifications",
      ));
    }
    if (await _requiresCameraPage(_prefs)) {
      pageItems.add(const PermissionItem(
        headingString: "permissions.page.em.heading",
        descriptionString: "permissions.page.em.desc",
        assetPath: "assets/images/permissions/Camera.svg",
        identifier: "camera",
      ));
    }
    if (await _requiresBiometricsPage(_prefs)) {
      pageItems.add(const PermissionItem(
        headingString: "permissions.page.biometric.heading",
        descriptionString: "permissions.page.biometric.desc",
        assetPath: "assets/images/permissions/Biometric.svg",
        identifier: "biometric",
      ));
    }
    refreshButtonTexts();
  }

  onButtonTap() async {
    switch (pageItems[pageIndex].identifier) {
      case "camera":
        var status = await Permission.camera.request();
        if (status.isGranted) {
          moveToNextPage();
        } else {
          if (status.isPermanentlyDenied) {
            showCustomDialog(
              title: "permissions.page.dialog.camera.title".c,
              description:
                  "permissions.page.dialog.camera.open.settings".c,
              confirmText: "permissions.page.open.settings".c,
              onConfirm: () {
                openAppSettings();
              },
            );
          } else {
            showCustomDialog(
              title: "permissions.page.dialog.camera.title".c,
              description:
                  "permissions.page.dialog.camera.try.again".c,
              confirmText: "permissions.page.dialog.camera.try.again.confirm".c,
              onConfirm: () {
                onButtonTap();
              },
            );
          }
        }
        break;
      case "notifications":
          NotificationSettings settings = await messaging.requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );
          //Comment below line if you do not want to annoy user until "Do not ask again" is tapped.
          //if below is commented, only way to stop this prompt is with "Do not ask again" or Accepting.
          // _prefs.setBool(PreferenceKey.notificationsRequested, true);
          if (settings.authorizationStatus == AuthorizationStatus.denied) {
            showCustomDialog(
                title: "permissions.page.dialog.notifications.title".c,
                description:
                "permissions.page.dialog.notifications.open.settings".c,
                confirmText: "permissions.page.open.settings".c,
                onConfirm: () {
                  openAppSettings();
                },
                cancelText: skipButtonText.value.c,
                onCancel: () {
                  moveToNextPage();
                });
          } else {
            moveToNextPage();
          }
        break;
      case "biometric":
        final LocalAuthentication auth = LocalAuthentication();
        try {
          final bool didAuthenticate = await auth.authenticate(
              localizedReason: 'permissions.page.biometric.reason'.c,
              options: const AuthenticationOptions(biometricOnly: true));
          if (didAuthenticate) {
            _prefs.setBool(PreferenceKey.biometricEnabled, true);
            //Comment below line if you want to prompt biometric dialog if user disables it from settings.
            //if below is commented, only way to stop this prompt is with "Do not ask again" or Enrollment.
            _prefs.setBool(PreferenceKey.biometricRequested, true);
            moveToNextPage();
          } else {
            showCustomDialog(
                title: "permissions.page.dialog.biometric.title".c,
                description:
                    "permissions.page.dialog.biometric.try.again".c,
                confirmText: "permissions.page.dialog.biometric.try.again.confirm".c,
                cancelText: skipButtonText.value.c,
                onConfirm: () {
                  onButtonTap();
                },
                onCancel: () {
                  moveToNextPage();
                });
          }
        } on PlatformException catch (e) {
          if (e.code == auth_error.notEnrolled) {
            // Add handling of no hardware here.
          } else if (e.code == auth_error.lockedOut ||
              e.code == auth_error.permanentlyLockedOut) {
            // ...
          } else {
            // ...
          }
          showCustomDialog(
            title: "permissions.page.dialog.biometric.title".c,
            description:
                "permissions.page.dialog.biometric.no.support".c,
            confirmText: "permissions.page.dialog.biometric.no.support.confirm".c,
            onConfirm: () {
              neverAskMoveToNextPage();
            },
          );
        }
        break;
      default:
        moveToNextPage();
    }
  }

  refreshButtonTexts() {
    switch (pageItems[pageIndex].identifier) {
      case "intro":
        buttonText.value = "permissions.page.begin.text";
        skipButtonText.value = "";
        break;
      case "camera":
        buttonText.value = "permissions.page.grant.permission.text";
        skipButtonText.value = "";
        break;
      case "notifications":
        buttonText.value = "permissions.page.grant.permission.text";
        if(Platform.isIOS) {
          skipButtonText.value = "permissions.page.later.permission.text";
        }else{
          skipButtonText.value = "";
        }
        break;
      case "biometric":
        buttonText.value = "permissions.page.biometric.next";
        skipButtonText.value = "permissions.page.later.permission.text";
        break;
    }
  }

  moveToNextPage() {
    if (pageIndex < pageItems.length - 1) {
      pageIndex = pageIndex + 1;
      pageController.animateToPage(pageIndex,
          duration: basicWidgetAnimationDuration, curve: Curves.decelerate);
      refreshButtonTexts();
    } else {
      _prefs.setBool(PreferenceKey.appTourDone, true);
      Get.find<AppController>().goToHomePage();
    }
  }

  neverAskMoveToNextPage() {
    switch (pageItems[pageIndex].identifier) {
      case "notifications":
        _prefs.setBool(PreferenceKey.notificationsRequested, true);
        break;
      case "biometric":
        _prefs.setBool(PreferenceKey.biometricRequested, true);
        break;
    }
    moveToNextPage();
  }


}
