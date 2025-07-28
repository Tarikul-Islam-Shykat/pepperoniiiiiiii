import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:prettyrini/core/const/app_colors.dart';

Widget loading({double value = 30}) {
  return Center(
    child: LoadingAnimationWidget.staggeredDotsWave(
      color: Colors.black, // required for gradient to apply
      size: value.h,
    ),
  );
}

Widget loadingSmall() {
  return Center(
    child: LoadingAnimationWidget.staggeredDotsWave(
      color: Colors.black,
      size: 20.h,
    ),
  );
}

Widget btnLoading() {
  return Center(
    child: LoadingAnimationWidget.staggeredDotsWave(
      color: Colors.black,
      size: 40.h,
    ),
  );
}
