import 'dart:convert';
import 'dart:developer';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prettyrini/core/global_widegts/app_snackbar.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';
import 'package:prettyrini/feature/auth/screen/otp_very_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network_caller/endpoints.dart';

class EmailVerificationController extends GetxController {
  final TextEditingController emailTEController = TextEditingController();
  final NetworkConfig _networkConfig = NetworkConfig();

  @override
  void onInit() {
    super.onInit();
  }

  // Handle login
  final isForgetPasswordLoading = false.obs;
  Future<bool> forgetPassword() async {
    if (emailTEController.text.isEmpty) {
      AppSnackbar.show(message: 'Please fill all fields', isSuccess: false);
      return false;
    }
    try {
      isForgetPasswordLoading.value = true;
      String email = emailTEController.text;
      final Map<String, dynamic> requestBody = {
        "email": email,
      };
      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.forgotPass,
        json.encode(requestBody),
        is_auth: false,
      );
      log("message 2 ${response.toString()}");
      if (response != null && response['success'] == true) {
        AppSnackbar.show(
            message: "An OTP was Sent To Your Email", isSuccess: true);
        Get.to(OtpVeryScreen());
        return true;
      } else {
        AppSnackbar.show(message: response['message'], isSuccess: false);
        return false;
      }
    } catch (e) {
      AppSnackbar.show(message: "Failed To Login $e", isSuccess: false);
      return false;
    } finally {
      isForgetPasswordLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose controllers
    emailTEController.dispose();
    super.onClose();
  }
}
