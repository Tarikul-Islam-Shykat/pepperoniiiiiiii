import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:prettyrini/feature/diagnosis_v2/model/diagnosis_result_model.dart';
import 'package:prettyrini/feature/diagnosis_v2/ui/diagnosis_result_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class DiagnosisController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // Observables
  Rx<File?> selectedImage = Rx<File?>(null);
  RxBool isLoading = false.obs;
  Rx<DiagnosisResult?> diagnosisResult = Rx<DiagnosisResult?>(null);
  RxString errorMessage = ''.obs;
  RxBool showPreview = false.obs;

  // API endpoint
  static const String apiUrl = 'https://gg-dx.onrender.com/predict';

  // Pick image from camera
  Future<void> pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        showPreview.value = true;
        errorMessage.value = '';
      }
    } catch (e) {
      errorMessage.value = 'Error taking photo: $e';
    }
  }

  // Pick image from gallery
  Future<void> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        showPreview.value = true;
        errorMessage.value = '';
      }
    } catch (e) {
      errorMessage.value = 'Error selecting image: $e';
    }
  }

  // Add this to your diagnoseImage method in DiagnosisController

  Future<void> diagnoseImage() async {
    if (selectedImage.value == null) {
      errorMessage.value = 'Please select an image first';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(
        await http.MultipartFile.fromPath('image', selectedImage.value!.path),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      log("Status Code: ${response.statusCode}");
      log("Raw Response: $responseData");

      if (response.statusCode == 200) {
        var jsonData = json.decode(responseData);
        log("Parsed JSON: $jsonData"); // Add this line
        diagnosisResult.value = DiagnosisResult.fromJson(jsonData);

        // Debug the parsed result
        log("Diseases: ${diagnosisResult.value?.diseases}");
        log("Confidences: ${diagnosisResult.value?.confidences}");
        Get.to(DiagnosisResultScreen());
      } else {
        errorMessage.value = 'API Error: ${response.statusCode}';
      }
    } catch (e) {
      log("Error in diagnoseImage: $e"); // Add this line
      errorMessage.value = 'Network error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Diagnose the selected image
  // Future<void> diagnoseImage() async {
  //   if (selectedImage.value == null) {
  //     errorMessage.value = 'Please select an image first';
  //     return;
  //   }
  //   log("message 1");

  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';

  //     var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
  //     request.files.add(
  //       await http.MultipartFile.fromPath('image', selectedImage.value!.path),
  //     );
  //     log("message 2");

  //     var response = await request.send();
  //     var responseData = await response.stream.bytesToString();

  //     log("message ${response.statusCode} ${json.decode(responseData)}");
  //     if (response.statusCode == 200) {
  //       var jsonData = json.decode(responseData);
  //       diagnosisResult.value = DiagnosisResult.fromJson(jsonData);
  //     } else {
  //       errorMessage.value = 'API Error: ${response.statusCode}';
  //     }
  //   } catch (e) {
  //     errorMessage.value = 'Network error: $e';
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // Reset all data
  void reset() {
    selectedImage.value = null;
    diagnosisResult.value = null;
    errorMessage.value = '';
    showPreview.value = false;
    isLoading.value = false;
  }

  // Back to image selection
  void backToSelection() {
    showPreview.value = false;
    diagnosisResult.value = null;
    errorMessage.value = '';
  }

  // Get formatted problems for display
  List<Problem> get formattedProblems {
    if (diagnosisResult.value == null) return [];

    List<Problem> problems = [];

    for (int i = 0; i < diagnosisResult.value!.diseases.length; i++) {
      String disease = diagnosisResult.value!.diseases[i];
      double confidence = diagnosisResult.value!.confidences[i] /
          100.0; // Convert percentage to decimal

      // Map diseases to symptoms (you can customize this)
      List<String> symptoms = _getDiseaseSymptoms(disease);
      String duration = _getDiseaseDuration(disease);
      String severity = _getDiseaseSeverity(confidence);

      problems.add(Problem(
        name: disease,
        symptoms: symptoms,
        duration: duration,
        severity: severity,
      ));
    }

    return problems;
  }

  List<String> _getDiseaseSymptoms(String disease) {
    switch (disease.toLowerCase()) {
      case 'newcastle disease':
        return [
          'Respiratory distress',
          'Neurological signs',
          'Digestive issues'
        ];
      case 'infectious coryza':
        return ['Nasal discharge', 'Facial swelling', 'Respiratory issues'];
      case 'coccidiosis':
        return ['Diarrhea', 'Weight loss', 'Dehydration'];
      default:
        return ['Various symptoms', 'Consult veterinarian'];
    }
  }

  String _getDiseaseDuration(String disease) {
    switch (disease.toLowerCase()) {
      case 'newcastle disease':
        return '3-7 days';
      case 'infectious coryza':
        return '7-14 days';
      case 'coccidiosis':
        return '5-10 days';
      default:
        return '5-7 days';
    }
  }

  String _getDiseaseSeverity(double confidence) {
    if (confidence > 0.8) return 'High';
    if (confidence > 0.6) return 'Medium';
    return 'Low';
  }

  RxBool isSaving = false.obs;

// Save diagnosis function
  Future<void> saveDiagnosis() async {
    if (diagnosisResult.value == null) {
      errorMessage.value = 'No diagnosis result to save';
      return;
    }

    try {
      isSaving.value = true;
      errorMessage.value = '';

      // Get token from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); // Adjust key name as needed

      if (token == null || token.isEmpty) {
        errorMessage.value = 'Authentication token not found';
        return;
      }

      // Prepare the diagnosis data
      Map<String, dynamic> diagnosisData = {
        "problemCount": diagnosisResult.value!.diseases.length,
        "description": _generateDescriptions()
      };

      var request = http.MultipartRequest('POST',
          Uri.parse('https://pepperoniiiiii.vercel.app/api/v1/ai-diagnosis'));

      // Add headers
      request.headers['Authorization'] = '$token';

      // Add form data
      request.fields['data'] = json.encode(diagnosisData);

      // Add image file
      if (selectedImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', selectedImage.value!.path),
        );
      }

      log("Sending diagnosis data: ${json.encode(diagnosisData)}");

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      log("Save Status Code: ${response.statusCode}");
      log("Save Response: $responseData");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        Get.snackbar(
          'Success',
          'Diagnosis saved successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        errorMessage.value = 'Failed to save diagnosis: ${response.statusCode}';
        Get.snackbar(
          'Error',
          'Failed to save diagnosis',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log("Error saving diagnosis: $e");
      errorMessage.value = 'Network error while saving: $e';
      Get.snackbar(
        'Error',
        'Network error while saving',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }

// Generate descriptions based on diagnosis results
  List<String> _generateDescriptions() {
    List<String> descriptions = [];

    if (diagnosisResult.value == null) return descriptions;

    for (int i = 0; i < diagnosisResult.value!.diseases.length; i++) {
      String disease = diagnosisResult.value!.diseases[i];
      double confidence = diagnosisResult.value!.confidences[i];

      String description =
          _generateDiseaseDescription(disease, confidence, i + 1);
      descriptions.add(description);
    }

    return descriptions;
  }

// Generate individual disease description
  String _generateDiseaseDescription(
      String disease, double confidence, int rank) {
    String confidenceLevel = confidence > 60
        ? 'high'
        : confidence > 40
            ? 'moderate'
            : 'low';
    String rankText =
        rank == 1 ? 'Primary diagnosis' : 'Alternative diagnosis #$rank';

    switch (disease.toLowerCase()) {
      case 'newcastle disease':
        return '$rankText: Newcastle Disease detected with $confidenceLevel confidence (${confidence.toStringAsFixed(1)}%). Shows signs of respiratory distress and neurological symptoms.';
      case 'infectious coryza':
        return '$rankText: Infectious Coryza identified with $confidenceLevel confidence (${confidence.toStringAsFixed(1)}%). Exhibits nasal discharge and facial swelling symptoms.';
      case 'coccidiosis':
        return '$rankText: Coccidiosis diagnosed with $confidenceLevel confidence (${confidence.toStringAsFixed(1)}%). Shows signs of digestive issues and dehydration.';
      default:
        return '$rankText: $disease detected with $confidenceLevel confidence (${confidence.toStringAsFixed(1)}%). Requires veterinary consultation for proper treatment.';
    }
  }
}
