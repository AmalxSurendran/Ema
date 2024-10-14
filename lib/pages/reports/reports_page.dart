import 'package:ema_v4/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/ui/spacing.dart';
import '../report_detail/report_detail_page.dart';
import 'reports_page_controller.dart';
import 'widgets/daily_report_item.dart';

class ReportsPage extends GetView<ReportsPageController> {
  const ReportsPage({Key? key}) : super(key: key);
  static const String routeName = '/reports';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('reports.page.header'.c),
      ),
      body: Padding(
        padding: pageHorOnlyPadding,
        child: Obx(
          () => controller.rc.dailyReportsState.value.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.rc.dailyReportsState.value.error != null
                  ? Center(
                      child: Text(controller.rc.dailyReportsState.value.error!),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 32.0),
                      physics: const BouncingScrollPhysics(),
                      itemCount:
                          controller.rc.dailyReportsState.value.data!.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          Get.toNamed(ReportDetailPage.routeName,
                              arguments: controller
                                  .rc.dailyReportsState.value.data![index]);
                        },
                        child: DailyReportItem(
                            report: controller
                                .rc.dailyReportsState.value.data![index]),
                      ),
                    ),
        ),
      ),
    );
  }
}
