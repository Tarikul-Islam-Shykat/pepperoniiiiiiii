import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/global_widegts/custom_text.dart';
import 'package:prettyrini/core/global_widegts/loading_screen.dart';
import 'package:prettyrini/feature/auth/controller/signup_controller.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import 'package:prettyrini/feature/auth/widget/text_field_widget.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/const/image_path.dart';
import '../../../route/route.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.h),
            Center(
                child: Image.asset(
              ImagePath.smallLogo,
              width: 71.w,
              height: 48.h,
              fit: BoxFit.fill,
            )),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                headingText(text: "CareOne", color: AppColors.primaryColor),
                headingText(text: " Login"),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Center(
                child: smallText(
                    text: "Welcome Back, Create an account to continue",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    color: AppColors.grayColor)),
            SizedBox(
              height: 15.h,
            ),
            normalText(
              text: 'First Name',
            ),
            SizedBox(
              height: 5.h,
            ),
            CustomAuthField(
              radiusValue2: 15,
              radiusValue: 15,
              controller: controller.firstNameTEController,
              hintText: "Enter First Name Here",
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 5.h,
            ),
            normalText(
              text: 'Last Name',
            ),
            SizedBox(
              height: 5.h,
            ),
            CustomAuthField(
              radiusValue2: 15,
              radiusValue: 15,
              controller: controller.lastNameTEController,
              hintText: "Enter Last Name Here",
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 5.h,
            ),
            normalText(
              text: 'Email',
            ),
            SizedBox(
              height: 5.h,
            ),
            CustomAuthField(
              radiusValue2: 15,
              radiusValue: 15,
              controller: controller.emailTEController,
              hintText: "Enter Email Here",
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: 15.h,
            ),
            normalText(
              text: 'Password',
            ),
            SizedBox(
              height: 5.h,
            ),
            Obx(() => CustomAuthField(
                  radiusValue2: 15,
                  radiusValue: 15,
                  obscureText: !controller.isPasswordVisible.value,
                  controller: controller.passwordTEController,
                  hintText: "Enter Password Here",
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.grayColor,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                )),
            SizedBox(
              height: 5.h,
            ),
            normalText(
              text: 'Confirm Password',
            ),
            SizedBox(
              height: 5.h,
            ),
            Obx(() => CustomAuthField(
                  radiusValue2: 15,
                  radiusValue: 15,
                  obscureText: !controller.isConfirmPasswordVisible.value,
                  controller: controller.confirmPasswordTEController,
                  hintText: "Enter Confirm Password",
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isConfirmPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.grayColor,
                    ),
                    onPressed: controller.toggleConfirmPasswordVisibility,
                  ),
                )),
            SizedBox(
              height: 20.h,
            ),
            Obx(() => controller.isSignInLoading.value
                ? loading()
                : CustomButton(
                    onTap: () {
                      controller.handleSignUp();
                    },
                    title: Text(
                      "Sign Up",
                      style: GoogleFonts.poppins(
                          fontSize: 16.sp, color: Colors.white),
                    ),
                    color: AppColors.primaryColor,
                  )),
            SizedBox(
              height: 30.h,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    smallText(
                        text: "Already have an account? ", color: Colors.black),
                    GestureDetector(
                        onTap: () {
                          // Navigate to login screen
                          Get.back(); // or Get.toNamed('/login')
                        },
                        child: smallText(
                            text: "Log In", color: AppColors.primaryColor))
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
