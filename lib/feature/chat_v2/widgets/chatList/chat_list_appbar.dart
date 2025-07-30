import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/const/icons_path.dart';
import 'package:prettyrini/core/const/image_path.dart';

class Chatlistappbar extends StatelessWidget {
  final VoidCallback ontap;
  const Chatlistappbar({super.key, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(onTap: () => Get.back(), child: Icon(Icons.arrow_back_ios_new)),
        SizedBox(width: 10),
        Image.asset(ImagePath.gellary, width: 40),
        const Spacer(),
        // CircleAvatar(
        //   radius: 24,
        //   backgroundColor: Color(0xFFEDF7EE),
        //   child: Image.asset(IconsPath.searchIcon),
        // ),
        SizedBox(width: 20),
        CircleAvatar(
          radius: 24,
          backgroundColor: Color(0xFFFF7043),
          child: Image.asset(IconsPath.actionButton, width: 24),
        ),
      ],
    );
  }
}
