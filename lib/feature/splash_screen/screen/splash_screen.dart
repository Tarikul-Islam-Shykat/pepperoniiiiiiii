import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/widget.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/core/global_widegts/custom_text.dart';
import 'package:prettyrini/core/global_widegts/loading_screen.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/const/image_path.dart';
import '../controller/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    // Initialize the splash controller
    final SplashScreenController splashController =
        Get.put(SplashScreenController());

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150.w,
                  height: 150.h,
                  child: Image.asset(
                    ImagePath.smallLogo,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    headingText(text: "CareOne", color: AppColors.primaryColor),
                    headingText(text: " Login"),
                  ],
                ),
                SizedBox(height: 30),
                // Optional: Add a loading indicator
                loading()
              ],
            ),
          )
        ],
      ),
    );
  }
}
