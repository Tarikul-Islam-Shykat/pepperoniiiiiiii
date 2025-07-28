import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/const/app_colors.dart';

Widget profileListTile(
  final IconData icon, // updated to accept IconData
  final String name,
  final VoidCallback onTap,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.shade200,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 20.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 20.sp,
            color: AppColors.blackColor,
          ),
        ],
      ),
    ),
  );
}
