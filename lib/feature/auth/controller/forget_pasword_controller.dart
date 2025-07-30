import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/network_caller/endpoints.dart';
import '../screen/login_screen.dart';
import '../screen/otp_very_screen.dart';
import '../screen/reset_password.dart';

class ForgetPasswordController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  var isSendOtp = false.obs;
  void sendemail() async {
    isSendOtp.value = true;
    if (emailController.text.isNotEmpty) {
      try {
        EasyLoading.show(status: "Processing...");
        final response = await http.post(
          Uri.parse('${Urls.baseUrl}/auth/forgot-password'),
          // headers: {"Authorization": token},
          body: {'email': emailController.text},
        );

        if (kDebugMode) {
          print(response.body);
        }
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['success'] == true) {
            Get.snackbar("Success", "Email sent successfully");
            Get.to(() => OtpVeryScreen(),
                arguments: {"email": emailController.text});
          } else {
            Get.snackbar("Error", "Something went wrong");
          }
        } else {
          if (kDebugMode) {
            print('Request failed with status: ${response.statusCode}');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error: $e');
        }
      } finally {
        isSendOtp.value = false;

        EasyLoading.dismiss();
      }
    } else {
      isSendOtp.value = false;

      Get.snackbar("Error", "Please enter email");
    }
  }

  void verifyOtp() async {
    if (otpController.text.length == 4) {
      try {
        EasyLoading.show(status: "Processing...");

        // Debugging: Print OTP and email before sending request
        if (kDebugMode) {
          print("Request URL: ${Urls.baseUrl}/auth/verify-otp");
        }
        if (kDebugMode) {
          print(
            "Request Body: ${jsonEncode({
                  'email': emailController.text.trim(),
                  'otp': int.parse(otpController.text.trim())
                })}",
          );
        }

        final response = await http.post(
          Uri.parse('${Urls.baseUrl}/auth/verify-otp'),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode({
            'email': emailController.text.trim(),
            'otp': int.parse(otpController.text.trim()),
          }),
        );

        if (kDebugMode) {
          print("Response: ${response.body}");
        }

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['success'] == true) {
            Get.snackbar("Success", "OTP verified successfully");
            Get.to(() => ResetPasswordScreen());
          } else {
            Get.snackbar("Error", data['message'] ?? "Invalid OTP");
          }
        } else {
          if (kDebugMode) {
            print('Request failed with status: ${response.statusCode}');
          }
          Get.snackbar("Error", "Request failed. Try again.");
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error: $e");
        }
        Get.snackbar("Error", "Something went wrong.");
      } finally {
        EasyLoading.dismiss();
      }
    } else {
      Get.snackbar("Error", "Please enter OTP");
    }
  }

  void resetPassword() async {
    if (passwordController.text.length >= 7) {
      try {
        EasyLoading.show(status: "Processing...");
        final response = await http.post(
          Uri.parse('${Urls.baseUrl}/auth/reset-password'),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode({
            'email': emailController.text.trim(),
            'password': passwordController.text.trim(),
          }),
        );

        if (kDebugMode) {
          print("Response: ${response.body}");
        }

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['success'] == true) {
            Get.snackbar("Success", "Password reset successfully");
            Get.offAll(() => LoginScreen());
          } else {
            Get.snackbar("Error", data['message'] ?? "Something went wrong");
          }
        } else {
          if (kDebugMode) {
            print('Request failed with status: ${response.statusCode}');
          }
          Get.snackbar("Error", "Request failed. Try again.");
        }
      } catch (e) {
        Get.snackbar("Error", "Something went wrong.");
      } finally {
        EasyLoading.dismiss();
      }
    } else {
      Get.snackbar("Error", "Password must be at least 8 characters long.");
    }
  }
}
