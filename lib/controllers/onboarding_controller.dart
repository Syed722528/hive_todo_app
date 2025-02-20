import 'package:get/get.dart';

class OnboardingController extends GetxController {
  RxDouble containerPosition = (-Get.height * 0.55).obs;

  void slideUpContainer() {
    containerPosition.value = 0;
  }
}
