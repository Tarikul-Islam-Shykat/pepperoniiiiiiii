import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/style/global_text_style.dart';

class OnTapRow extends StatelessWidget {
  const OnTapRow({
    super.key,
    required this.onTap,
    required this.textOne,
    required this.textTwo,
  });

  final VoidCallback onTap;
  final String textOne;
  final String textTwo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          textOne,
          style: globalTextStyle(
              color: const Color(0xff000710),
              fontWeight: FontWeight.w400,
              fontSize: 12.h),
        ),
        InkWell(
          onTap: onTap,
          child: Text(
            textTwo,
            style: globalTextStyle(
                color: const Color(0xff000710),
                fontWeight: FontWeight.w500,
                fontSize: 12.h),
          ),
        ),
      ],
    );
  }
}
