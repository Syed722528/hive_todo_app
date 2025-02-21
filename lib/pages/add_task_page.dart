import 'package:flutter/material.dart';
import 'package:hive_todo_app/serivces/hive_service.dart';
import 'package:hive_todo_app/utils/app_colors.dart';

import '../models/task.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final title = TextEditingController();
    final description = TextEditingController();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blackColor, AppColors.greyColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(foregroundColor: AppColors.whiteColor),
        body: SafeArea(
          child: Center(
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
                      controller: title,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintMaxLines: 1,
                        hintStyle: Theme.of(context).textTheme.displaySmall,
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
                      decoration: InputDecoration(
                        hintText: 'Description',
                        hintMaxLines: 3,
                        hintStyle: Theme.of(context).textTheme.displaySmall,
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Description is required';
                        } else {
                          return null;
                        }
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Task task = Task(
                            title: title.text,
                            description: description.text,
                            isCompleted: false,
                          );
                          HiveService.addTasks(task);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        foregroundColor: AppColors.blackColor,
                        backgroundColor: AppColors.whiteColor,
                      ),
                      child: Text('Add task'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
