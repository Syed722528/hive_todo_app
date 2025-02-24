import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_todo_app/serivces/hive_service.dart';
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
  final completedSelectedPriority = Priority.high.obs;
  void setCompletedPriority(Priority? priority) =>
      completedSelectedPriority.value = priority ?? Priority.high;

  final pendingSelectedPriority = Priority.high.obs;
  void setPendingPriority(Priority? priority) =>
      pendingSelectedPriority.value = priority ?? Priority.high;

  final allTasks = <Task>[].obs;
  final allCompletedTasks = <Task>[].obs;
  final filteredCompletedTasks = <Task>[].obs;
  final allPendingTasks = <Task>[].obs;
  final filteredPendingTasks = <Task>[].obs;

  final numberOfAllTasks = 0.obs;
  final numberOfAllCompletedTasks = 0.obs; // Fixed typo

  @override
  void onInit() {
    super.onInit();
    greeting.value = getGreeting();
    formattedDate.value = getFormattedDate();
    loadTasks();

    Hive.box<Task>('tasks').watch().listen((event) {
      loadTasks(); // Reload tasks when a change occurs
    });
  }

  void loadTasks() {
    try {
      final tasks = HiveService.getAllTasks();
      final pending = HiveService.getAllPendingTasks();
      final completed = HiveService.getAllCompletedTasks();

      allTasks.assignAll(tasks);
      allPendingTasks.assignAll(pending);
      allCompletedTasks.assignAll(completed);
      filteredPendingTasks.assignAll(pending); // Fresh copy
      filteredCompletedTasks.assignAll(completed); // Fresh copy

      numberOfAllTasks.value = allTasks.length;
      numberOfAllCompletedTasks.value = allCompletedTasks.length;
    } catch (e) {
      print('Error loading tasks: $e'); // Add proper error handling
    }
  }

  void updateOngoingTaskBasedOnPriority() {
    filteredPendingTasks.assignAll(
      allPendingTasks.where((task) => task.priority == pendingSelectedPriority.value).toList(),
    );
  }

  void updateCompletedTaskBasedOnPriority() {
    filteredCompletedTasks.assignAll(
      allCompletedTasks.where((task) => task.priority == completedSelectedPriority.value).toList(),
    );
  }
}
