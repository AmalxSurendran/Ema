import 'package:ema_v4/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';
import '../../../constants/ui/spacing.dart';
import '../../../models/inMemory/daily_report_model.dart';

class DailyReportItem extends StatelessWidget {
  final DailyReport report;

  const DailyReportItem({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: allPad2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  DateFormat('EEE, dd MMM yyyy').format(report.date),
                  style: Get.theme.textTheme.titleLarge,
                ),
                space1,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'reports.item.label.score'.c,
                      style: Get.theme.textTheme.bodyMedium
                          ?.copyWith(color: Get.theme.colorScheme.secondary),
                    ),
                    horSpace1,
                    Text(
                      '${(report.score * 100).round().toString()}%',
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
                      'reports.item.label.result'.c,
                      style: Get.theme.textTheme.bodyMedium
                          ?.copyWith(color: Get.theme.colorScheme.secondary),
                    ),
                    horSpace1,
                    _getReportResultText(report.score),
                  ],
                ),
              ],
            ),
          ),
        ),
        space2,
      ],
    );
  }

  Text _getReportResultText(double score) {
    if (score == 0) {
      return Text(
        'reports.item.result.non'.c,
        style: Get.theme.textTheme.bodyMedium?.copyWith(
          color: themeRed,
          fontWeight: FontWeight.w600,
        ),
      );
    } else if (score > 0 && score < 1) {
      return Text(
        'reports.item.result.partial'.c,
        style: Get.theme.textTheme.bodyMedium?.copyWith(
          color: themeYellow,
          fontWeight: FontWeight.w600,
        ),
      );
    } else {
      return Text(
        'reports.item.result.full'.c,
        style: Get.theme.textTheme.bodyMedium?.copyWith(
          color: themeGreen,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }
}
