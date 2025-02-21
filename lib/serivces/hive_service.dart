import 'package:hive/hive.dart';
import '../models/task.dart';

class HiveService {
  static final box = Hive.box<Task>('tasks');

  static void addTasks(Task task) {
    // No null check needed here since we're just adding a task
    box.add(task);
  }

  static void removeTask(int index) {
    // Check if index is valid before deletion
    if (index >= 0 && index < box.length) {
      box.deleteAt(index);
    }
  }

  static void toggleStatus(int index) {
    // Check if index is valid and task exists
    if (index >= 0 && index < box.length) {
      Task? task = box.getAt(index);
      if (task != null) {
        task.isCompleted = !task.isCompleted;
        box.putAt(index, task); // Use putAt for indexed updates
      }
    }
  }

  static List<Task> getAllTasks() {
    // Return empty list if box is empty or null
    if (box.isEmpty) {
      return [];
    }
    return box.values.toList();
  }

  static List<Task> getAllCompletedTasks() {
    // Return empty list if box is empty, filter completed tasks
    if (box.isEmpty) {
      return [];
    }
    return box.values.where((task) => task.isCompleted == true).toList();
  }

  static List<Task> getAllPendingTasks() {
    // Return empty list if box is empty, filter pending tasks
    if (box.isEmpty) {
      return [];
    }
    return box.values.where((task) => task.isCompleted == false).toList();
  }

  static double getCompletionPercentage() {
    // Handle division by zero when there are no tasks
    final totalTasks = box.length;
    if (totalTasks == 0) {
      return 0.0;
    }
    final completedTasks = getAllCompletedTasks().length;
    return (completedTasks / totalTasks) * 100;
  }
}