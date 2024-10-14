import 'package:ema_v4/controllers/app_controller.dart';
import 'package:ema_v4/controllers/tasks_controller.dart';
import 'package:ema_v4/utils/ui/dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final AppController appController = Get.find();
  final TasksController tasksController = Get.find();

  @override
  void onInit() {
    super.onInit();
    WidgetsFlutterBinding.ensureInitialized();
  }

  promptDownloadDialog() {
    showCustomDialog(
        title: "Mandatory Additional Resources Update",
        description:
            "New exercise assets are available! Please download them before viewing or performing exercises",
        confirmText:
            "Download now (${appController.assetController.estimatedDownloadSize.toStringAsFixed(0)} MB)",
        onConfirm: () {
          appController.assetController.beginDownload();
        },
        cancelText: "Later");
  }
}
