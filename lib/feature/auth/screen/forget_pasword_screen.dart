import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/core/global_widegts/custom_text.dart';
import '../../../core/style/global_text_style.dart';
import '../controller/forget_pasword_controller.dart';
import '../widget/custom_booton_widget.dart';
import '../widget/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/global_widegts/loading_screen.dart';
import 'package:prettyrini/feature/auth/screen/sign_up_screen.dart';

import '../../../route/route.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});
  final ForgetPasswordController controller =
      Get.put(ForgetPasswordController());

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
                controller: controller.emailController,
                hintText: "Enter Email Here",
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 15.h,
              ),
              SizedBox(
                height: 30.h,
              ),
              Spacer(),
              Obx(() => controller.isSendOtp.value
                  ? loading()
                  : CustomButton(
                      onTap: () {
                        controller.sendemail();
                      },
                      title: Text(
                        "Send OTP",
                        style: GoogleFonts.poppins(
                            fontSize: 16.sp, color: Colors.white),
                      ),
                      color: AppColors.primaryColor,
                    )),
            ],
          ),
        ),
      ),
    );
  }
}


/*
class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final ForgetPasswordController controller = Get.put(
    ForgetPasswordController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                    child: Image.asset(
                  ImagePath.smallLogo,
                  width: 71.w,
                  height: 48.h,
                  fit: BoxFit.fill,
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    headingText(text: "Email", color: AppColors.primaryColor),
                    headingText(text: " Verification"),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Center(
                    child: smallText(
                        text: "Enter Your Email For Verification",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        color: AppColors.grayColor)),
                SizedBox(height: 64.h),
                CustomAuthField(
                  controller: controller.emailController,
                  hintText: 'Email',
                ),
                SizedBox(height: 48.h),
                CustomButton(
                  onTap: () {
                    controller.sendemail();
                  },
                  title: Text(
                    'Send Otp',
                    style: globalTextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

*/