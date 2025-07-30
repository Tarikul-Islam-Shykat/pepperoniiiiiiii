import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prettyrini/feature/diagnosis_v2/controller/diagnosis_controller.dart';
import 'package:prettyrini/feature/diagnosis_v2/ui/diagnosis_result_screen.dart';
import 'package:prettyrini/feature/diagnosis_v2/ui/image_preview_screen.dart';

class ImageSelectionScreen extends StatelessWidget {
  final DiagnosisController controller = Get.put(DiagnosisController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () => Get.back(),
      //   ),
      //   title: Text(
      //     'AI Diagnosis',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontSize: 18,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      body: Obx(() {
        if (controller.showPreview.value) {
          return ImagePreviewScreen();
        }

        if (controller.diagnosisResult.value != null) {
          return DiagnosisResultScreen();
        }

        return ImageSelectionBody();
      }),
    );
  }
}

class ImageSelectionBody extends StatelessWidget {
  final DiagnosisController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Select Image Source',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Choose how you want to add an image',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48),

                // Camera Button
                Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.pickFromCamera,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2E7D32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, color: Colors.white, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Take Photo',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Gallery Button
                Container(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: controller.pickFromGallery,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFF2E7D32), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_library,
                            color: Color(0xFF2E7D32), size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Choose from Gallery',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Error message
          Obx(() {
            if (controller.errorMessage.value.isNotEmpty) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Text(
                  controller.errorMessage.value,
                  style: TextStyle(color: Colors.red[700]),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
