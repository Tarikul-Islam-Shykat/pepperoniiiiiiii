import 'dart:async';
import 'package:get/get.dart';
import 'package:prettyrini/feature/auth/screen/login_screen.dart';
import 'package:prettyrini/feature/diagnosis/ui/camera_screen.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Start the timer when controller initializes
    _startSplashTimer();
  }

  void _startSplashTimer() {
    Timer(Duration(seconds: 3), () {
      // Navigate to camera screen after 3 seconds - using correct route name
      Get.offAll(() => LoginScreen());
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}
