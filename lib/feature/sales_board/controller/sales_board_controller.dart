// controllers/sales_board_controller.dart
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:prettyrini/core/global_widegts/app_snackbar.dart'
    show AppSnackbar;
import 'package:prettyrini/core/network_caller/endpoints.dart';
import 'package:prettyrini/core/network_caller/network_config.dart';
import 'package:prettyrini/core/services_class/local/user_info.dart';
import 'package:prettyrini/feature/sales_board/model/sales_board_model.dart';
// Import your required files
// import '../models/sales_board_model.dart';
// import '../services/network_config.dart';
// import '../services/local_service.dart';
// import '../utils/app_snackbar.dart';
// import '../utils/urls.dart';

class SalesBoardController extends GetxController {
  final NetworkConfig _networkConfig = NetworkConfig();
  final ImagePicker _picker = ImagePicker();

  // Observable variables
  final RxBool _isLoading = false.obs;
  final RxBool _isPosting = false.obs;
  final RxList<SalesBoardPost> _salesBoardPosts = <SalesBoardPost>[].obs;
  final Rx<File?> _selectedImage = Rx<File?>(null);
  final RxDouble _uploadProgress = 0.0.obs;

  // Text controllers
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isPosting => _isPosting.value;
  List<SalesBoardPost> get salesBoardPosts => _salesBoardPosts;
  File? get selectedImage => _selectedImage.value;
  double get uploadProgress => _uploadProgress.value;

  @override
  void onInit() {
    super.onInit();
    loadSalesBoardPosts();
  }

  @override
  void onClose() {
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.onClose();
  }

  // Load sales board posts from API
  Future<bool> loadSalesBoardPosts() async {
    try {
      _isLoading.value = true;

      final response = await _networkConfig.ApiRequestHandler(
        RequestMethod.GET,
        "${Urls.baseUrl}/sales-board", // Add this URL to your Urls class: /sales-board
        json.encode({}),
        is_auth: true,
      );

      log("loadSalesBoardPosts response: ${response.toString()}");

      if (response != null && response['success'] == true) {
        final salesBoardResponse = SalesBoardResponse.fromJson(response);
        _salesBoardPosts.value = salesBoardResponse.data.data;
        return true;
      } else {
        final errorMessage =
            response?['message'] ?? 'Failed to load sales board posts';
        AppSnackbar.show(message: errorMessage, isSuccess: false);
        return false;
      }
    } catch (e) {
      log("Error loading sales board posts: $e");
      AppSnackbar.show(
          message: "Failed to load sales board: $e", isSuccess: false);
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

  // Post new sales board data
  Future<bool> postSalesBoardData() async {
    if (descriptionController.text.trim().isEmpty) {
      AppSnackbar.show(
        message: 'Please enter a description',
        isSuccess: false,
      );
      return false;
    }

    if (priceController.text.trim().isEmpty) {
      AppSnackbar.show(
        message: 'Please enter a price',
        isSuccess: false,
      );
      return false;
    }

    if (quantityController.text.trim().isEmpty) {
      AppSnackbar.show(
        message: 'Please enter quantity',
        isSuccess: false,
      );
      return false;
    }

    // Validate price and quantity are numbers
    final double? price = double.tryParse(priceController.text.trim());
    final int? quantity = int.tryParse(quantityController.text.trim());

    if (price == null || price <= 0) {
      AppSnackbar.show(
        message: 'Please enter a valid price',
        isSuccess: false,
      );
      return false;
    }

    if (quantity == null || quantity <= 0) {
      AppSnackbar.show(
        message: 'Please enter a valid quantity',
        isSuccess: false,
      );
      return false;
    }

    try {
      _isPosting.value = true;
      _uploadProgress.value = 0.0;

      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${Urls.baseUrl}/sales-board"), // Sales board endpoint
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
        "price": price,
        "quantity": quantity,
      };

      // Add the data field as JSON string
      request.fields['data'] = json.encode(postData);

      // Add image if selected
      if (_selectedImage.value != null) {
        var imageBytes = await _selectedImage.value!.readAsBytes();
        var multipartFile = http.MultipartFile.fromBytes(
          'image', // Field name for image
          imageBytes,
          filename: 'sales_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        request.files.add(multipartFile);
      }

      log("Posting sales board data: ${json.encode(postData)}");
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

      log("Sales board post response: $responseJson");
      log("Status code: ${response.statusCode}");

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseJson['success'] == true) {
        AppSnackbar.show(
          message: "Product posted successfully!",
          isSuccess: true,
        );

        // Clear form and refresh posts
        clearForm();
        await loadSalesBoardPosts();
        return true;
      } else {
        final errorMessage =
            responseJson['message'] ?? 'Product posting failed';
        log("Product posting failed: $errorMessage");
        AppSnackbar.show(
          message: errorMessage,
          isSuccess: false,
        );
        return false;
      }
    } catch (e) {
      log("Sales board post error: $e");
      AppSnackbar.show(
        message: 'Product posting failed: ${e.toString()}',
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
    priceController.clear();
    quantityController.clear();
    _selectedImage.value = null;
  }

  // Refresh posts
  Future<void> refreshPosts() async {
    await loadSalesBoardPosts();
  }
}
