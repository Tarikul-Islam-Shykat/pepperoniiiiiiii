import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:prettyrini/core/const/app_colors.dart';
import 'package:prettyrini/feature/bottom_nav/controller/bottom_nav_controller.dart';

class UserBottomNavFloating extends StatelessWidget {
  final BottomNavController controller = Get.put(BottomNavController());

  UserBottomNavFloating({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 375;
    final bool isTablet = screenWidth > 600;

    final double margin = screenWidth * (isTablet ? 0.06 : 0.04);
    final double horizontalPadding = screenWidth * (isTablet ? 0.04 : 0.03);
    final double verticalPadding = screenWidth * (isTablet ? 0.025 : 0.02);
    final double iconSize = screenWidth * (isTablet ? 0.045 : 0.055);
    final double tabPadding = screenWidth * (isTablet ? 0.035 : 0.04);

    return Scaffold(
      extendBody: true,
      body: Obx(() => controller.pages[controller.selectedIndex.value]),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(margin, 0, margin, margin),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              blurRadius: 25,
              spreadRadius: 0,
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Obx(
            () => GNav(
              rippleColor: AppColors.grayColor.withOpacity(0.3),
              hoverColor: AppColors.blackColor.withOpacity(0.1),
              gap: screenWidth * 0.015,
              activeColor: AppColors.primaryColor,
              iconSize: iconSize,
              padding: EdgeInsets.symmetric(
                horizontal: tabPadding,
                vertical: tabPadding * 0.7,
              ),
              duration: const Duration(milliseconds: 350),
              tabBackgroundColor: AppColors.bgColor,
              color: AppColors.primaryColor.withOpacity(0.7),
              curve: Curves.easeInOutCubic,
              textStyle: TextStyle(
                fontSize: screenWidth * (isTablet ? 0.028 : 0.03),
                fontWeight: FontWeight.w500,
              ),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              tabs: [
                GButton(
                  icon: Icons.home_rounded,
                  text: isSmallScreen ? '' : 'Home',
                ),
                GButton(
                  icon: Icons.shopping_bag_outlined,
                  text: isSmallScreen ? '' : 'Shop',
                ),
                GButton(
                  icon: Icons.camera_alt_rounded,
                  text: isSmallScreen ? '' : 'Scan',
                ),
                GButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  text: isSmallScreen ? '' : 'Chat',
                ),
                GButton(
                  icon: Icons.person_outline_rounded,
                  text: isSmallScreen ? '' : 'Profile',
                ),
              ],
              selectedIndex: controller.selectedIndex.value,
              onTabChange: (index) => controller.changeIndex(index),
            ),
          ),
        ),
      ),
    );
  }
}
