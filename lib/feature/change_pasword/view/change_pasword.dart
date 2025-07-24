import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/style/global_text_style.dart';
import '../controller/change_pasword_controller.dart';

class ChangePasword extends StatelessWidget {
  ChangePasword({super.key});
  final controller = Get.put(ChangePaswordController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 12, right: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Image.asset(
                    "assets/icons/back.png",
                    height: 30,
                    width: 30,
                  ),
                ),
                Image.asset("assets/images/logo.png", height: 30, width: 150),
                Container(
                  height: 30,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xffD2E2F5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("20", style: TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(width: 2),
                      Image.asset(
                        "assets/icons/star.png",
                        height: 18,
                        width: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_open),
                      Text(
                        "Change Password",
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: controller.oldpaswordController,
                    decoration: InputDecoration(hintText: 'Old Password'),
                  ),
                  TextFormField(
                    controller: controller.newpaswordController,
                    decoration: InputDecoration(hintText: 'New Password'),
                  ),
                  TextFormField(
                    controller: controller.confirmpaswordController,
                    decoration: InputDecoration(hintText: 'Confirm Password'),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 150,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                      onPressed: () {
                        controller.changePassword();
                      },
                      child: Text(
                        "save",
                        style: globalTextStyle(color: AppColors.whiteColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
