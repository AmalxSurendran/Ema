import 'package:ema_v4/constants/strings.dart';
import 'package:ema_v4/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/ui/spacing.dart';
import '../../../controllers/tasks_controller.dart';
import '../../../models/inMemory/task_model.dart';
import '../../task_list/task_list_page.dart';

class HomeExerciseCard extends StatelessWidget {
  HomeExerciseCard({Key? key, required this.homeController}) : super(key: key);

  final TasksController tc = Get.find();
  final HomeController homeController;

  bool get isDownloadingAssets {
    return (homeController.appController.requireAssetsDownload.isTrue &&
        homeController.appController.assetController.currentOperation.value !=
            0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isDownloadingAssets) {
          if (homeController.appController.requireAssetsDownload.isTrue) {
            homeController.promptDownloadDialog();
          } else {
            if (tc.tasksState.value.data != null &&
                tc.tasksState.value.data!.isNotEmpty) {
              Get.toNamed(TaskListPage.routeName);
            }
          }
        }
      },
      child: Card(
        child: Padding(
          padding: allPad2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Exercises',
                  style: Get.theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
              space2,
              Obx(() => tc.tasksState.value.loading
                  ? _tasksLoadingContent()
                  : tc.tasksState.value.error != null
                      ? _tasksNotAvailableContent(tc.tasksState.value.error!)
                      : tc.tasksState.value.data!.isEmpty
                          ? _tasksNotAvailableContent('home.tasks.noTasks'.c)
                          : _tasksAvailableContent(tc.tasksState.value.data!)),
              // _tasksNotAvailableContent(),
              // _tasksLoadingContent(),
            ],
          ),
        ),
      ),
    );
  }

  _tasksLoadingContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 100.0,
          child: Center(
            child: CircularProgressIndicator(
              color: Get.theme.colorScheme.primary,
            ),
          ),
        )
      ],
    );
  }

  _tasksAvailableContent(List<Task> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (tc.incompleteTasks.isNotEmpty)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tc.incompleteTasks.length.toString(),
                  style: Get.theme.textTheme.titleLarge),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: Text(
                  'home.tasks.label.incomplete'.c,
                  style: Get.theme.textTheme.bodyMedium
                      ?.copyWith(color: Get.theme.colorScheme.secondary),
                ),
              ),
            ],
          ),
        if (tc.partialTasks.isNotEmpty) ...[
          space1,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tc.partialTasks.length.toString(),
                  style: Get.theme.textTheme.titleLarge),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: Text(
                  'home.tasks.label.partial'.c,
                  style: Get.theme.textTheme.bodyMedium
                      ?.copyWith(color: Get.theme.colorScheme.secondary),
                ),
              ),
            ],
          ),
        ],
        if (tc.completeTasks.isNotEmpty) ...[
          space1,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tc.completeTasks.length.toString(),
                  style: Get.theme.textTheme.titleLarge),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: Text(
                  'home.tasks.label.complete'.c,
                  style: Get.theme.textTheme.bodyMedium
                      ?.copyWith(color: Get.theme.colorScheme.secondary),
                ),
              ),
            ],
          ),
        ],
        space2,
        if (isDownloadingAssets) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value:
                    homeController.appController.assetController.progress.value,
                color: Get.theme.primaryColor,
              ),
              space1,
              Text(
                homeController.appController.assetController.currentOperation
                            .value ==
                        2
                    ? 'Checking files'
                    : 'Downloading assets',
                style: Get.theme.textTheme.bodySmall?.copyWith(
                  color: Get.theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ] else ...[
          Text(
            homeController.appController.requireAssetsDownload.isFalse
                ? 'home.tasks.actionHelper'.c
                : 'home.tasks.actionHelper.download'.c,
            style: Get.theme.textTheme.bodySmall?.copyWith(
              color: Get.theme.colorScheme.secondary,
            ),
          ),
        ],
      ],
    );
  }

  _tasksNotAvailableContent(String reason) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          reason,
          style: Get.theme.textTheme.bodyMedium?.copyWith(
            color: Get.theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
