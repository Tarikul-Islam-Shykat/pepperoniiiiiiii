import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class DiagnosisController extends GetxController {
  // Camera related
  CameraController? cameraController;
  RxBool isCameraInitialized = false.obs;
  RxList<CameraDescription> cameras = <CameraDescription>[].obs;
  
  // UI States
  RxBool isLoading = false.obs;
  RxBool isAnalyzing = false.obs;
  RxDouble analysisProgress = 0.0.obs;
  
  // Image and Results
  Rx<File?> capturedImage = Rx<File?>(null);
  RxString base64Image = ''.obs;
  RxList<String> detectedDiseases = <String>[].obs;
  RxList<double> confidenceScores = <double>[].obs;
  
  // Animation states
  RxBool showResults = false.obs;
  RxBool imageSlideBack = false.obs;
  
  // API endpoint
  final String apiUrl = 'https://gg-dx.onrender.com/predict';

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  Future<void> initializeCamera() async {
    try {
      cameras.value = await availableCameras();
      if (cameras.isNotEmpty) {
        cameraController = CameraController(
          cameras.first,
          ResolutionPreset.high,
          enableAudio: false,
        );
        
        await cameraController!.initialize();
        isCameraInitialized.value = true;
      }
    } catch (e) {
      print('Error initializing camera: $e');
      Get.snackbar('Error', 'Failed to initialize camera');
    }
  }

  Future<void> captureImage() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile image = await cameraController!.takePicture();
      capturedImage.value = File(image.path);
      
      // Navigate to preview screen
      Get.toNamed('/preview');
    } catch (e) {
      print('Error capturing image: $e');
      Get.snackbar('Error', 'Failed to capture image');
    }
  }

  Future<void> startDiagnosis() async {
    if (capturedImage.value == null) return;

    try {
      isAnalyzing.value = true;
      analysisProgress.value = 0.0;
      
      // Simulate progress animation
      _simulateProgress();
      
      // Prepare multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(
        await http.MultipartFile.fromPath('file', capturedImage.value!.path),
      );

      // Send request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        var jsonData = json.decode(responseData);
        
        // Parse results
        detectedDiseases.value = List<String>.from(jsonData['result'] ?? []);
        confidenceScores.value = List<double>.from(
          (jsonData['confidence'] ?? []).map((e) => e.toDouble()),
        );
        base64Image.value = jsonData['image_base64'] ?? '';
        
        // Complete progress and show results
        analysisProgress.value = 1.0;
        await Future.delayed(Duration(milliseconds: 500));
        
        _showResultsWithAnimation();
      } else {
        throw Exception('API call failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during diagnosis: $e');
      Get.snackbar('Error', 'Failed to analyze image. Please try again.');
      isAnalyzing.value = false;
      analysisProgress.value = 0.0;
    }
  }

  void _simulateProgress() async {
    for (int i = 0; i < 80; i++) {
      await Future.delayed(Duration(milliseconds: 50));
      if (analysisProgress.value < 0.8) {
        analysisProgress.value += 0.01;
      }
    }
  }

  void _showResultsWithAnimation() async {
    imageSlideBack.value = true;
    await Future.delayed(Duration(milliseconds: 300));
    showResults.value = true;
    isAnalyzing.value = false;
  }

  void resetAndGoBack() {
    // Reset all states
    capturedImage.value = null;
    base64Image.value = '';
    detectedDiseases.clear();
    confidenceScores.clear();
    isAnalyzing.value = false;
    analysisProgress.value = 0.0;
    showResults.value = false;
    imageSlideBack.value = false;
    
    // Go back to camera
    Get.offAllNamed('/camera');
  }

  String getAccuracyPercentage(int index) {
    if (index < confidenceScores.length) {
      return '${(confidenceScores[index] * 100).toInt()}%';
    }
    return '0%';
  }

  Color getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Color(0xFFE53E3E); // High confidence - Red
    if (confidence >= 0.6) return Color(0xFFED8936); // Medium confidence - Orange
    return Color(0xFFECC94B); // Low confidence - Yellow
  }
}