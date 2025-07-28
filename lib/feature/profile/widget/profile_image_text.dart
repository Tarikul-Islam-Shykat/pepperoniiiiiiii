import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/const/app_colors.dart';

Widget profileEmailText(
  final IconData icon,
  final String name,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(
        icon,
        size: 16.sp,
        color: AppColors.primaryColor,
      ),
      SizedBox(width: 6.w),
      SizedBox(
        width: 210.w,
        child: Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w300,
            fontSize: 12.sp,
            color: AppColors.blackColor,
          ),
        ),
      ),
    ],
  );
}
