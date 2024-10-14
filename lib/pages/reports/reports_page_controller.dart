import 'package:ema_v4/models/inMemory/entity_state.model.dart';
import 'package:ema_v4/utils/sub_sink.dart';
import 'package:get/get.dart';

import '../../controllers/reports_controller.dart';
import '../../models/inMemory/daily_report_model.dart';

class ReportsPageController extends GetxController {

  final ReportsController rc = Get.find();
  // final SubSink _sink = SubSink();

  @override
  void onInit() {
    rc.fetchReports();
    super.onInit();
  }

  // _handleReportsState(EntityState<List<DailyReport>> state) {
  //
  //   if (state.data != null) {
  //
  //
  //
  //   }
  //
  // }

  // @override
  // void onClose() {
  //
  //   _sink.cancelAll();
  //
  //   super.onClose();
  // }

}