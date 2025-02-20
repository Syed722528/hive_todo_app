import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_todo_app/models/task.dart';
import 'package:hive_todo_app/utils/app_colors.dart';

import 'pages/onboarding.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.whiteColor,
        appBarTheme: AppBarTheme(color: Colors.transparent),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            fontSize: 40,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
          ),
          bodyMedium: TextStyle(fontSize: 30, color: AppColors.greyColor),
          bodySmall: TextStyle(
            fontSize: 20,
            color: AppColors.blackColor,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(fontSize: 15, color: AppColors.greyColor),
          displayMedium: TextStyle(fontSize: 25, color: AppColors.whiteColor),
          displayLarge: TextStyle(fontSize: 45, color: AppColors.whiteColor),
        ),
      ),
      home: Onboarding(),
    );
  }
}
