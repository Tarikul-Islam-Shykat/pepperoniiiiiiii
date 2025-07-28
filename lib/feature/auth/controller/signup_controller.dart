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
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network_caller/endpoints.dart';

class SignupController extends GetxController {
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController firstNameTEController = TextEditingController();
  final TextEditingController lastNameTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();
  final TextEditingController confirmPasswordTEController =
      TextEditingController();
  final NetworkConfig _networkConfig = NetworkConfig();

  // Password visibility states
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
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

  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Validate form fields
  bool _validateFields() {
    if (firstNameTEController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your first name',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (lastNameTEController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your last name',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (emailTEController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (!GetUtils.isEmail(emailTEController.text)) {
      Get.snackbar('Error', 'Please enter a valid email',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (passwordTEController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a password',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (passwordTEController.text.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (confirmPasswordTEController.text.isEmpty) {
      Get.snackbar('Error', 'Please confirm your password',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (passwordTEController.text != confirmPasswordTEController.text) {
      Get.snackbar('Error', 'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  final isSignInLoading = false.obs;

  Future<bool> handleSignUp() async {
    if (emailTEController.text.isEmpty || passwordTEController.text.isEmpty) {
      AppSnackbar.show(message: 'Please fill all fields', isSuccess: false);
      return false;
    }

    try {
      isSignInLoading.value = true;
      final Map<String, dynamic> requestBody = {
        "fullName":
            "${firstNameTEController.text} ${lastNameTEController.text}",
        "email": emailTEController.text,
        "password": passwordTEController.text,
      };
      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.signUp,
        json.encode(requestBody),
        is_auth: false,
      );
      log("melon@gmail.com"); ////...

      log("message 2 ${response.toString()}");

      if (response != null && response['success'] == true) {
        // var localService = LocalService();
        // await localService.clearUserData();
        // await localService.setToken(response["data"]["token"]);
        // await localService.setRole(response["data"]["role"]);
        // String role = await localService.getRole();
        AppSnackbar.show(message: "Registration Successful", isSuccess: true);
        return true;
      } else {
        AppSnackbar.show(message: response['message'], isSuccess: false);
        return false;
      }
    } catch (e) {
      AppSnackbar.show(message: "Failed To Login $e", isSuccess: false);
      return false;
    } finally {
      isSignInLoading.value = false;
    }
  }

  // Handle signup
  // Future<void> handleSignUp() async {
  //   if (!_validateFields()) return;

  //   try {
  //     isLoading.value = true;
  //     final response = await http.post(
  //       Uri.parse(Urls.authentication), // Make sure you have signup endpoint
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'firstName': firstNameTEController.text,
  //         'lastName': lastNameTEController.text,
  //         'email': emailTEController.text,
  //         'password': passwordTEController.text,
  //         'fcmToken': fcmToken ?? "",
  //       }),
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final data = jsonDecode(response.body);

  //       Get.snackbar(
  //         'Success',
  //         'Account created successfully!',
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.green,
  //         colorText: Colors.white,
  //       );

  //       // Clear form fields
  //       _clearFields();

  //       // Navigate to login screen or home
  //       // Get.offNamed('/login');
  //     } else {
  //       final errorData = jsonDecode(response.body);
  //       Get.snackbar(
  //         'Error',
  //         errorData['message'] ?? 'Registration failed. Please try again.',
  //         snackPosition: SnackPosition.TOP,
  //       );
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Something went wrong. Please check your connection.',
  //       snackPosition: SnackPosition.TOP,
  //     );
  //     if (kDebugMode) {
  //       print('Signup error: $e');
  //     }
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // Clear all form fields
  void _clearFields() {
    firstNameTEController.clear();
    lastNameTEController.clear();
    emailTEController.clear();
    passwordTEController.clear();
    confirmPasswordTEController.clear();
  }

  // Handle login (existing method)
  Future<void> handleLogin() async {
    if (emailTEController.text.isEmpty || passwordTEController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse(Urls.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailTEController.text,
          'password': passwordTEController.text,
          'fcmToken': fcmToken ?? "",
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['data']['token'];
        if (kDebugMode) {
          print("token1$token");
        }
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("token", token);
        pref.setBool("isLogin", true);
        //Get.offAll(() => NavBarView());
        Get.snackbar(
          'Success',
          'Login successful',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Error',
          'Login failed. Please try again.',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleGoogleSignIn() async {
    try {
      isLoading.value = true;
      // Implement Google Sign In logic here
      await Future.delayed(Duration(seconds: 2));
    } catch (e) {
      Get.snackbar(
        'Error',
        'Google sign in failed',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose controllers
    emailTEController.dispose();
    firstNameTEController.dispose();
    lastNameTEController.dispose();
    passwordTEController.dispose();
    confirmPasswordTEController.dispose();
    super.onClose();
  }
}
