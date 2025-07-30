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
import 'package:prettyrini/feature/auth/controller/otp_verfiation_controller.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import '../../../core/const/app_colors.dart';

class OtpVeryScreen extends StatefulWidget {
  const OtpVeryScreen({super.key});

  @override
  State<OtpVeryScreen> createState() => _OtpVeryScreenState();
}

class _OtpVeryScreenState extends State<OtpVeryScreen> {
  // Use the new OTP verification controller
  final OtpVerificationController controller =
      Get.put(OtpVerificationController());

  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // Method to get current OTP from text controllers
  String getCurrentOtp() {
    return _controllers.map((controller) => controller.text).join();
  }

  // Method to update OTP in controller
  void updateOtpInController() {
    String currentOtp = getCurrentOtp();
    controller.updateOtpCode(currentOtp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Obx(() => Column(
            children: [
              SizedBox(height: 50.h),
              Center(
                  child: Image.asset(
                ImagePath.smallLogo,
                height: 48.h,
                fit: BoxFit.fill,
              )),
              SizedBox(
                height: 10,
              ),
              headingText(text: "OTP", color: AppColors.primaryColor),
              SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: smallText(
                        text:
                            "We sent a OTP code to your email. Please confirm enter for verification.\n${controller.email.value}",
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        color: AppColors.grayColor)),
              ),
              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        4,
                        (index) => _buildOtpTextField(index),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Resend OTP button
                    Row(
                      children: [
                        Spacer(),
                        GestureDetector(
                          onTap: controller.isLoading.value
                              ? null
                              : () {
                                  // controller.resendOtp();
                                },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: smallText(
                                text: controller.isLoading.value
                                    ? 'Sending...'
                                    : 'Resend OTP',
                                color: controller.isLoading.value
                                    ? AppColors.grayColor
                                    : AppColors.primaryColor),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // Verify button
                    Obx(() => controller.isOtpIsLoadng.value
                        ? loading()
                        : CustomButton(
                            onTap: () {
                              // Update OTP in controller before verification
                              updateOtpInController();
                              // Verify OTP
                              controller.verifyOtp();
                            },
                            title: Text(
                              "Verify",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),

                    SizedBox(height: 10.h),

                    if (controller.otpCode.value.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: smallText(
                          text: "Current OTP: ${controller.otpCode.value}",
                          color: AppColors.grayColor,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildOtpTextField(int index) {
    return Container(
      width: 40.h,
      height: 40.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(fontSize: 18.sp, color: Colors.black),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          // Auto focus to next field when this field is filled
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          }
          // Auto focus to previous field when backspace is pressed
          else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }

          // Update OTP in controller whenever any digit changes
          updateOtpInController();

          setState(() {});
        },
        onTap: () {
          // Clear field when tapped
          _controllers[index].clear();
          updateOtpInController();
        },
      ),
    );
  }
}
