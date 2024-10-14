import 'package:ema_v4/constants/strings.dart';
import 'package:ema_v4/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/ui/spacing.dart';
import '../../reports/reports_page.dart';

class HomeReportsCard extends StatelessWidget {
  HomeReportsCard({Key? key}) : super(key: key);

  final AppController ac = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (ac.patient.currentCourse != null &&
            ac.patient.currentCourse!.adherence.totalDays > 0) {
          Get.toNamed(ReportsPage.routeName);
        }
      },
      child: Card(
        child: Padding(
          padding: allPad2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Reports',
                  style: Get.theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
              space2,
              ac.patient.currentCourse != null &&
                      ac.patient.currentCourse!.adherence.totalDays > 0
                  ? _reportAvailableContent()
                  : _reportNotAvailableContent(),
              // _reportAvailableContent(),
              // _reportLoadingContent(),
              // _reportNotAvailableContent(),
            ],
          ),
        ),
      ),
    );
  }

  _reportLoadingContent() {
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

  _reportAvailableContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 100.0,
                          width: 100.0,
                          child: CircularProgressIndicator(
                            value: ac.patient.currentCourse!.adherence
                                .previousScore!,
                            color: Get.theme.primaryColor,
                            strokeWidth: 16.0,
                          ),
                        ),
                        Center(
                          child: Text(
                            '${(ac.patient.currentCourse!.adherence.previousScore! * 100).round()}%',
                            style: Get.theme.textTheme.titleLarge?.copyWith(
                              color: Get.theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  space2,
                  Text(
                    'Yesterday',
                    style: Get.theme.textTheme.bodySmall?.copyWith(
                      color: Get.theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 100.0,
                          width: 100.0,
                          child: CircularProgressIndicator(
                            value: (ac.patient.currentCourse!.adherence
                                    .totalScore /
                                ac.patient.currentCourse!.adherence.totalDays),
                            color: Get.theme.primaryColor,
                            strokeWidth: 16.0,
                          ),
                        ),
                        Center(
                          child: Text(
                            '${((ac.patient.currentCourse!.adherence.totalScore / ac.patient.currentCourse!.adherence.totalDays) * 100).round()}%',
                            style: Get.theme.textTheme.titleLarge?.copyWith(
                              color: Get.theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  space2,
                  Text(
                    'Overall (${ac.patient.currentCourse!.adherence.totalDays} days)',
                    style: Get.theme.textTheme.bodySmall?.copyWith(
                      color: Get.theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        space2,
        Text(
          'home.reports.actionHelper'.c,
          style: Get.theme.textTheme.bodySmall?.copyWith(
            color: Get.theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  _reportNotAvailableContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'home.reports.noReports'.c,
          style: Get.theme.textTheme.bodyMedium?.copyWith(
            color: Get.theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
