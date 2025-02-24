import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_todo_app/pages/add_task_page.dart';
import 'package:hive_todo_app/serivces/hive_service.dart';

import '../controllers/homepage_controller.dart';
import '../models/task.dart';
import '../utils/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomepageController());
    controller.loadTasks();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddTaskPage());
        },
        backgroundColor: AppColors.blueColor,
        foregroundColor: AppColors.whiteColor,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTopBar(context, controller),
                buildStatusContainer(context, controller),

                buildOngoingTiles(context, controller),
                buildCompletedTiles(context, controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTopBar(BuildContext context, HomepageController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good',
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${controller.greeting}',
              style: TextStyle(
                color: AppColors.greyColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        Row(
          spacing: 3,
          children: [
            IconButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightGrey,
                foregroundColor: AppColors.blackColor,

                iconSize: 15,
                minimumSize: Size.fromRadius(1),
              ),
              icon: Icon(Icons.calendar_month),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightGrey,
                foregroundColor: AppColors.blackColor,

                iconSize: 15,
                minimumSize: Size.fromRadius(1),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildStatusContainer(
    BuildContext context,
    HomepageController controller,
  ) {
    return Container(
      height: Get.height * 0.40,
      width: Get.width * 0.87,
      margin: EdgeInsets.symmetric(vertical: 13),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.blackColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(
                controller.formattedDate.value,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                "Today's progress",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ],
          ),
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${controller.numberOfAllCompletedTasks}/${controller.numberOfAllTasks} Tasks',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(
                  '${controller.numberOfAllTasks.value == 0 ? "0.0" : ((controller.numberOfAllCompletedTasks.value / controller.numberOfAllTasks.value) * 100).toStringAsFixed(1)} %',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Container(
                  height: 20,
                  color: AppColors.whiteColor,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor:
                            controller.numberOfAllTasks.value == 0
                                ? 0.0
                                : (controller.numberOfAllCompletedTasks.value /
                                    controller.numberOfAllTasks.value),
                        child: Container(color: AppColors.blueColor),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget buildOngoingTiles(
    BuildContext context,
    HomepageController controller,
  ) {
    return Obx(() {
      return Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ongoing',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),

              DropdownMenu<Priority>(
                closeBehavior: DropdownMenuCloseBehavior.all,

                menuStyle: MenuStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.whiteColor),
                ),
                enableFilter: true,
                textStyle: TextStyle(color: AppColors.blackColor, fontSize: 15),
                initialSelection:
                    controller
                        .pendingSelectedPriority
                        .value, // Set the initial selected value
                onSelected: (Priority? newValue) {
                  if (newValue != null) {
                    controller.setPendingPriority(newValue);
                    controller.updateOngoingTaskBasedOnPriority();
                  }
                },
                dropdownMenuEntries:
                    Priority.values
                        .map(
                          (priority) => DropdownMenuEntry<Priority>(
                            value:
                                priority, // Each entry gets its own Priority value
                            label:
                                priority.name[0].toUpperCase() +
                                priority.name.substring(1),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
          controller.filteredPendingTasks!.isNotEmpty
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  controller.filteredPendingTasks!.length,
                  (index) {
                    final task =
                        controller
                            .filteredPendingTasks![index]; // Get task instance
                    return ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        task.description,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      trailing: IconButton(
                        onPressed:
                            () => showTaskDialog(
                              task.id,
                              context,
                            ), // Pass Task ID
                        icon: Icon(Icons.edit),
                      ),
                      leading: Checkbox(
                        activeColor: AppColors.blueColor,
                        value: task.isCompleted, // Reflect correct task status
                        onChanged: (value) {
                          HiveService.toggleStatus(task.id); // Toggle by ID
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    );
                  },
                ),
              )
              : Text(
                'No task pending',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
        ],
      );
    });
  }

  Widget buildCompletedTiles(
    BuildContext context,
    HomepageController controller,
  ) {
    return Obx(() {
      return Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Completed',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              DropdownMenu<Priority>(
                closeBehavior: DropdownMenuCloseBehavior.all,

                menuStyle: MenuStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.whiteColor),
                ),
                enableFilter: true,
                textStyle: TextStyle(color: AppColors.blackColor, fontSize: 15),
                initialSelection:
                    controller
                        .completedSelectedPriority
                        .value, // Set the initial selected value
                onSelected: (Priority? newValue) {
                  if (newValue != null) {
                    controller.setCompletedPriority(newValue);
                    controller.updateCompletedTaskBasedOnPriority();
                  }
                },
                dropdownMenuEntries:
                    Priority.values
                        .map(
                          (priority) => DropdownMenuEntry<Priority>(
                            value:
                                priority, // Each entry gets its own Priority value
                            label:
                                priority.name[0].toUpperCase() +
                                priority.name.substring(1),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
          controller.allCompletedTasks!.isNotEmpty
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  controller.filteredCompletedTasks!.length,
                  (index) {
                    final task =
                        controller
                            .filteredCompletedTasks![index]; // Get task instance
                    return ListTile(
                      titleTextStyle: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 17,
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.w600,
                      ),
                      subtitleTextStyle:
                          Theme.of(context).textTheme.displaySmall,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      trailing: IconButton(
                        onPressed:
                            () =>
                                showTaskDialog(task.id, context), // Use Task ID
                        icon: Icon(Icons.edit),
                      ),
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      leading: Checkbox(
                        value: task.isCompleted, // Ensure correct state
                        onChanged: (value) {
                          HiveService.toggleStatus(
                            task.id,
                          ); // Toggle using Task ID
                        },
                        activeColor: AppColors.blueColor,
                      ),
                    );
                  },
                ),
              )
              : Text(
                'No tasks completed',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
        ],
      );
    });
  }

  void showTaskDialog(String taskId, BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.blackColor,
        title: const Text(
          'Task Options',
          style: TextStyle(color: AppColors.whiteColor),
        ),
        content: Text(
          'What would you like to do with this task?',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        actions: [
          TextButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.whiteColor,
            ),
            onPressed: () {
              HiveService.removeTask(taskId); // Delete task by ID
              Get.back(); // Close dialog
            },
            child: const Text('Delete'),
          ),
          TextButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.whiteColor,
            ),
            onPressed: () {
              HiveService.toggleStatus(taskId); // Toggle task status by ID
              Get.back(); // Close dialog
            },
            child: const Text('Change Status'),
          ),
        ],
      ),
    );
  }
}
