import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:prettyrini/core/services_class/local/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prettyrini/core/global_widegts/app_snackbar.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';
import '../../../core/network_caller/endpoints.dart';

class EditProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final NetworkConfig _networkConfig = NetworkConfig();
  final ImagePicker _picker = ImagePicker();

  // Observable variables
  final isLoading = false.obs;
  final isUpdating = false.obs;
  final profileImage = Rxn<File>();
  final profileImageUrl = ''.obs;
  final uploadProgress = 0.0.obs;
  final errorMessage = ''.obs;

  // User data
  final userData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  // Fetch user profile data
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      log("fetchUserProfile ");
      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        Urls.getProfile,
        jsonEncode({}),
        is_auth: true,
      );

      if (response != null && response['success'] == true) {
        userData.value = response['data'];
        // Set form data
        nameController.text = response['data']['fullName'] ?? '';
        emailController.text = response['data']['email'] ?? '';
        phoneController.text = response['data']['phoneNumber'] ?? '';
        profileImageUrl.value = response['data']['image'] ?? '';

        log("Profile data fetched successfully: ${response['data']}");
      } else {
        errorMessage.value = response?['message'] ?? 'Failed to fetch profile';
        AppSnackbar.show(
          message: errorMessage.value,
          isSuccess: false,
        );
      }
    } catch (e) {
      log("Error fetching profile: $e");
      errorMessage.value = 'Failed to fetch profile: ${e.toString()}';
      AppSnackbar.show(
        message: errorMessage.value,
        isSuccess: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Image selection methods
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        profileImage.value = File(image.path);
        log("Image selected from camera: ${image.path}");
      }
    } catch (e) {
      log("Error picking image from camera: $e");
      AppSnackbar.show(
        message: 'Failed to capture image: ${e.toString()}',
        isSuccess: false,
      );
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        profileImage.value = File(image.path);
        log("Image selected from gallery: ${image.path}");
      }
    } catch (e) {
      log("Error picking image from gallery: $e");
      AppSnackbar.show(
        message: 'Failed to select image: ${e.toString()}',
        isSuccess: false,
      );
    }
  }

  void removeProfileImage() {
    profileImage.value = null;
    profileImageUrl.value = '';
    log("Profile image removed");
  }

  void clearImage() {
    profileImage.value = null;
  }

  // Update profile
  Future<bool> updateProfile() async {
    if (nameController.text.trim().isEmpty) {
      AppSnackbar.show(
        message: 'Please enter your full name',
        isSuccess: false,
      );
      return false;
    }

    try {
      isUpdating.value = true;
      errorMessage.value = '';
      uploadProgress.value = 0.0;

      final request = http.MultipartRequest(
        'PUT',
        Uri.parse("${Urls.baseUrl}/users/profile"),
      );

      // Get token from local storage
      var localService = LocalService();
      String? token = await localService.getToken();

      if (token == null) {
        AppSnackbar.show(
          message: 'Authentication token not found',
          isSuccess: false,
        );
        return false;
      }

      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization': token,
      });

      // Create the JSON data for the data field
      Map<String, dynamic> updateData = {
        "fullName": nameController.text.trim(),
      };

      // Add the data field as JSON string
      request.fields['data'] = json.encode(updateData);

      // Add image if selected
      if (profileImage.value != null) {
        var imageBytes = await profileImage.value!.readAsBytes();
        var multipartFile = http.MultipartFile.fromBytes(
          'image', // Field name for image
          imageBytes,
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        request.files.add(multipartFile);
      }

      log("Updating profile with data: ${json.encode(updateData)}");
      log("Image attached: ${profileImage.value != null}");

      // Send request with progress tracking
      var streamedResponse = await request.send();

      // Simulate progress for better UX
      for (int i = 0; i <= 100; i += 10) {
        uploadProgress.value = i.toDouble();
        await Future.delayed(Duration(milliseconds: 50));
      }

      final response = await http.Response.fromStream(streamedResponse);
      final responseJson = json.decode(response.body);

      log("Profile update response: $responseJson");
      log("Status code: ${response.statusCode}");

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseJson['success'] == true) {
        AppSnackbar.show(
          message: "Profile updated successfully!",
          isSuccess: true,
        );

        // Clear selected image and refresh profile data
        clearImage();
        await fetchUserProfile();
        Get.back();
        return true;
      } else {
        errorMessage.value = responseJson['message'] ?? 'Update failed';
        log("Update failed: ${responseJson['message']}");
        AppSnackbar.show(
          message: errorMessage.value,
          isSuccess: false,
        );
        return false;
      }
    } catch (e) {
      log("Profile update error: $e");
      errorMessage.value = 'Update failed: ${e.toString()}';
      AppSnackbar.show(
        message: errorMessage.value,
        isSuccess: false,
      );
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  // Validation methods
  bool get isFormValid {
    return nameController.text.trim().isNotEmpty;
  }

  bool get hasChanges {
    return nameController.text.trim() != (userData['fullName'] ?? '') ||
        profileImage.value != null;
  }
}
