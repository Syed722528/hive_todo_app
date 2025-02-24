import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_todo_app/serivces/hive_service.dart';
import '../models/task.dart';

class AddTaskController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final title = TextEditingController(), description = TextEditingController();
  final selectedPriority = Priority.high.obs;
  final selectedDueDate = Rxn<DateTime>();

  void setPriority(Priority? priority) =>
      selectedPriority.value = priority ?? Priority.high;
  void setDueDate(DateTime? date) => selectedDueDate.value = date;

  void addTask() {
    if (formKey.currentState!.validate()) {
      HiveService.addTask(
        Task(
          title: title.text,
          description: description.text,
          isCompleted: false,
          priority: selectedPriority.value,
          createdDate: DateTime.now(),
          dueDate: selectedDueDate.value,
        ),
      );
      Get.back();
    }
  }

  String? validateField(String? value, String fieldName) =>
      value?.isEmpty ?? true ? '$fieldName is required' : null;

  @override
  void onClose() {
    title.dispose();
    description.dispose();
    super.onClose();
  }
}
