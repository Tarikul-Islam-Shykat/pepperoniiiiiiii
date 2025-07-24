import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network_caller/endpoints.dart';
import '../../auth/screen/login_screen.dart';

class ChangePaswordController extends GetxController {
  TextEditingController oldpaswordController = TextEditingController();
  TextEditingController newpaswordController = TextEditingController();
  TextEditingController confirmpaswordController = TextEditingController();

  void changePassword() async {
    if (newpaswordController.text != confirmpaswordController.text) {
      Get.snackbar("Error", "Password not match");
    } else {
      if (newpaswordController.text.length <= 7 ||
          oldpaswordController.text.length <= 7) {
        Get.snackbar("Error", "Password must be at least 8 characters long.");
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString("token") ?? "";
        if (token.isEmpty) {
          Get.offAll(() => LoginScreen());
        } else if (oldpaswordController.text == newpaswordController.text) {
          Get.snackbar("Error", "New password can't be same as old password");
        } else {
          try {
            EasyLoading.show(status: "Processing...");
            final response = await http.put(
              Uri.parse('${Urls.baseUrl}/auth/change-password'),
              headers: {"Authorization": token},
              body: {
                'newPassword': newpaswordController.text,
                'oldPassword': oldpaswordController.text,
              },
            );

            if (kDebugMode) {
              print(response.body);
            }
            if (response.statusCode == 201) {
              var data = jsonDecode(response.body);
              if (data['success'] == true) {
                Get.snackbar(
                  "Success",
                  "Password changed successfully Please login again",
                );
                Future.delayed(Duration(seconds: 2), () {
                  Get.offAll(() => LoginScreen());
                });
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
            EasyLoading.dismiss();
          }
        }
      }
    }
  }
}
