import 'package:ema_v4/constants/strings.dart';
import 'package:ema_v4/controllers/app_controller.dart';
import 'package:ema_v4/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import '../../constants/preferences.dart';
import '../../utils/ui/dialog.dart';
import 'app_settings_page.dart';

class AppSettingsPageController extends GetxController {
  final AppController ac = Get.find();

  final RxBool biometricEnabled = false.obs;
  final Rx<ThemeMode> configThemeMode = ThemeMode.system.obs;
  @override
  void onInit() {
    biometricEnabled(ac.prefs.getBool(PreferenceKey.biometricEnabled) ?? false);
    configThemeMode(ThemeMode.values[ac.prefs.getInt(PreferenceKey.configThemeCode) ?? 0]);
    super.onInit();
  }

  onBiometricSwitchToggle(bool newVal) async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'app.biometric.reason'.c,
          options: const AuthenticationOptions(biometricOnly: true));
      if (didAuthenticate) {
        ac.prefs.setBool(PreferenceKey.biometricEnabled, newVal);
        biometricEnabled(newVal);
        if(newVal){
          ac.prefs.setBool(PreferenceKey.biometricRequested, true);
        }
      } else {
        showCustomDialog(
          title: 'settings.biometric.dialog.title'.c,
          description: "app.dialog.biometric.fail.try.again".c,
          confirmText: "app.dialog.biometric.fail.try.again.confirm".c,
          cancelText: "settings.biometric.dialog.cancel".c,
          onConfirm: ()=>onBiometricSwitchToggle(newVal)
        );
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
          title: 'settings.biometric.dialog.title'.c,
          description: "app.dialog.biometric.fail.something".c,
          confirmText: "app.dialog.biometric.fail.try.again.cancel".c,
          onConfirm: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            //Wont work on iOS but using exit(0) gets a crash reported + against apple guidelines
          }
      );
    }
  }
  onThemeSelect(ThemeMode themeMode) async {
    if(themeMode!=configThemeMode.value) {
      configThemeMode(themeMode);
      await ac.prefs.setInt(PreferenceKey.configThemeCode, themeMode.index);
      Get.changeThemeMode(themeMode);
      Future.delayed(const Duration(milliseconds: 200), () =>
          Get.offAllNamed(HomePage.routeName));
      Future.delayed(const Duration(milliseconds: 250), () =>
          Get.toNamed(AppSettingsPage.routeName));
    }
  }
}
