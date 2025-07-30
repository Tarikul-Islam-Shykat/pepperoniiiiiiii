import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/core/style/global_text_style.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import 'package:prettyrini/feature/chat/ui/ai_coach_chat.dart';

class CoachView extends StatelessWidget {
  const CoachView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(ImagePath.alert, width: 242, height: 430),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: globalTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(text: "How may i help you today!"),
                  TextSpan(
                    text: "Manuelschneid",
                    style: globalTextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          CustomButton(
              onTap: () {
                Get.to(() => AiCoachChat());
              },
              title: Text(
                "Let’s Start",
              ))
          // CustomButton(
          //   radius: 96,
          //   width: 190,
          //   contentPadding: 16,
          //   text: "Let’s Start",
          //   ontap: () {
          //     Get.to(() => AiCoachChat());
          //   },
          // ),
        ],
      ),
    );
  }
}
