import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
enum Priority {
  @HiveField(0)
  high,

  @HiveField(1)
  medium,

  @HiveField(2)
  low,
}

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  String id;

  @HiveField(4)
  Priority priority;

  @HiveField(5)
  DateTime createdDate;

  @HiveField(6)
  DateTime? dueDate;

  Task({
    required this.title,
    required this.description,
    this.isCompleted = false,
    String? id,
    this.priority = Priority.high,
    DateTime? createdDate,
    this.dueDate,

  }) : id = id ?? Uuid().v4(),createdDate = createdDate ??DateTime.now(); // Auto-generate if not provided
}
