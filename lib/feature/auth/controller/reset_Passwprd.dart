// Import your next screen (login or success screen)
// import 'package:prettyrini/feature/auth/screen/login_screen.dart';
/*

      final Map<String, dynamic> requestBody = {
        "email": email.value,
        "password": password.value,
      };

      log('Reset Password Request Body: ${json.encode(requestBody)}');

      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.resetPassword, // Make sure this endpoint exists in your Urls class
        json.encode(requestBody),
        is_auth: false,
      );
*/

import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:prettyrini/core/global_widegts/app_snackbar.dart'
    show AppSnackbar;
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';
// Import your next screen (login or success screen)
// import 'package:prettyrini/feature/auth/screen/login_screen.dart';

class ResetPasswordController extends GetxController {
  // Observable variables
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var email = ''.obs;
  var isLoading = false.obs;
  var isPasswordValid = false.obs;
  var isPasswordsMatching = false.obs;

  final NetworkConfig _networkConfig = NetworkConfig();

  @override
  void onInit() {
    super.onInit();
    // Get email from arguments when controller is initialized
    final args = Get.arguments as Map?;
    if (args != null && args['email'] != null) {
      email.value = args['email'];
      log('Email received for password reset: ${email.value}');
    }
  }

  // Method to update password
  void updatePassword(String newPassword) {
    password.value = newPassword;
    _validatePassword();
    _checkPasswordsMatch();
    printPasswordDetails();
  }

  // Method to update confirm password
  void updateConfirmPassword(String newConfirmPassword) {
    confirmPassword.value = newConfirmPassword;
    _checkPasswordsMatch();
    printPasswordDetails();
  }

  // Private method to validate password strength
  void _validatePassword() {
    // You can customize password validation rules here
    isPasswordValid.value = password.value.length >= 6;
  }

  // Private method to check if passwords match
  void _checkPasswordsMatch() {
    isPasswordsMatching.value =
        password.value == confirmPassword.value && password.value.isNotEmpty;
  }

  // Method to check if form is valid
  bool isFormValid() {
    return isPasswordValid.value &&
        isPasswordsMatching.value &&
        email.value.isNotEmpty;
  }

  // Method to print password details for debugging
  void printPasswordDetails() {
    log('=== PASSWORD RESET DETAILS ===');
    log('Email: ${email.value}');
    log('Password Length: ${password.value.length}');
    log('Password Valid: ${isPasswordValid.value}');
    log('Passwords Match: ${isPasswordsMatching.value}');
    log('Form Valid: ${isFormValid()}');
    log('===============================');
  }

  // Method to reset password via API
  Future<bool> resetPassword() async {
    if (!isFormValid()) {
      AppSnackbar.show(
          message: "Please fill all fields correctly", isSuccess: false);
      return false;
    }

    try {
      isLoading.value = true;

      final Map<String, dynamic> requestBody = {
        "email": email.value,
        "password": password.value,
      };

      log('Reset Password Request Body: ${json.encode(requestBody)}');

      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.POST,
        Urls.resetPassword, // Make sure this endpoint exists in your Urls class
        json.encode(requestBody),
        is_auth: false,
      );

      log("Reset Password Response: ${response.toString()}");

      if (response != null && response['success'] == true) {
        AppSnackbar.show(
            message: response['message'] ?? "Password reset successfully!",
            isSuccess: true);

        // Clear form after successful reset
        clearForm();

        // Navigate back to login screen
        // Option 1: Go back to login (if you came from forgot password flow)
        Get.back(); // Go back to OTP screen
        Get.back(); // Go back to forgot password screen
        Get.back(); // Go back to login screen

        // Option 2: If you want to go directly to login screen
        // Get.offAllNamed('/login');

        return true;
      } else {
        String errorMessage =
            response?['message'] ?? "Failed to reset password";
        AppSnackbar.show(message: errorMessage, isSuccess: false);
        return false;
      }
    } catch (e) {
      log('Reset Password Error: $e');
      AppSnackbar.show(
          message: "Network error. Please try again.", isSuccess: false);
      return false;
    } finally {
      if (isLoading.value) {
        // Check if still loading to avoid disposing issues
        isLoading.value = false;
      }
    }
  }

  // Method to clear form
  void clearForm() {
    password.value = '';
    confirmPassword.value = '';
    isPasswordValid.value = false;
    isPasswordsMatching.value = false;
  }

  @override
  void onClose() {
    // Clean up when controller is disposed
    clearForm();
    super.onClose();
  }
}
