import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:prettyrini/core/global_widegts/app_snackbar.dart'
    show AppSnackbar;
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';
import 'package:prettyrini/feature/auth/screen/reset_password.dart';

class OtpVerificationController extends GetxController {
  // Observable variables
  var otpCode = ''.obs;
  var email = ''.obs;
  var isLoading = false.obs;
  var isOtpComplete = false.obs;
  final NetworkConfig _networkConfig = NetworkConfig();

  @override
  void onInit() {
    super.onInit();
    // Get email from arguments when controller is initialized
    final args = Get.arguments as Map?;
    if (args != null && args['email'] != null) {
      email.value = args['email'];
      log('Email received: ${email.value}');
    }
  }

  // Method to update OTP code
  void updateOtpCode(String code) {
    otpCode.value = code;
    isOtpComplete.value = code.length == 4;

    if (isOtpComplete.value) {
      log('OTP Complete: $code');
      printOtpDetails();
    }
  }

  // Method to print OTP in int format and email
  void printOtpDetails() {
    try {
      // Convert OTP to int
      int otpInt = int.parse(otpCode.value);
      log('OTP in int format: $otpInt');
      log('Email: ${email.value}');

      // Print to console for debugging
      print('=== OTP VERIFICATION DETAILS ===');
      print('OTP Code (String): ${otpCode.value}');
      print('OTP Code (Int): $otpInt');
      print('Email: ${email.value}');
      print('================================');
    } catch (e) {
      log('Error converting OTP to int: $e');
    }
  }

  var isOtpIsLoadng = false.obs;

  Future<bool> verifyOtp() async {
    try {
      isOtpIsLoadng.value = true;
      final Map<String, dynamic> requestBody = {
        "email": email.value,
        "otp": int.parse(otpCode.value)
      };
      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.otpVerification,
        json.encode(requestBody),
        is_auth: false,
      );
      log("melon@gmail.com"); ////...

      log("message 2 ${response.toString()}");

      if (response != null && response['success'] == true) {
        Get.to(() => ResetPasswordScreen(), arguments: {"email": email.value});
        return true;
      } else {
        AppSnackbar.show(message: "In Valid OTP", isSuccess: false);
        return false;
      }
    } catch (e) {
      AppSnackbar.show(message: "In Valid OTP", isSuccess: false);
      return false;
    } finally {
      isOtpIsLoadng.value = false;
    }
  }

  // Simulate OTP verification (replace with actual API call)

  // Method to resend OTP

  // Clear OTP fields
  void clearOtp() {
    otpCode.value = '';
    isOtpComplete.value = false;
  }

  @override
  void onClose() {
    // Clean up when controller is disposed
    super.onClose();
  }
}
