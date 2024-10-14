import 'package:ema_v4/models/inMemory/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../constants/ui/spacing.dart';
import '../../models/inMemory/daily_report_model.dart';

class ReportDetailPage extends StatelessWidget {
  const ReportDetailPage({Key? key}) : super(key: key);
  static const routeName = '/reportDetail';

  @override
  Widget build(BuildContext context) {
    DailyReport report = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('EEE, dd MMM yyyy').format(report.date)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: pageHorOnlyPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 32.0,
              ),
              Center(
                child: SizedBox(
                  height: 120.0,
                  width: 120.0,
                  child: Center(
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 100.0,
                            width: 100.0,
                            child: CircularProgressIndicator(
                              value: report.score,
                              color: Get.theme.colorScheme.primary,
                              strokeWidth: 16.0,
                            ),
                          ),
                        ),
                        Center(
                          child: Text('${(report.score * 100).round()}%',
                              style: Get.theme.textTheme.titleLarge),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              space4,
              ...report.tasks
                  .map(
                    (task) => Column(
                      children: [
                        Card(
                          child: Padding(
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
                                      style: Get.theme.textTheme.bodyMedium
                                          ?.copyWith(
                                              color: Get
                                                  .theme.colorScheme.secondary),
                                    ),
                                    horSpace1,
                                    Text(
                                      '${task.report.reps} / ${task.exerciseAttribs.reps}',
                                      style: Get.theme.textTheme.bodyMedium
                                          ?.copyWith(
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
                                      style: Get.theme.textTheme.bodyMedium
                                          ?.copyWith(
                                              color: Get
                                                  .theme.colorScheme.secondary),
                                    ),
                                    horSpace1,
                                    _getTaskStatusText(task.taskState),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        space1,
                      ],
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Text _getTaskStatusText(TaskState status) {
    if (status == TaskState.incomplete) {
      return Text(
        'Incomplete',
        style: Get.theme.textTheme.bodyMedium?.copyWith(
          color: themeRed,
          fontWeight: FontWeight.w600,
        ),
      );
    } else if (status == TaskState.partial) {
      return Text(
        'Could be improved',
        style: Get.theme.textTheme.bodyMedium?.copyWith(
          color: themeYellow,
          fontWeight: FontWeight.w600,
        ),
      );
    } else {
      return Text(
        'Completed',
        style: Get.theme.textTheme.bodyMedium?.copyWith(
          color: themeGreen,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }
}
