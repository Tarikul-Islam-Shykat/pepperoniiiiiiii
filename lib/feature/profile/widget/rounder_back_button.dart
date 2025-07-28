import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget roundBackButton(final VoidCallback onTap){
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 42,
      width: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(color: Colors.grey.shade200),
          color: Colors.white
      ),
      child: Center(
        child: Icon(
          Icons.arrow_back_ios_new_outlined,
          size: 18.sp,
        ),
      ),
    ),
  );
}