import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network_caller/endpoints.dart';

class ProfileSetupController extends GetxController {
  //from this need to send in api
  TextEditingController firstNameTEController = TextEditingController();
  TextEditingController lastNameTEController = TextEditingController();
  TextEditingController dobNameTEController = TextEditingController();
  TextEditingController heightNameTEController = TextEditingController();
  TextEditingController weightNameTEController = TextEditingController();
  TextEditingController genderTEController = TextEditingController();
  TextEditingController positionTEController = TextEditingController();
  TextEditingController playerTEController = TextEditingController();
  //to this need to send in api
  var selectedGender = ''.obs;
  var playerPosition = ''.obs;
  final isAccepted = false.obs;

  void setGender(String gender) {
    selectedGender.value = gender;
    genderTEController.text = gender;
  }

  void setPlayer(String player) {
    playerPosition.value = player;
    positionTEController.text = player;
  }

  RxString imagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  // ignore: unnecessary_overrides
  void onInit() {
    super.onInit();
  }

  /// Request permissions for Camera and Photos
  Future<void> _requestPermissions() async {
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }

    if (await Permission.photos.isDenied) {
      await Permission.photos.request();
    }
  }

  /// Method to select image either from camera or gallery
  Future<void> pickImage() async {
    try {
      await _requestPermissions();

      final ImageSource? source = await Get.defaultDialog<ImageSource>(
        title: "Select Image Source",
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Gallery"),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text("Camera"),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
          ],
        ),
      );

      if (source == null) {
        return;
      }

      final XFile? image = await _picker.pickImage(source: source);

      if (image != null) {
        imagePath.value = image.path;
        GetSnackBar(
          title: "Image Selected",
          message: "You have successfully selected an image.",
        );
      } else {
        GetSnackBar(
          title: "No Image Selected",
          message: "You didn't select any image.",
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("An error occurred while selecting the image: $e");
      }
    }
  }

  Future<void> updateProfile() async {
    // Retrieve token from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      GetSnackBar(title: "Error", message: "Authorization token not found.");
      return;
    }

    var request = http.MultipartRequest('PUT', Uri.parse(Urls.setupProfile));

    // Add Authorization header
    request.headers['Authorization'] = token;

    // Create a map for the data fields
    Map<String, String> dataFields = {
      'firstName': firstNameTEController.text,
      'lastName': lastNameTEController.text,
      'dob': dobNameTEController.text,
      'height': heightNameTEController.text,
      'weight': weightNameTEController.text,
      'gender': selectedGender.value,
      'position': playerPosition.value,
    };

    // Serialize the map to a JSON string
    String jsonData = jsonEncode(dataFields);

    // Add the JSON string as a field named 'data'
    request.fields['data'] = jsonData;

    // Check if an image has been selected
    if (imagePath.value.isNotEmpty) {
      File imageFile = File(imagePath.value);

      if (await imageFile.exists()) {
        var stream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: basename(imageFile.path),
        );
        request.files.add(multipartFile);
      } else {
        GetSnackBar(
          title: "File Error",
          message: "The selected image file does not exist.",
        );
        return;
      }
    }

    try {
      EasyLoading.show(status: "Please wait...");
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Response Body: ${response.body}');
        }
        GetSnackBar(title: "Success", message: "Profile updated successfully.");
        //Get.offAll(() => SubscriptionScreen());
      } else {
        if (kDebugMode) {
          print('Error Response Body: ${response.body}');
        }
        GetSnackBar(
          title: "Error",
          message:
              "Failed to update profile. Status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      GetSnackBar(title: "Exception", message: "An error occurred: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }
}
