import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/const/app_colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget title; // Accepts both text and loader
  final Color? color;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handles button click
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: onTap == null
                  ? Colors.grey
                  : (color ??
                      AppColors.primaryColor), // Disabled state handling
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: title, // Shows text or loader
          ),
        ),
      ),
    );
  }
}
