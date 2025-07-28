// controllers/forum_controller.dart
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:prettyrini/core/global_widegts/app_snackbar.dart';
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';
import 'package:prettyrini/core/services_class/local/user_info.dart';
import 'package:prettyrini/feature/forum/model/forum_model.dart';
// Import your required files
// import '../models/forum_model.dart';
// import '../services/network_config.dart';
// import '../services/local_service.dart';
// import '../utils/app_snackbar.dart';
// import '../utils/urls.dart';

class ForumController extends GetxController {
  final NetworkConfig _networkConfig = NetworkConfig();
  final ImagePicker _picker = ImagePicker();

  // Observable variables
  final RxBool _isLoading = false.obs;
  final RxBool _isPosting = false.obs;
  final RxList<ForumPost> _forumPosts = <ForumPost>[].obs;
  final Rx<File?> _selectedImage = Rx<File?>(null);
  final RxDouble _uploadProgress = 0.0.obs;

  // Text controllers
  final TextEditingController descriptionController = TextEditingController();

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isPosting => _isPosting.value;
  List<ForumPost> get forumPosts => _forumPosts;
  File? get selectedImage => _selectedImage.value;
  double get uploadProgress => _uploadProgress.value;

  @override
  void onInit() {
    super.onInit();
    loadForumPosts();
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }

  // Load forum posts from API
  Future<bool> loadForumPosts() async {
    try {
      _isLoading.value = true;

      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        "${Urls.baseUrl}/forum",
        json.encode({}),
        is_auth: true,
      );

      log("loadForumPosts response: ${response.toString()}");

      if (response != null && response['success'] == true) {
        final forumResponse = ForumResponse.fromJson(response);
        _forumPosts.value = forumResponse.data.data;
        return true;
      } else {
        final errorMessage =
            response?['message'] ?? 'Failed to load forum posts';
        AppSnackbar.show(message: errorMessage, isSuccess: false);
        return false;
      }
    } catch (e) {
      log("Error loading forum posts: $e");
      AppSnackbar.show(message: "Failed to load forum: $e", isSuccess: false);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Pick image from gallery
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        _selectedImage.value = File(image.path);
      }
    } catch (e) {
      log("Error picking image: $e");
      AppSnackbar.show(message: "Failed to pick image", isSuccess: false);
    }
  }

  // Remove selected image
  void removeImage() {
    _selectedImage.value = null;
  }

  // Post new forum data
  Future<bool> postForumData() async {
    if (descriptionController.text.trim().isEmpty) {
      AppSnackbar.show(
        message: 'Please enter a description',
        isSuccess: false,
      );
      return false;
    }

    try {
      _isPosting.value = true;
      _uploadProgress.value = 0.0;

      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${Urls.baseUrl}/forum"), // Add this endpoint to your Urls
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
      Map<String, dynamic> postData = {
        "description": descriptionController.text.trim(),
      };

      // Add the data field as JSON string
      request.fields['data'] = json.encode(postData);

      // Add image if selected
      if (_selectedImage.value != null) {
        var imageBytes = await _selectedImage.value!.readAsBytes();
        var multipartFile = http.MultipartFile.fromBytes(
          'image', // Field name for image
          imageBytes,
          filename: 'forum_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        request.files.add(multipartFile);
      }

      log("Posting forum data: ${json.encode(postData)}");
      log("Image attached: ${_selectedImage.value != null}");

      // Send request with progress tracking
      var streamedResponse = await request.send();

      // Simulate progress for better UX
      for (int i = 0; i <= 100; i += 10) {
        _uploadProgress.value = i.toDouble();
        await Future.delayed(Duration(milliseconds: 50));
      }

      final response = await http.Response.fromStream(streamedResponse);
      final responseJson = json.decode(response.body);

      log("Forum post response: $responseJson");
      log("Status code: ${response.statusCode}");

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseJson['success'] == true) {
        AppSnackbar.show(
          message: "Post created successfully!",
          isSuccess: true,
        );

        // Clear form and refresh posts
        clearForm();
        await loadForumPosts();
        return true;
      } else {
        final errorMessage = responseJson['message'] ?? 'Post creation failed';
        log("Post creation failed: $errorMessage");
        AppSnackbar.show(
          message: errorMessage,
          isSuccess: false,
        );
        return false;
      }
    } catch (e) {
      log("Forum post error: $e");
      AppSnackbar.show(
        message: 'Post creation failed: ${e.toString()}',
        isSuccess: false,
      );
      return false;
    } finally {
      _isPosting.value = false;
      _uploadProgress.value = 0.0;
    }
  }

  // Clear form data
  void clearForm() {
    descriptionController.clear();
    _selectedImage.value = null;
  }

  // Refresh posts
  Future<void> refreshPosts() async {
    await loadForumPosts();
  }
}
