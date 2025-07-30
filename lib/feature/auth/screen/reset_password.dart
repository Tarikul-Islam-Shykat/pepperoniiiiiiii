import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/core/const/widget.dart';
import 'package:prettyrini/core/global_widegts/custom_text.dart';
import 'package:prettyrini/core/global_widegts/loading_screen.dart';
import 'package:prettyrini/feature/auth/controller/reset_Passwprd.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import 'package:prettyrini/feature/auth/widget/text_field_widget.dart';
import '../../../core/const/app_colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  // Use the reset password controller
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to update controller when text changes
    _passwordController.addListener(_updatePasswordInController);
    _confirmPasswordController.addListener(_updatePasswordInController);
  }

  @override
  void dispose() {
    // Remove listeners before disposing
    _passwordController.removeListener(_updatePasswordInController);
    _confirmPasswordController.removeListener(_updatePasswordInController);

    // Dispose controllers
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Method to validate password
  bool _validatePassword() {
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      return false;
    }

    if (password != confirmPassword) {
      return false;
    }

    if (password.length < 6) {
      return false;
    }

    return true;
  }

  // Method to update password in controller
  void _updatePasswordInController() {
    if (mounted) {
      controller.updatePassword(_passwordController.text);
      controller.updateConfirmPassword(_confirmPasswordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15.w),
          child: Column(
            children: [
              SizedBox(height: 30.h),
              Center(
                  child: Image.asset(
                ImagePath.smallLogo,
                height: 48.h,
                fit: BoxFit.fill,
              )),
              SizedBox(height: 10.h),
              headingText(
                  text: "Reset Password", color: AppColors.primaryColor),
              SizedBox(height: 4.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(
                    child: Obx(() => smallText(
                        text:
                            "Please enter your new password for\n${controller.email.value}",
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        color: AppColors.grayColor))),
              ),
              SizedBox(height: 25.h),

              // New Password Field
              Align(
                alignment: Alignment.centerLeft,
                child: normalText(text: 'New Password'),
              ),
              SizedBox(height: 5.h),
              Obx(() => CustomAuthField(
                    radiusValue2: 15,
                    radiusValue: 15,
                    obscureText: !_isPasswordVisible,
                    controller: _passwordController,
                    hintText: "Enter new password",
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.grayColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  )),

              SizedBox(height: 15.h),

              // Confirm Password Field
              Align(
                alignment: Alignment.centerLeft,
                child: normalText(text: 'Confirm Password'),
              ),
              SizedBox(height: 5.h),
              CustomAuthField(
                radiusValue2: 15,
                radiusValue: 15,
                obscureText: !_isConfirmPasswordVisible,
                controller: _confirmPasswordController,
                hintText: "Confirm new password",
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.grayColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),

              SizedBox(height: 10.h),

              // Password validation messages
              Obx(() {
                String password = controller.password.value;
                String confirmPassword = controller.confirmPassword.value;

                if (password.isEmpty) {
                  return SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (password.length < 6)
                      Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: smallText(
                          text: "Password must be at least 6 characters",
                          color: Colors.red,
                        ),
                      ),
                    if (confirmPassword.isNotEmpty &&
                        password != confirmPassword)
                      Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: smallText(
                          text: "Passwords do not match",
                          color: Colors.red,
                        ),
                      ),
                    if (controller.isFormValid())
                      Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: smallText(
                          text: "Password is valid ✓",
                          color: Colors.green,
                        ),
                      ),
                  ],
                );
              }),

              SizedBox(height: 30.h),

              // Reset Password button
              Obx(() => controller.isLoading.value
                  ? loading()
                  : CustomButton(
                      onTap: controller.isFormValid()
                          ? () {
                              controller.resetPassword();
                            }
                          : null,
                      title: Text(
                        "Reset Password",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: controller.isFormValid()
                          ? AppColors.primaryColor
                          : AppColors.grayColor,
                    )),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
