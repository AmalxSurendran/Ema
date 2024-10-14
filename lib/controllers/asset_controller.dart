import 'dart:convert';
import 'package:ema_v4/pages/splash/splash_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/cf_downloader.dart' as cf_downloader;
import '../utils/ui/dialog.dart';
import 'app_controller.dart';
import 'auth_controller.dart';

class AssetController extends GetxController {
  final RxInt _queue = RxInt(0);
  final RxDouble progress = RxDouble(0);
  final Rx<List<String>> _allFiles = Rx<List<String>>([]);
  final List<int> _fileSizes = [];
  RxInt currentOperation = RxInt(0);

  get estimatedDownloadSize {
    double size = 0;
    for (var element in _fileSizes) {
      size = size + (element * 0.000001);
    }
    return size;
  }

  Function()? onDownloadComplete;

  // 0 = Checking assets
  // 1 = Downloading assets
  // 2 = Unzipping assets
  // 3 = All complete
  late final Directory userDocumentsDir;
  late SharedPreferences prefs;
  final List<String> gexids;
  final AuthController authController = Get.find();
  final AppController appController = Get.find();

  AssetController(this.gexids);

  @override
  Future<void> onInit() async {
    userDocumentsDir = await getApplicationDocumentsDirectory();
    prefs = await SharedPreferences.getInstance();
    _queue.listen((p0) {
      progress.value =
          (_allFiles.value.length - _queue.value) / _allFiles.value.length;
    });
    super.onInit();
  }

  Future<void> downloadConfigFile() async {
    final file = File('${(await getTemporaryDirectory()).path}/config.json');
    _allFiles.value.clear();
    _fileSizes.clear();
    try {
      await cf_downloader.downloadFile(appController.additionalAssetUrls[1],
          authController.accessToken.value!, file);
      Map<String, int> exerciseVersionsFromJson(String str) =>
          Map.from(json.decode(str)).map((k, v) => MapEntry<String, int>(k, v));
      Map<String, int> exerciseVersions =
          exerciseVersionsFromJson(file.readAsStringSync());
      file.delete();
      for (String gexid in gexids) {
        debugPrint("Checking for $gexid");
        bool directoryExists =
            await Directory('${userDocumentsDir.path}/$gexid').exists();
        debugPrint("Does directory exists? $directoryExists");
        if (exerciseVersions[gexid] != (prefs.getInt(gexid) ?? -1) ||
            !directoryExists) {
          if (directoryExists) {
            await Directory('${userDocumentsDir.path}/$gexid')
                .delete(recursive: true);
          }
          prefs.setInt(gexid, exerciseVersions[gexid]!);
          _addFileToQueue(gexid);
        }
      }
      if (_allFiles.value.isNotEmpty) {
        Get.find<AppController>().requireAssetsDownload(true);
      } else {
        debugPrint("All Files up-to date");
        currentOperation.value = 3;
        Get.find<AppController>().requireAssetsDownload(false);
        Get.delete<AssetController>(force: true);
      }
    } on Exception catch (e) {
      FirebaseCrashlytics.instance
          .recordError(e, null, fatal: false, reason: "config file failure");
      if (Get.currentRoute == SplashPage.routeName) {
        rethrow;
      } else {
        showRetryDownloadDialog();
      }
    }
  }

  _getDownloadSize(String gexid) async {
    try {
      int size = (await cf_downloader.getFileSize(
          _getDownloadLink(gexid), authController.accessToken.value!));
      _fileSizes[_allFiles.value.indexWhere((element) => element == gexid)] =
          size;
    } catch (_) {}
  }

  void _addFileToQueue(String gexid) {
    _allFiles.value.add(gexid);
    _fileSizes.add(0);
    _getDownloadSize(gexid);
  }

  Future<void> beginDownload() async {
    currentOperation.value = 1;
    _queue.value = _allFiles.value.length;
    for (String gexid in _allFiles.value) {
      await _downloadFile(gexid);
    }
  }

  Future<void> _downloadFile(String gexid) async {
    final file = File('${userDocumentsDir.path}/$gexid.zip');
    debugPrint(
        "starting file download $gexid with download link ${_getDownloadLink(gexid)}");
    try {
      await cf_downloader.downloadFile(
          _getDownloadLink(gexid), authController.accessToken.value!, file,
          fileSize: _fileSizes[
              _allFiles.value.indexWhere((element) => element == gexid)]);
      debugPrint("completed file download $gexid");
      _queue.value--;
      if (_queue.value == 0) {
        _unzipFiles();
      }
    } on Exception catch (e) {
      showRetryDownloadDialog();
      FirebaseCrashlytics.instance
          .recordError(e, null, fatal: false, reason: "unzipping failure");
    }
  }

  Future<void> _unzipFiles() async {
    currentOperation.value = 2;
    _queue.value = _allFiles.value.length;
    for (String gexid in _allFiles.value) {
      await _unzipFile(gexid);
    }
  }

  Future<void> _unzipFile(String gexid) async {
    final assetZipFile = File('${userDocumentsDir.path}/$gexid.zip');
    final assetDirectory = Directory('${userDocumentsDir.path}/$gexid');
    if (assetDirectory.existsSync()) {
      assetDirectory.deleteSync(recursive: true);
    } else {
      assetDirectory.createSync();
    }
    try {
      await ZipFile.extractToDirectory(
          zipFile: assetZipFile,
          destinationDir: assetDirectory,
          onExtracting: (zipEntry, progress) {
            if (progress == 100) {}
            return ZipFileOperation.includeItem;
          });
      _queue.value--;
      await assetZipFile.delete();
      if (_queue.value == 0) {
        currentOperation.value = 3;
        Get.find<AppController>().requireAssetsDownload(false);
        if (onDownloadComplete != null) {
          onDownloadComplete!();
        }
      }
    } catch (e) {
      assetDirectory.deleteSync();
      if (kDebugMode) {
        print(e);
      }
      showRetryDownloadDialog();
    }
  }

  showRetryDownloadDialog() {
    showCustomDialog(
        title: "Error downloading assets",
        description:
            "Please ensure you have a stable internet connection and try again",
        confirmText: "Try again",
        onConfirm: () async {
          await downloadConfigFile();
          beginDownload();
        });
  }

  String _getDownloadLink(String gexid) {
    if (gexid == "common") {
      return appController.additionalAssetUrls[0];
    } else {
      return (appController.patient.currentCourse?.prescription
              .firstWhere((element) => element.exercise.identifier == gexid)
              .exercise
              .assets) ??
          "";
    }
  }
}
