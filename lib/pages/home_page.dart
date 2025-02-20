import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/homepage_controller.dart';
import '../utils/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomepageController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
              children: [
                _buildTopBar(controller),
                _buildStatusBox(controller, context),
                _buildOngoingTasks(context),
                buildCompletedTasks(context,),
              ],
            ),
          ),
        ),
      ),


    );
    
  }


  Column buildCompletedTasks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Completed',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(, (index) {
            return ListTile(
              titleTextStyle: TextStyle(
                color: AppColors.blackColor,
                fontSize: 17,
                decoration: TextDecoration.lineThrough,
                fontWeight: FontWeight.w600,
              ),
              subtitleTextStyle: Theme.of(context).textTheme.displaySmall,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              trailing: IconButton(
                onPressed: () {
                  Get.dialog(Container(), useSafeArea: true);
                },
                icon: Icon(Icons.edit),
              ),
              title: Text('Create Wireframe'),
              subtitle: Text('Today'),
              leading: Checkbox(value: true, onChanged: (value) {}),
            );
          }),
        ),
      ],
    );
  }

  Column _buildOngoingTasks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ongoing',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(2, (index) {
            return ListTile(
              title: Text(
                'Create Wireframe',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 17,

                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Today',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              leading: Checkbox(
                value: false,
                onChanged: (value) {},

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Container _buildStatusBox(
    HomepageController controller,
    BuildContext context,
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
                  '${controller.completedTasks}/${controller.allTasks} Tasks',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(
                  '${controller.completionPercentage.toStringAsFixed(1)} %',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Container(
                  height: 20,
                  color: AppColors.whiteColor,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: (controller.completionPercentage) / 100,
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

  Row _buildTopBar(HomepageController controller) {
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
}
