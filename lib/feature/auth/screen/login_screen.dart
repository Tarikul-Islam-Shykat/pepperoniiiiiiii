import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/global_widegts/custom_text.dart';
import 'package:prettyrini/core/global_widegts/loading_screen.dart';
import 'package:prettyrini/feature/auth/controller/login_controller.dart';
import 'package:prettyrini/feature/auth/controller/signup_controller.dart';
import 'package:prettyrini/feature/auth/widget/text_field_widget.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/const/image_path.dart';
import '../../../route/route.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.w),
        child: SizedBox(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,
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
                      text: "Welcome Back, Login to your account to continue",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      color: AppColors.grayColor)),
              SizedBox(
                height: 15.h,
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
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                    onTap: () => Get.toNamed(AppRoute.forgetScreen),
                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor),
                    )),
              ),
              SizedBox(
                height: 30.h,
              ),
              Spacer(),
              Obx(() => controller.isLoginLoading.value
                  ? loading()
                  : CustomButton(
                      onTap: () {
                        controller.loginUser();
                      },
                      title: Text(
                        "Login",
                        style: GoogleFonts.poppins(
                            fontSize: 16.sp, color: Colors.white),
                      ),
                      color: AppColors.primaryColor,
                    )),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  normalText(text: "Don't have an account ? "),
                  normalText(text: "Sign Up", color: AppColors.primaryColor),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
