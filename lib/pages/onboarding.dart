import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_todo_app/controllers/onboarding_controller.dart';
import 'package:hive_todo_app/pages/home_page.dart';
import 'package:hive_todo_app/utils/app_colors.dart';
import 'package:lottie/lottie.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    Future.delayed(
      Duration(seconds: 1),
      () => controller.slideUpContainer(),
    ); // After a second delay bottom container will be displayed
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Stack(
        children: [
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Lottie.asset('assets/animations/onboarding.json'),
          ),
          Obx(() {
            return AnimatedPositioned(
              bottom: controller.containerPosition.value,
              curve: Curves.easeIn,
              duration: Duration(seconds: 1),
              left: 0,
              right: 0,
              child: Container(
                height: Get.height * 0.30,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manage your',
                          overflow: TextOverflow.clip,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),

                        Text(
                          'Tasks',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Get Started',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        IconButton(
                          onPressed:
                              () => Get.offAll(
                                () => HomePage(),
                                curve: Curves.easeIn,
                                duration: Duration(milliseconds: 500),
                              ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blackColor,
                            foregroundColor: AppColors.whiteColor,
                          ),
                          icon: Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
