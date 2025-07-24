// lib/screens/product_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prettyrini/core/const/app_bar.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/core/const/image_path.dart';
import 'package:prettyrini/feature/auth/widget/custom_booton_widget.dart';
import 'package:prettyrini/feature/auth/widget/text_field_widget.dart';
import 'package:prettyrini/feature/dashboard/controller/product_controller.dart';
import 'package:prettyrini/feature/dashboard/model/product_model.dart';

class PostScreen extends StatelessWidget {
  var loginEmailController = TextEditingController();

  PostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          // Background
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              ImagePath.subscriptionLogo,
              fit: BoxFit.fill,
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  buildAppBar("Jenny"),
                  SizedBox(
                    height: 20,
                  ),
                  CustomAuthField(
                    controller: loginEmailController,
                    hintText: "Product Name",
                    maxLines: 1,
                    // suffixIcon: Image.asset(ImagePath.passwordHidden),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomAuthField(
                    controller: loginEmailController,
                    hintText: "Product Description",
                    maxLines: 5,
                    // suffixIcon: Image.asset(ImagePath.passwordHidden),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  CustomAuthField(
                    controller: loginEmailController,
                    hintText: "Product Price",
                    maxLines: 1,
                    // suffixIcon: Image.asset(ImagePath.passwordHidden),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomAuthField(
                    controller: loginEmailController,
                    hintText: "Product Description",
                    maxLines: 5,
                    // suffixIcon: Image.asset(ImagePath.passwordHidden),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  CustomAuthField(
                    controller: loginEmailController,
                    hintText: "Product Category",
                    maxLines: 1,
                    // suffixIcon: Image.asset(ImagePath.passwordHidden),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Buy Now Button
                  CustomButton(
                    onTap: () {},
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.post_add,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Post",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
