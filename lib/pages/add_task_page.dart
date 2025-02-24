import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_todo_app/models/task.dart';
import 'package:hive_todo_app/utils/app_colors.dart';
import 'package:lottie/lottie.dart';

import '../controllers/add_task_controlller.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddTaskController());

    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.blackColor,
        centerTitle: true,
        title: Lottie.asset(
          'assets/animations/time.json',
          height: 60,
          width: 60,
          repeat: false,
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.blackColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Form(
            key: controller.formKey,
            child: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTextField(
                  controller.title,
                  'Title',
                  maxLines: 1,
                  controller: controller,
                ),
                _buildTextField(
                  controller.description,
                  'Description',
                  maxLines: 3,
                  controller: controller,
                ),
                _buildPriorityDropdown(controller),
                _buildDatePicker(context, controller),
                Obx(
                  () =>
                      controller.selectedDueDate.value != null
                          ? Text(
                            'Due: ${controller.selectedDueDate.value!.toString().split(' ')[0]}',
                            style: const TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 15,
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
                ElevatedButton(
                  onPressed: controller.addTask,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    foregroundColor: AppColors.whiteColor,
                    backgroundColor: AppColors.blueColor,
                  ),
                  child: const Text('Add task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController textController,
    String hint, {
    required int maxLines,
    required AddTaskController controller,
  }) => TextFormField(
    controller: textController,
    minLines: maxLines,
    maxLines: maxLines,
    decoration: InputDecoration(
      fillColor: AppColors.whiteColor,
      filled: true,
      contentPadding: const EdgeInsets.all(10),
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.blackColor, fontSize: 15),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
    style: const TextStyle(color: AppColors.blackColor, fontSize: 17),
    validator: (value) => controller.validateField(value, hint),
  );

  Widget _buildPriorityDropdown(AddTaskController controller) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text('Priority', style: TextStyle(color: AppColors.whiteColor)),
      Obx(
        () => DropdownButton<Priority>(
          value: controller.selectedPriority.value,
          onChanged: controller.setPriority,
          items:
              Priority.values
                  .map(
                    (priority) => DropdownMenuItem<Priority>(
                      value: priority,
                      child: Text(
                        priority.name[0].toUpperCase() +
                            priority.name.substring(1),
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
                  .toList(),
          dropdownColor: AppColors.greyColor,
          style: const TextStyle(color: AppColors.whiteColor),
        ),
      ),
    ],
  );

  Widget _buildDatePicker(BuildContext context, AddTaskController controller) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Due date', style: TextStyle(color: AppColors.whiteColor)),
          IconButton(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2026),
                builder:
                    (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        textTheme: const TextTheme(
                          headlineMedium: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          bodyLarge: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        datePickerTheme: DatePickerThemeData(
                          backgroundColor: AppColors.whiteColor,
                        ),
                      ),
                      child: child!,
                    ),
              );
              controller.setDueDate(picked);
            },
            icon: const Icon(Icons.calendar_month, color: AppColors.whiteColor),
          ),
        ],
      );
}
