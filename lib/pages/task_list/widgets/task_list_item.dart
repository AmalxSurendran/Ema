import 'dart:io';

import 'package:ema_v4/constants/strings.dart';
import 'package:ema_v4/constants/ui/spacing.dart';
import 'package:ema_v4/models/inMemory/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/asset_paths.dart';
import '../../../constants/colors.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({Key? key, required this.task}) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: task.id,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.file(
                    File(
                        "$pathUserDocuments/${task.exercise.identifier}$pathExerciseThumbnail"),
                  ),
                ),
              ),
              space1,
              Padding(
                padding: allPad2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      task.exercise.name,
                      style: Get.theme.textTheme.titleLarge,
                    ),
                    space1,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Reps done:',
                          style: Get.theme.textTheme.bodyMedium?.copyWith(
                              color: Get.theme.colorScheme.secondary),
                        ),
                        horSpace1,
                        Text(
                          '${task.report.reps} / ${task.exerciseAttribs.reps}',
                          style: Get.theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    space1,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Status:',
                          style: Get.theme.textTheme.bodyMedium?.copyWith(
                              color: Get.theme.colorScheme.secondary),
                        ),
                        horSpace1,
                        _getTaskStatusText(task.taskState),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        space2,
      ],
    );
  }

  Text _getTaskStatusText(TaskState status) {
    if (status == TaskState.incomplete) {
      return Text(
        'taskList.item.status.incomplete'.c,
        style: Get.theme.textTheme.bodyMedium?.copyWith(
          color: themeRed,
          fontWeight: FontWeight.w600,
        ),
      );
    } else if (status == TaskState.partial) {
      return Text(
        'taskList.item.status.partial'.c,
        style: Get.theme.textTheme.bodyMedium?.copyWith(
          color: themeYellow,
          fontWeight: FontWeight.w600,
        ),
      );
    } else {
      return Text(
        'taskList.item.status.complete'.c,
        style: Get.theme.textTheme.bodyMedium?.copyWith(
          color: themeGreen,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }
}
