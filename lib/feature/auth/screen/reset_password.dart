import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/const/widget.dart';
import 'package:prettyrini/core/controller/theme_controller.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import 'package:prettyrini/feature/auth/widget/text_field_widget.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/const/image_path.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var loginEmailController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Image.asset(
              themeController.isDarkMode
                  ? ImagePath.loginDark
                  : ImagePath.loginDark,
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  tilte_text_heading("Reset Password"),
                  SizedBox(height: 50.h),
                  CustomAuthField(
                    controller: loginEmailController,
                    hintText: "Email",
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          //  Get.toNamed(AppRoute.emailVerificationScreen);
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Remember Password',
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              color: Colors.white,
                            ).copyWith(decoration: TextDecoration.underline),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10.h),
                  CustomButton(
                    onTap: () {},
                    title: Text(
                      "Enter",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
