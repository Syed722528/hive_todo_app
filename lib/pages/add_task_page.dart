import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_todo_app/serivces/hive_service.dart';
import 'package:hive_todo_app/utils/app_colors.dart';
import 'package:lottie/lottie.dart';

import '../models/task.dart';

class AddTaskPage extends StatefulWidget {
  // Changed to StatefulWidget for managing state
  const AddTaskPage({super.key});

  @override
  AddTaskPageState createState() => AddTaskPageState();
}

class AddTaskPageState extends State<AddTaskPage> {
  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  final description = TextEditingController();
  Priority selectedPriority = Priority.high; // Default priority
  DateTime? selectedDueDate; // Store the picked due date

  @override
  Widget build(BuildContext context) {
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
            key: formKey,
            child: Column(
              spacing: 20,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleField(title: title),
                DescriptionField(description: description),
                buildPriority(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Due date',
                      style: TextStyle(color: AppColors.whiteColor),
                    ),
                    IconButton(
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2026),
                          builder: (context, child) {
                            return Theme(
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
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDueDate = picked;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.calendar_month,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
                if (selectedDueDate != null) // Display selected due date
                  Text(
                    'Due: ${selectedDueDate!.toString().split(' ')[0]}', // Show only date part
                    style: const TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 15,
                    ),
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Task task = Task(
                        title: title.text,
                        description: description.text,
                        isCompleted: false,
                        priority: selectedPriority, // Use selected priority
                        createdDate: DateTime.now(), // Auto-set creation date
                        dueDate: selectedDueDate, // Use picked due date
                      );
                      HiveService.addTask(task);
                      Get.back();
                    }
                  },
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

  Row buildPriority(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Priority', style: TextStyle(color: AppColors.whiteColor)),
        DropdownButton<Priority>(
          value: selectedPriority,

          onChanged: (Priority? newValue) {
            setState(() {
              selectedPriority = newValue!;
            });
          },
          items:
              Priority.values.map((Priority priority) {
                return DropdownMenuItem<Priority>(
                  value: priority,
                  child: Text(
                    StringExtension(
                      priority.name,
                    ).capitalize(), // Capitalize for display
                    style: TextStyle(color: AppColors.whiteColor, fontSize: 20),
                  ),
                );
              }).toList(),
          dropdownColor: AppColors.greyColor,
          style: const TextStyle(color: AppColors.whiteColor),
        ),
      ],
    );
  }
}

class DescriptionField extends StatelessWidget {
  const DescriptionField({super.key, required this.description});

  final TextEditingController description;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: description,
      minLines: 3,
      maxLines: 3,
      decoration: InputDecoration(
        fillColor: AppColors.whiteColor,
        filled: true,
        contentPadding: const EdgeInsets.all(10),
        hintText: 'Description',
        hintStyle: TextStyle(
          color: AppColors.blackColor,
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      style: const TextStyle(color: AppColors.blackColor, fontSize: 17),
      validator: (value) {
        if (value == null || value.isEmpty) {
          // Improved validation
          return 'Description is required';
        }
        return null;
      },
    );
  }
}

class TitleField extends StatelessWidget {
  const TitleField({super.key, required this.title});

  final TextEditingController title;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: AppColors.blackColor, fontSize: 17),
      controller: title,
      minLines: 1,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: 'Title',
        hintStyle: TextStyle(
          color: AppColors.blackColor,
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),

        fillColor: AppColors.whiteColor,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          // Improved validation
          return 'Title is required';
        }
        return null;
      },
    );
  }
}

// Extension to capitalize the first letter
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
