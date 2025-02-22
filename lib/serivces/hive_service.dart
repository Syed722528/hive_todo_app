import 'package:hive/hive.dart';
import '../models/task.dart';

class HiveService {
  static final box = Hive.box<Task>('tasks');

  static void addTask(Task task) {
    box.put(task.id, task); // Store task using its unique ID
  }

  static void removeTask(String id) {
    if (box.containsKey(id)) {
      box.delete(id);
    }
  }

  static void toggleStatus(String id) {
    Task? task = box.get(id);
    if (task != null) {
      task.isCompleted = !task.isCompleted;
      box.put(id, task); // Update task using its ID
    }
  }

  static List<Task> getAllTasks() {
    return box.values.toList();
  }

  static List<Task> getAllCompletedTasks() {
    return box.values.where((task) => task.isCompleted).toList();
  }

  static List<Task> getAllPendingTasks() {
    return box.values.where((task) => !task.isCompleted).toList();
  }

  static double getCompletionPercentage() {
    final totalTasks = box.length;
    if (totalTasks == 0) return 0.0;
    
    final completedTasks = getAllCompletedTasks().length;
    return (completedTasks / totalTasks) * 100;
  }
}
