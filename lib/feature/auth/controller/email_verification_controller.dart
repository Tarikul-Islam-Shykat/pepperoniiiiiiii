import 'dart:convert';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network_caller/endpoints.dart';

class EmailVerificationController extends GetxController {
  final TextEditingController emailTEController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }


  @override
  void onClose() {
    // Dispose controllers
    emailTEController.dispose();
    super.onClose();
  }


}