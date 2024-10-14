import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:ema_v4/constants/broadcast_notifications.dart';
import 'package:ema_v4/controllers/app_controller.dart';
import 'package:ema_v4/controllers/auth_controller.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_center/notification_center.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/reports_controller.dart';
import 'controllers/tasks_controller.dart';
import 'firebase_options.dart';
import 'constants/routes.dart';
import 'constants/ui/themes.dart';

List<CameraDescription> cameras = [];

Future<void> mainInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    }
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    return true;
  };
  // final storage = AmplifyStorageS3(prefixResolver: EMAPrefixResolver());
  // final auth = AmplifyAuthCognito();
  // await Amplify.addPlugins([storage, auth]);
  // try {
  //   await Amplify.configure(amplifyconfig);
  //   debugPrint("Amplify configured");
  // } on Exception catch (e) {
  //   if (kDebugMode) {
  //     debugPrint("Amplify FAILED");
  //     print(e);
  //   }
  // }

  const AudioContext audioContext = AudioContext(
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.playback,
      options: [
        AVAudioSessionOptions.defaultToSpeaker,
      ],
    ),
    android: AudioContextAndroid(
      isSpeakerphoneOn: true,
      stayAwake: true,
      contentType: AndroidContentType.music,
      usageType: AndroidUsageType.media,
      audioFocus: AndroidAudioFocus.gainTransientMayDuck,
    ),
  );
  AudioPlayer.global.setAudioContext(audioContext);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.initialLink, required this.themeMode});

  final PendingDynamicLinkData? initialLink;
  final ThemeMode themeMode;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        NotificationCenter().notify(broadcastLifecycleResumed);
        break;
      case AppLifecycleState.inactive:
        NotificationCenter().notify(broadcastLifecycleInactive);
        break;
      case AppLifecycleState.paused:
        NotificationCenter().notify(broadcastLifecyclePaused);
        break;
      case AppLifecycleState.detached:
        NotificationCenter().notify(broadcastLifecycleDetached);
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EMA',
      theme: getLightTheme(context),
      darkTheme: getDarkTheme(context),
      debugShowCheckedModeBanner: false,
      themeMode: widget.themeMode,
      smartManagement: SmartManagement.full,
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController(widget.initialLink));
        Get.put(TasksController());
        Get.put(ReportsController());
        Get.put(AppController());
      }),
      getPages: routes,
    );
  }
}
// class EMAPrefixResolver extends StorageS3PrefixResolver {
//   @override
//   Future<String> resolvePrefix(
//       {required StorageAccessLevel storageAccessLevel, String? identityId}) async{
//     return '';
//   }
// }
