// First, add this dependency to your pubspec.yaml:
// dependencies:
//   google_nav_bar: ^5.0.6
//   get: ^4.6.6

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:prettyrini/core/services_class/local/user_info.dart';
import 'package:prettyrini/feature/chat_v2/controller/chats_controller.dart';
import 'package:prettyrini/feature/chat_v2/view/chat_screen.dart';
import 'package:prettyrini/feature/dashboard/ui/dashboard.dart';
import 'package:prettyrini/feature/diagnosis_v2/ui/diagnosis_image_selection.dart';
import 'package:prettyrini/feature/profile/ui/profile_screen.dart';
import 'package:prettyrini/feature/shop/ui/shop_screen.dart';

// GetX Controller
class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;
  var name = "".obs;
  var imageUrl = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadInfo();
  }

  loadInfo() async {
    var localService = LocalService();
    name.value = await localService.getName();
    imageUrl.value = await localService.getImagePath();
    ChatController chatController = Get.put(ChatController());
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  // Add your pages here - replace these with your actual pages
  List<Widget> get pages => [
        HomeScreen(),
        ShopScreen(),
        ImageSelectionScreen(),
        ChatScreen(
          receiverId: "",
          name: name.value,
          imageUrl: imageUrl.value,
        ),
        ProfileScreen(),
      ];
}
