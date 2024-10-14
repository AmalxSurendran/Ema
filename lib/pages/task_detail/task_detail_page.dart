import 'package:ema_v4/exercise_monitoring/constants.dart';
import 'package:ema_v4/models/inMemory/task_model.dart';
import 'package:ema_v4/pages/task_detail/task_detail_page_controller.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/ui/spacing.dart';
import '../../exercise_monitoring/pages/tilt_calibration/tilt_calib_page.dart';
import '../feedback/feedback_page.dart';

class TaskDetailPage extends GetView<TaskDetailPageController> {
  const TaskDetailPage({Key? key}) : super(key: key);
  static const String routeName = '/taskDetail';

  @override
  Widget build(BuildContext context) {
    Task task = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(task.exercise.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: task.id,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: FlickVideoPlayer(
                  flickManager: controller.flickManager
                ),
              ),
            ),
            Padding(
              padding: pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (task.exercise.info != null) ...[
                    Text(
                      'Description',
                      style: Get.theme.textTheme.titleLarge,
                    ),
                    space1,
                    Text(task.exercise.info!),
                    space4,
                  ],
                  Text(
                    'Steps',
                    style: Get.theme.textTheme.titleLarge,
                  ),
                  space1,
                  ...List.generate(task.exercise.steps.length, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${index + 1}.',
                              style: Get.theme.textTheme.bodyMedium?.copyWith(
                                  color: Get.theme.colorScheme.secondary),
                            ),
                            horSpace1,
                            Expanded(
                              child:
                                  Text(task.exercise.steps[index].toString()),
                            ),
                          ],
                        ),
                        space1,
                      ],
                    );
                  }),
                  space4,
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed(FeedbackPage.routeName, arguments: {
                            'taskId': task.id,
                            'exerciseId': task.exercise.id
                          });
                        },
                        child: const Text('Share feedback'),
                      )),
                      if(lazyInternal)...[
                        const SizedBox(width: 8),
                        Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.offNamed(TiltCalibPage.routeName,
                                    arguments:task);
                              },
                              child: const Text('Perform Exercise'),
                            ))
                      ]
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
