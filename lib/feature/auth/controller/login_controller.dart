import 'dart:convert';
import 'dart:developer';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/global_widegts/app_snackbar.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';
import 'package:prettyrini/core/services_class/local/user_info.dart';
import 'package:prettyrini/feature/bottom_nav/ui/tech_bottom_nav.dart';
import 'package:prettyrini/feature/chat_v2/controller/chats_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network_caller/endpoints.dart';

class LoginController extends GetxController {
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();
  final NetworkConfig _networkConfig = NetworkConfig();

  // Password visibility state
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  String? fcmToken;

  @override
  void onInit() {
    super.onInit();
    requestNotificationPermission();
  }

  // Request notification permissions
  Future<void> requestNotificationPermission() async {
    // FirebaseMessaging messaging = FirebaseMessaging.instance;
    // NotificationSettings settings = await messaging.requestPermission(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );

    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //   fcmToken = await messaging.getToken();
    //   if (kDebugMode) {
    //     print("FCM Token: $fcmToken");
    //   } // Debugging purpose
    // } else {
    //   if (kDebugMode) {
    //     print("User denied permission");
    //   }
    // }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Validate login form
  bool _validateLoginForm() {
    if (emailTEController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (!GetUtils.isEmail(emailTEController.text)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (passwordTEController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (passwordTEController.text.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  // Handle login
  final isLoginLoading = false.obs;

  Future<bool> loginUser() async {
    if (emailTEController.text.isEmpty || passwordTEController.text.isEmpty) {
      AppSnackbar.show(message: 'Please fill all fields', isSuccess: false);
      return false;
    }
    try {
      isLoginLoading.value = true;
      String email = emailTEController.text;
      String password = passwordTEController.text;
      final Map<String, dynamic> requestBody = {
        "email": email,
        "password": password,
      };
      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.login,
        json.encode(requestBody),
        is_auth: false,
      );
      log("melon@gmail.com"); ////...

      log("message 2 ${response.toString()}");

      if (response != null && response['success'] == true) {
        var localService = LocalService();
        await localService.clearUserData();
        await localService.setToken(response["data"]["token"]);
        await getUserData();
        //  final ChatController chatController = Get.put(ChatController());
        Get.to(UserBottomNavFloating());
        // await localService.setRole(response["data"]["role"]);
        // String role = await localService.getRole();
        AppSnackbar.show(message: "Login Successful", isSuccess: true);
        return true;
      } else {
        AppSnackbar.show(message: response['message'], isSuccess: false);
        return false;
      }
    } catch (e) {
      AppSnackbar.show(message: "Failed To Login $e", isSuccess: false);
      return false;
    } finally {
      isLoginLoading.value = false;
    }
  }

  Future<bool> getUserData() async {
    try {
      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        Urls.getProfile,
        json.encode({}),
        is_auth: true,
      );
      log("melon@gmail.com"); ////...

      log("getUserData 2 ${response.toString()}");

      if (response != null && response['success'] == true) {
        final data = response['data'];
        final id = data['id'];
        final fullName = data['fullName'];
        final email = data['email'];
        final image = data['image'];
        var localService = LocalService();
        log("getUserData 2 ${response.toString()} - $fullName - $email - $image");

        await localService.setUserId(id);
        await localService.setName(fullName);
        await localService.setEmail(email);
        await localService.setImagePath(image);
        return true;
      } else {
        AppSnackbar.show(message: response['message'], isSuccess: false);
        return false;
      }
    } catch (e) {
      AppSnackbar.show(message: "Failed To Login $e", isSuccess: false);
      return false;
    } finally {}
  }

  // Handle Google Sign In
  Future<void> handleGoogleSignIn() async {
    try {
      isLoading.value = true;

      // TODO: Implement actual Google Sign In logic here
      // For now, simulating the process
      await Future.delayed(Duration(seconds: 2));

      Get.snackbar(
        'Info',
        'Google Sign In coming soon!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Google sign in failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      if (kDebugMode) {
        print('Google Sign In error: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Clear form fields
  void _clearFields() {
    emailTEController.clear();
    passwordTEController.clear();
  }

  // Check if user is already logged in
  Future<bool> isUserLoggedIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("isLogin") ?? false;
  }

  // Logout function
  Future<void> logout() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.clear(); // Clear all stored data

      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to login screen
      // Get.offAllNamed('/login');
    } catch (e) {
      if (kDebugMode) {
        print('Logout error: $e');
      }
    }
  }

  @override
  void onClose() {
    // Dispose controllers
    emailTEController.dispose();
    passwordTEController.dispose();
    super.onClose();
  }
}
