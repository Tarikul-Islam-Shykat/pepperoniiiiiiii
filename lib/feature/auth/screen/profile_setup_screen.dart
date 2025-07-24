import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../core/const/app_colors.dart';
import '../../../core/const/image_path.dart';
import '../../../core/style/global_text_style.dart';
import '../controller/profile_setup_controller.dart';
import '../widget/custom_booton_widget.dart';
import '../widget/text_field_widget.dart';

class ProfileSetupScreen extends StatelessWidget {
  ProfileSetupScreen({super.key});

  final ProfileSetupController controller = Get.put(ProfileSetupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        height: 30,
                        width: 50,
                      ),
                      Text(
                        "Foot & Fitness",
                        style: globalTextStyle(
                          color: Color(0xff216CCE),
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, size: 16),
                    Text('Personal Information'),
                  ],
                ),
                SizedBox(height: 12.h),

                /// image pick from gallery
                Center(
                  child: Obx(
                    () => GestureDetector(
                      onTap: controller.pickImage,
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade200,
                              border: Border.all(
                                width: 14,
                                color: Colors.white,
                              ),
                            ),
                            child: ClipOval(
                              child:
                                  controller.imagePath.value.isEmpty
                                      ? Image.asset(
                                        height: 64,
                                        width: 64,
                                        ImagePath.profile,
                                        //fit: BoxFit.contain,
                                      )
                                      : Image.file(
                                        File(controller.imagePath.value),
                                        fit: BoxFit.cover,
                                      ),
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 1,
                            left: 55,
                            child: IconButton(
                              onPressed: () {
                                controller.pickImage();
                              },
                              icon: Container(
                                width: 24.w,
                                height: 24.h,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(ImagePath.gellary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                14.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: CustomAuthField(
                        controller: controller.firstNameTEController,
                        hintText: 'First Name',
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CustomAuthField(
                        controller: controller.lastNameTEController,
                        hintText: 'Last Name',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                CustomAuthField(
                  controller: controller.dobNameTEController,
                  hintText: 'Date of Birth',
                  suffixIcon: IconButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        String formattedDate =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        controller.dobNameTEController.text = formattedDate;
                      }
                    },
                    icon: Icon(Icons.date_range, color: Colors.grey.shade800),
                  ),
                ),

                SizedBox(height: 8.h),
                CustomAuthField(
                  controller: controller.heightNameTEController,
                  hintText: 'Height',
                  suffixIcon: Text("cm"),
                ),
                SizedBox(height: 8.h),
                CustomAuthField(
                  controller: controller.weightNameTEController,
                  hintText: 'Weight',
                  suffixIcon: Text('lb'),
                ),
                SizedBox(height: 48.h),
                CustomButton(
                  onTap: () {
                    if (controller.imagePath.value.isEmpty ||
                        controller.firstNameTEController.text.isEmpty ||
                        controller.dobNameTEController.text.isEmpty ||
                        controller.heightNameTEController.text.isEmpty ||
                        controller.weightNameTEController.text.isEmpty) {
                      Get.snackbar("Error", "Please fill all fields");
                    } else {
                      //Get.to(() => OnbordingOne());
                    }
                  },
                  title: Text(
                    'Next',
                    style: globalTextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
