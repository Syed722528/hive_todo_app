import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class HomepageController extends GetxController {
  DateTime now = DateTime.now();
  //----------Get greeting based on Time of the day-------------------------//
  RxString greeting = ''.obs;
  String getGreeting() {
    final hour = now.hour;

    if (hour < 12) {
      return "Morning";
    } else if (hour < 17) {
      return "Afternoon";
    } else {
      return "Evening";
    }
  }

  //----------Get todays date --------------------------//

  RxString formattedDate = ''.obs;
  String getFormattedDate() {
    return DateFormat('MMMM d, E').format(now);
  }

  //-----------Total tasks, completed tasks and percentage-----------//
  late Box<Task> taskBox;

  List<Task> get allTasks => taskBox.values.toList();
  List<Task> get completedTasks =>
      taskBox.values.where((task) => task.isCompleted).toList();
  List<Task> get pendingTasks =>
      taskBox.values.where((task) => !task.isCompleted).toList();

  double get completionPercentage => (completedTasks.length / allTasks.length)*100;
  void addTask(Task task) {
    taskBox.add(task);
    update();
  }

  void removeTask(int index) {
    taskBox.deleteAt(index);
    update();
  }

  void toggleTask(int index) {
    Task task = taskBox.getAt(index)!;
    task.isCompleted = !task.isCompleted;
    taskBox.putAt(index, task);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    greeting.value = getGreeting();
    formattedDate.value = getFormattedDate();
    taskBox = Hive.box<Task>('tasks');
  }
}
