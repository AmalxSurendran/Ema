import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:ema_v4/constants/preferences.dart';
import 'package:ema_v4/constants/strings.dart';
import 'package:ema_v4/controllers/asset_controller.dart';
import 'package:ema_v4/controllers/tasks_controller.dart';
import 'package:ema_v4/exercise_monitoring/constants.dart';
import 'package:ema_v4/models/api/request/appMeta.dart';
import 'package:ema_v4/models/api/response/selfUserResponse.dart';
import 'package:ema_v4/models/inMemory/course.dart';
import 'package:ema_v4/models/inMemory/organisation.dart';
import 'package:ema_v4/pages/home/home_page.dart';
import 'package:ema_v4/pages/permissions/controller/permissions_controller.dart';
import 'package:ema_v4/services/notificationService.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import '../constants/asset_paths.dart';
import '../models/inMemory/patient.dart';
import '../pages/permissions/permissions_page.dart';
import '../pages/update_profile/update_profile_page.dart';
import '../services/apiService.dart';
import '../utils/hive_utils.dart';
import '../utils/ui/dialog.dart';

class AppController extends GetxController {
  late Patient patient;
  late Organisation organisation;
  late SharedPreferences prefs;
  final TasksController tc = Get.find();
  late AssetController assetController;
  late List<String> additionalAssetUrls;
  final RxBool requireAssetsDownload = RxBool(true);

  @override
  Future<void> onInit() async {
    super.onInit();
    pathUserDocuments = (await getApplicationDocumentsDirectory()).path;
    prefs = await SharedPreferences.getInstance();
    HiveUtils.init();
  }

  startApp() async {
    if (await _biometricAuthenticated()) {
      await updateAppMeta();
      await getSelfUser();
      NotificationService.initNotifications();
      await tc.getTasksForTheDay();
      await checkForAssets();
      if (await PermissionsPageController.requiresAnyPermission()) {
        Get.offAllNamed(PermissionsPage.routeName);
      } else {
        goToHomePage();
      }
    }
  }

  Future<bool> _biometricAuthenticated() async {
    if (prefs.getBool(PreferenceKey.biometricEnabled) ?? false) {
      final LocalAuthentication auth = LocalAuthentication();
      try {
        final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'app.biometric.reason'.c,
            options: const AuthenticationOptions(biometricOnly: true));
        if (didAuthenticate) {
          return true;
        } else {
          showCustomDialog(
              title: "app.dialog.biometric.fail".c,
              description: "app.dialog.biometric.fail.try.again".c,
              confirmText: "app.dialog.biometric.fail.try.again.confirm".c,
              cancelText: "app.dialog.biometric.fail.try.again.cancel".c,
              onConfirm: () {
                return startApp();
              },
              onCancel: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                //Wont work on iOS but using exit(0) gets a crash reported + against apple guidelines
              });
          return false;
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
          title: "app.dialog.biometric.fail".c,
          description: "app.dialog.biometric.fail.something".c,
          confirmText: "app.dialog.biometric.fail.try.again.cancel".c,
          onConfirm: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            //Wont work on iOS but using exit(0) gets a crash reported + against apple guidelines
          },
        );
        return false;
      }
    } else {
      return true;
    }
  }

  getSelfUser() async {
    SelfUserResponse? response = await ApiService().getSelfUser();
    if (response != null) {
      patient = response.user;
      if ((patient.telecom.email ?? "").contains("@parallelreality.co.uk")) {
        lazyInternal = true;
      } else {
        lazyInternal = false;
      }
      organisation = response.currentOrg;
      additionalAssetUrls = response.additionalAssetUrls;
    }
  }

  goToHomePage() {
    if (patient.height == null) {
      //Go to registration page
      Get.offAllNamed(UpdateProfilePage.routeName);
    } else {
      //Go to home screen
      Get.offAllNamed(HomePage.routeName);
    }
  }

  checkForAssets() async {
    if (patient.currentCourse != null) {
      List<String> gexids = [];
      for (ProgramCoursePrescriptionItem item
          in patient.currentCourse!.prescription) {
        gexids.add(item.exercise.identifier);
      }
      gexids.add("common");
      if (gexids.isNotEmpty) {
        assetController = Get.put(AssetController(gexids), permanent: true);
        await assetController.downloadConfigFile();
      }
    }
  }

  updateAppMeta() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String userPlatform = Platform.isAndroid ? "android" : "ios";
    String? fcmToken;
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
    } on FlutterError catch (e){
      FirebaseCrashlytics.instance.recordError(e, e.stackTrace,fatal: false,reason: "FCM Token get failure");
    }
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    String deviceName;
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.utsname.machine ?? "unknown";
    }
    AppMetaUpdateRequest appMetaUpdateRequest = AppMetaUpdateRequest(
        version: version,
        build: int.parse(buildNumber),
        variant: kDebugMode ? "development" : "production",
        userPlatform: userPlatform,
        fcmToken: fcmToken!,
        device: deviceName);
    await ApiService().updateAppMeta(appMetaUpdateRequest);
  }
}
