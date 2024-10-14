import 'package:get/get.dart';

import '../../controllers/tasks_controller.dart';
import '../../models/inMemory/task_model.dart';
import '../../utils/sub_sink.dart';

class TaskListPageController extends GetxController {
  final TasksController tc = Get.find();

  final SubSink _subsink = SubSink();

  final RxList<Task> orderedTasks = RxList([]);

  @override
  void onInit() {
    _refreshTasks();
    _subsink.add(tc.tasksState.listen((state) => _refreshTasks()));

    super.onInit();
  }
  _refreshTasks() {
    if (tc.tasksState.value.data != null) {
      orderedTasks.clear();
      orderedTasks.addAll(tc.incompleteTasks);
      orderedTasks.addAll(tc.partialTasks);
      orderedTasks.addAll(tc.completeTasks);
    }
  }

  @override
  void onClose() {
    _subsink.cancelAll();

    super.onClose();
  }
}
