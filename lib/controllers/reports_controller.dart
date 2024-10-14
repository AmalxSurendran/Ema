import 'package:ema_v4/models/inMemory/entity_state.model.dart';
import 'package:get/get.dart';

import '../models/inMemory/daily_report_model.dart';
import '../services/apiService.dart';

class ReportsController extends GetxController {

  final Rx<EntityState<List<DailyReport>>> dailyReportsState = Rx(EntityState.withLoading());
  bool reportsFetched = false;

  fetchReports() async {

    if (reportsFetched) {

      dailyReportsState(EntityState.withData(dailyReportsState.value.data!));

    } else {

      dailyReportsState(EntityState.withLoading());

      List<DailyReport>? dailyReports = await ApiService().getDailyReports();
      if (dailyReports != null) {
        dailyReportsState(EntityState.withData(dailyReports));
        reportsFetched = true;
      } else {
        // some error
        reportsFetched = false;
        dailyReportsState(EntityState.withError('Something went wrong'));
      }

    }



  }

}