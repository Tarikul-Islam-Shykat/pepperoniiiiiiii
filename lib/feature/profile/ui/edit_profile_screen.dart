import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/core/global_widegts/loading_screen.dart';
import 'package:prettyrini/feature/auth/widget/text_field_widget.dart';
import 'package:prettyrini/feature/profile/widget/rounder_back_button.dart';
import '../../../core/const/app_colors.dart';
import '../../auth/widget/custom_booton_widget.dart';
import '../controller/edit_profile_controller.dart';

class EditProfile extends StatelessWidget {
  EditProfile({super.key});
  final EditProfileController controller = Get.put(EditProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.isLoading.value
          ? btnLoading()
          : Padding(
              padding: const EdgeInsets.only(top: 60, left: 15, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      roundBackButton(
                        () => Get.back(),
                      ),
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.center,
                          "Edit Profile",
                          style: GoogleFonts.poppins(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () => _showImagePickerOptions(context),
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 105,
                            width: 105,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.purple.shade50,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Obx(() {
                                if (controller.profileImage.value != null) {
                                  return Image.file(
                                    controller.profileImage.value!,
                                    fit: BoxFit.cover,
                                  );
                                } else if (controller
                                    .profileImageUrl.value.isNotEmpty) {
                                  return Image.network(
                                    controller.profileImageUrl.value,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Image.asset(ImagePath.profile),
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                    child: Image.asset(ImagePath.profile),
                                  );
                                }
                              }),
                            ),
                          ),
                          Positioned(
                            bottom: -6,
                            child: InkWell(
                              onTap: () => _showImagePickerOptions(context),
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),

                  // Full Name Field
                  Text(
                    "Full Name",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        color: AppColors.blackColor),
                  ),
                  CustomAuthField(
                    radiusValue: 15.r,
                    radiusValue2: 15.r,
                    controller: controller.nameController,
                    hintText: "Enter your full name",
                    readOnly: false,
                  ),
                  SizedBox(height: 15.h),

                  // Email Field (Read-only)
                  Text(
                    "Email",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                        color: AppColors.blackColor),
                  ),
                  CustomAuthField(
                    radiusValue: 15.r,
                    radiusValue2: 15.r,
                    controller: controller.emailController,
                    hintText: "Email address",
                    readOnly: true,
                  ),
                  SizedBox(height: 15.h),

                  // Upload Progress
                  Obx(() {
                    if (controller.isUpdating.value) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10.h),
                        child: Column(
                          children: [
                            LinearProgressIndicator(
                              value: controller.uploadProgress.value / 100,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryColor),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              'Updating... ${controller.uploadProgress.value.toInt()}%',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }),

                  Spacer(),

                  Obx(
                    () => controller.isUpdating.value
                        ? btnLoading()
                        : Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomButton(
                                  onTap: () => controller.updateProfile(),
                                  title: Text(
                                    "Save",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.sp,
                                        color: AppColors.whiteColor),
                                  ),
                                )
                              ],
                            ),
                          ),
                  )

                  // Save Button
                  // Padding(
                  //   padding: const EdgeInsets.all(15.0),
                  //   child: Column(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Obx(() => CustomButton(
                  //             onTap: controller.isUpdating.value
                  //                 ? null
                  //                 : () => controller.updateProfile(),
                  //             title: controller.isUpdating.value
                  //                 ? btnLoading()
                  //                 : Text(
                  //                     "Save",
                  //                     style: GoogleFonts.poppins(
                  //                         fontWeight: FontWeight.w600,
                  //                         fontSize: 18.sp,
                  //                         color: AppColors.whiteColor),
                  //                   ),
                  //           )),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            )),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Select Profile Picture',
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(
                  context,
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Get.back();
                    controller.pickImageFromCamera();
                  },
                ),
                _buildImageOption(
                  context,
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    Get.back();
                    controller.pickImageFromGallery();
                  },
                ),
              ],
            ),
            SizedBox(height: 20.h),
            _buildImageOption(
              context,
              icon: Icons.delete,
              label: 'Remove',
              color: Colors.red,
              onTap: () {
                Get.back();
                controller.removeProfileImage();
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: (color ?? AppColors.primaryColor).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: (color ?? AppColors.primaryColor).withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30.sp,
              color: color ?? AppColors.primaryColor,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: color ?? AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
