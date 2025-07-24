import 'dart:convert';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network_caller/endpoints.dart';

class LoginController extends GetxController {
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();
  
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
  Future<void> handleLogin() async {
    if (!_validateLoginForm()) return;

    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse(Urls.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailTEController.text.trim(),
          'password': passwordTEController.text,
          'fcmToken': fcmToken ?? "",
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Check if the response has the expected structure
        if (data['data'] != null && data['data']['token'] != null) {
          final token = data['data']['token'];
          final userInfo = data['data']['user']; // Assuming user info is returned
          
          if (kDebugMode) {
            print("Login successful, token: $token");
          }
          
          // Store user data
          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString("token", token);
          await pref.setBool("isLogin", true);
          
          // Store additional user info if available
          if (userInfo != null) {
            await pref.setString("userEmail", userInfo['email'] ?? '');
            await pref.setString("userName", userInfo['name'] ?? '');
          }
          
          Get.snackbar(
            'Success',
            'Login successful! Welcome back.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          
          // Clear form fields
          _clearFields();
          
          // Navigate to main screen
          // Get.offAllNamed('/home'); // or your main screen route
          // Get.offAll(() => NavBarView());
          
        } else {
          Get.snackbar(
            'Error',
            'Invalid response from server',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else if (response.statusCode == 401) {
        Get.snackbar(
          'Error',
          'Invalid email or password',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (response.statusCode == 404) {
        Get.snackbar(
          'Error',
          'Account not found. Please sign up first.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Login failed. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network error. Please check your connection.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      if (kDebugMode) {
        print('Login error: $e');
      }
    } finally {
      isLoading.value = false;
    }
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