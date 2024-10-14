import 'package:camera/camera.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/preferences.dart';
import 'env.dart';
import 'main.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  await mainInit();
  int themeCode = (await SharedPreferences.getInstance())
      .getInt(PreferenceKey.configThemeCode) ??
      0;
  PendingDynamicLinkData? initialLink;
  try {
    initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
  } on FlutterError catch (e) {
    initialLink = null;
    FirebaseCrashlytics.instance.recordError(e, e.stackTrace,
        fatal: false, reason: "dynamic link get failure");
  }
  BuildEnvironment.init(
      flavor: BuildFlavor.qualityAssurance, baseUrl: 'https://qa-v4.api.msk.emaapps.co.uk');
  runApp(MyApp(
    initialLink: initialLink,
    themeMode: ThemeMode.values[themeCode],
  ));
}