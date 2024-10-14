import 'package:ema_v4/exercise_monitoring/models/session_update.dart';
import 'package:get/get.dart';

import '../models/inMemory/entity_state.model.dart';
import '../models/inMemory/task_model.dart';
import '../services/apiService.dart';

class TasksController extends GetxController {
  final Rx<EntityState<List<Task>>> tasksState = Rx(EntityState.withLoading());
  List<Task> incompleteTasks = [];
  List<Task> partialTasks = [];
  List<Task> completeTasks = [];
  List<Task> attemptedTasks = [];

  getTasksForTheDay() async {
    tasksState(EntityState.withLoading());

    List<Task>? tasks = await ApiService().getTasksForTheDay();
    if (tasks != null) {
      _sortAndRefreshTasks(tasks);
    } else {
      // some error
      tasksState(EntityState.withError('Something went wrong'));
    }
  }

  updateLocalTask(TaskSession sessionSummary, String taskID) {
    assert(tasksState.value.data != null);
    List<Task> tasks = tasksState.value.data!;
    int index = tasks.indexWhere((element) => element.id == taskID);
    Task updatedTask = tasks[index].copyWith(
        report: sessionSummary.report, taskState: sessionSummary.taskState);
    if(tasks[index].taskState.index<sessionSummary.taskState.index){
      tasks[index] = updatedTask;
      _sortAndRefreshTasks(tasks);
    }
    attemptedTasks.add(updatedTask);
  }
  clearAttemptedTasks(){
    attemptedTasks.clear();
  }
  _sortAndRefreshTasks(List<Task> tasks) {
    incompleteTasks.clear();
    partialTasks.clear();
    completeTasks.clear();
    List<Task> tempList = List.from(tasks);
    // sort data in order of `order` value
    tempList.sort((t1, t2) => t2.exercise.order - t1.exercise.order);

    for (Task t in tempList) {
      if (t.taskState == TaskState.incomplete) {
        incompleteTasks.add(t);
      } else if (t.taskState == TaskState.partial) {
        partialTasks.add(t);
      } else if (t.taskState == TaskState.complete) {
        completeTasks.add(t);
      }
    }
    tasksState(EntityState.withData(tasks));
  }
}
