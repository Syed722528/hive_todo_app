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
  RxList<Task>? allTasks = <Task>[].obs;
  RxList<Task>? completedTasks = <Task>[].obs;
  RxList<Task>? pendingTasks = <Task>[].obs;
  RxInt numberOfAllTasks = 0.obs;
  RxInt numbeeOfAllCompletedTasks = 0.obs;
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
    allTasks?.assignAll(HiveService.getAllTasks() ?? []);
    pendingTasks?.assignAll(HiveService.getAllPendingTasks() ?? []);
    completedTasks?.assignAll(HiveService.getAllCompletedTasks() ?? []);

    numberOfAllTasks.value = allTasks?.length ?? 0;
    numbeeOfAllCompletedTasks.value = completedTasks?.length ?? 0;
  }
}
