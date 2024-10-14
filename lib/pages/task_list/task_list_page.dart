import 'dart:io';

import 'package:ema_v4/constants/strings.dart';
import 'package:ema_v4/constants/ui/spacing.dart';
import 'package:ema_v4/pages/task_detail/task_detail_page.dart';
import 'package:ema_v4/pages/task_list/widgets/task_list_item.dart';
import 'package:ema_v4/utils/hive_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../constants/asset_paths.dart';
import '../../exercise_monitoring/pages/tilt_calibration/tilt_calib_page.dart';
import '../../utils/ui/dialog.dart';
import 'task_list_page_controller.dart';

class TaskListPage extends GetView<TaskListPageController> {
  const TaskListPage({Key? key}) : super(key: key);

  static const String routeName = '/tasks';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('taskList.page.header'.c),
      ),
      body: Padding(
        padding: pageVerOnlyPadding,
        child: Stack(
          children: [
            Padding(
              padding: pageHorOnlyPadding,
              child: Obx(
                () => controller.tc.tasksState.value.loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : controller.tc.tasksState.value.error != null
                        ? Center(
                            child: Text(controller.tc.tasksState.value.error!),
                          )
                        : controller.orderedTasks.isEmpty
                            ? Center(
                                child: Text('home.tasks.noTasks'.c),
                              )
                            : ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () {
                                    Get.toNamed(TaskDetailPage.routeName,
                                        arguments:
                                            controller.orderedTasks[index]);
                                  },
                                  child: TaskListItem(
                                      task: controller.orderedTasks[index]),
                                ),
                                scrollDirection: Axis.vertical,
                                padding: const EdgeInsets.only(bottom: 100.0),
                                itemCount: controller.orderedTasks.length,
                                clipBehavior: Clip.antiAlias,
                              ),
              ),
            ),
            if (controller.tc.incompleteTasks.isNotEmpty)
              Padding(
                padding: pagePadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (Platform.isIOS) {
                          showCustomDialog(
                              title: "Make sure\nOrientation Lock is OFF",
                              description: "Enable auto rotate",
                              confirmText: "Done!",
                              descriptionWidget: Image(
                                  image: FileImage(File(
                                      "$pathUserDocuments$pathCommonBase$pathCommonGifAutoRotate")),
                                  fit: BoxFit.contain),
                              onConfirm: () {
                                Get.back();
                                moveToTiltCalibration();
                              });
                        } else {
                          moveToTiltCalibration();
                        }
                      },
                      child: Text('taskList.action.main'.c),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool giveVideoViewPref() {
    for (var element in controller.tc.incompleteTasks) {
      if (HiveUtils.getInstViewedStatus(element.exercise.identifier)) {
        return true;
      }
    }
    return false;
  }

  moveToTiltCalibration() {
    if (giveVideoViewPref()) {
      showCustomDialog(
          title: "Instructional video preference",
          description:
              "Would you like to see the instructional video for every exercise?",
          confirmText: "Yes",
          cancelText: "No",
          onConfirm: () {
            HiveUtils.setUserPreference(HiveUtils.viewInstVideo, true);
            Get.toNamed(TiltCalibPage.routeName,
                arguments: controller.tc.incompleteTasks.first);
          },
          onCancel: () {
            HiveUtils.setUserPreference(HiveUtils.viewInstVideo, false);
            Get.toNamed(TiltCalibPage.routeName,
                arguments: controller.tc.incompleteTasks.first);
          });
    } else {
      HiveUtils.setUserPreference(HiveUtils.viewInstVideo, true);
      Get.toNamed(TiltCalibPage.routeName,
          arguments: controller.tc.incompleteTasks.first);
    }
  }
}
