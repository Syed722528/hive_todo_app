import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_todo_app/serivces/hive_service.dart';
import 'package:hive_todo_app/utils/app_colors.dart';
import 'package:lottie/lottie.dart';

import '../models/task.dart';


class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final title = TextEditingController();
    final description = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.blackColor,
        centerTitle: true,
        title: Lottie.asset(
          'assets/animations/time.json',
          height: 60,
          width: 60,
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.blackColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Form(
            key: formKey,
            child: Column(
              spacing: 20,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  style: TextStyle(color: AppColors.blackColor, fontSize: 17),
                  controller: title,
                  minLines: 1,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: Theme.of(context).textTheme.displaySmall,
                    fillColor: AppColors.lightGrey,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Title is required';
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: description,
                  minLines: 3,
                  maxLines: 3,
                  decoration: InputDecoration(
                    fillColor: AppColors.lightGrey,
                    filled: true,
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Description',
                    hintStyle: Theme.of(context).textTheme.displaySmall,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: TextStyle(color: AppColors.blackColor, fontSize: 17),
                  validator: (value) {
                    if (value == null) {
                      return 'Description is required';
                    } else {
                      return null;
                    }
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Priority'),
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (value) {}),
                        Text(
                          'High',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (value) {}),
                        Text(
                          'Medium',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (value) {}),
                        Text(
                          'Low',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Due date'),
                    IconButton(
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2026),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                textTheme: TextTheme(
                                  headlineMedium: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ), // Affects the header (month/year)
                                  bodyLarge: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.calendar_month,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),

                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Task task = Task(
                        title: title.text,
                        description: description.text,
                        isCompleted: false,
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
                  child: Text('Add task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
