import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static void show({required String message, required bool isSuccess}) {
    Get.snackbar(
      isSuccess ? 'Success' : 'Error',
      message,
      messageText: Text(
        message,
        style: TextStyle(
            fontSize: 16.sp, // Set font size for the message
            color: Colors.white,
            fontWeight: FontWeight.bold),
      ),
      icon: Icon(
        isSuccess ? Icons.check_circle_outline : Icons.warning_amber_outlined,
        color: Colors.white,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: isSuccess ? Colors.green : Colors.red,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(15),
      duration: const Duration(seconds: 2),
      isDismissible: true,
      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar(); // Close the current snackbar
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
        ),
        child: Text(
          'Dismiss',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
