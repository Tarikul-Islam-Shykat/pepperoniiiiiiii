import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/core/const/widget.dart';
import 'package:prettyrini/core/global_widegts/custom_text.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import '../../../core/const/app_colors.dart';

class OtpVeryScreen extends StatefulWidget {
  const OtpVeryScreen({super.key});

  @override
  State<OtpVeryScreen> createState() => _OtpVeryScreenState();
}

class _OtpVeryScreenState extends State<OtpVeryScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
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
                        "We sent a OTP code to your email. Please confirm enter for verification.",
                    maxLines: 2,
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
                        child: smallText(
                            text: 'Resend OTP', color: AppColors.primaryColor),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.h),
                CustomButton(
                  onTap: () {},
                  title: Text(
                    "Verify",
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
        ],
      ),
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
          setState(() {});
        },
      ),
    );
  }
}
