import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:prettyrini/feature/diagnosis_v2/controller/diagnosis_controller.dart';

class ImagePreviewScreen extends StatelessWidget {
  final DiagnosisController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: controller.backToSelection,
      //   ),
      //   title: Text(
      //     'Image Preview',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontSize: 18,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: controller.selectedImage.value != null
                      ? Image.file(
                          controller.selectedImage.value!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Icon(
                              Icons.image,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                ),
              ),
            ),

            // Bottom section with buttons
            Container(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  // Loading state
                  if (controller.isLoading.value)
                    Column(
                      children: [
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Analyzing image...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 24),
                      ],
                    ),

                  // Error message
                  if (controller.errorMessage.value.isNotEmpty)
                    Container(
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
                    ),

                  // Diagnose Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.diagnoseImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2E7D32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.psychology,
                                    color: Colors.white, size: 24),
                                SizedBox(width: 12),
                                Text(
                                  'Diagnose Now',
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

                  SizedBox(height: 12),

                  // Retake Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.backToSelection,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[400]!, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh,
                              color: Colors.grey[600], size: 24),
                          SizedBox(width: 12),
                          Text(
                            'Retake Photo',
                            style: TextStyle(
                              color: Colors.grey[600],
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
          ],
        );
      }),
    );
  }
}
