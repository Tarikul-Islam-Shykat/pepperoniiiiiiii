import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/global_widegts/custom_text.dart';
import 'package:prettyrini/feature/auth/controller/email_verification_controller.dart';
import 'package:prettyrini/feature/auth/controller/signup_controller.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import 'package:prettyrini/feature/auth/widget/text_field_widget.dart';
import '../../../core/const/app_colors.dart';
import '../../../core/const/image_path.dart';
import '../../../route/route.dart';

class EmailVerification extends StatelessWidget {
  EmailVerification({super.key});
  final EmailVerificationController controller =
      Get.put(EmailVerificationController());

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
                headingText(text: "Email", color: AppColors.primaryColor),
                headingText(text: "  Verification"),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Center(
                child: smallText(
                    text:
                        "Enter your email for verification. We’ll send youa OTP code there.",
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
              height: 20.h,
            ),
            CustomButton(
              onTap: () {},
              title: Text(
                "Send Email",
                style:
                    GoogleFonts.poppins(fontSize: 16.sp, color: Colors.white),
              ),
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
