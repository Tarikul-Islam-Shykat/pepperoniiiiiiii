import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/style/global_text_style.dart';

class CustomAuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool readOnly;
  final Widget? prefixIcon;
  final int maxLines;
  final double radiusValue;
  final double radiusValue2;
  final bool isDigitOnly;

  const CustomAuthField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines = 1,
    this.validator,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.readOnly = false, // Default to TextInputType.text
    this.radiusValue = 500,
    this.radiusValue2 = 500,
    this.isDigitOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        readOnly: readOnly,
        keyboardType: keyboardType, // Use optional keyboard type
        obscureText: obscureText,
        controller: controller,
        maxLines: maxLines,

        inputFormatters: [
          if (isDigitOnly) FilteringTextInputFormatter.digitsOnly,
        ],
        style: globalTextStyle(color: const Color(0xff000000)),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          hintText: hintText,
          suffixIcon: suffixIcon,
          hintStyle: globalTextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
          fillColor: Colors.white, // Make background transparent
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(radiusValue),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(radiusValue2),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 14.h,
            horizontal: 12.w,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
