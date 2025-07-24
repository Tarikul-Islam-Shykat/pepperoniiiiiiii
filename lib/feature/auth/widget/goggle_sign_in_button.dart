import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/const/icons_path.dart';

class GoggleSignInButton extends StatelessWidget {
  const GoggleSignInButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.5.sw, // 50% of screen width using ScreenUtil
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Image.asset(
          IconsPath.google, // Add Google icon to assets
          height: 24,
        ),
        label: Text(
          'Continue with Google',
          style: TextStyle(
              color: AppColors
                  .secondaryColor), // Text color to contrast with grey
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          backgroundColor: Color(0xffD2E2F5), // Grey fill color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(300.r),
          ),
          side: BorderSide.none, // Removes the border
        ),
      ),
    );
  }
}