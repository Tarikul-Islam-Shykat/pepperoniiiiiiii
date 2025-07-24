
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:prettyrini/feature/diagnosis/controller/diagnosis_controller.dart';

class ResultsScreen extends StatelessWidget {
  final DiagnosisController controller = Get.find<DiagnosisController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Obx(() => Column(
          children: [
            // Top Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back, color: Colors.black87),
                  ),
                  Expanded(
                    child: Text(
                      'Diagnosis Result',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Image with Animation
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      height: controller.imageSlideBack.value ? 200 : 300,
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _buildImageWidget(),
                      ),
                    ),
                    
                    // Loading Analysis
                    if (controller.isAnalyzing.value) ...[
                      _buildAnalysisProgress(),
                      SizedBox(height: 20),
                    ],
                    
                    // Results with Animation
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 600),
                      opacity: controller.showResults.value ? 1.0 : 0.0,
                      child: AnimatedSlide(
                        duration: Duration(milliseconds: 600),
                        offset: controller.showResults.value 
                            ? Offset(0, 0) 
                            : Offset(0, 0.3),
                        child: _buildResultsWidget(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Try Again Button
            if (controller.showResults.value)
              Container(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: controller.resetAndGoBack,
                    icon: Icon(Icons.refresh, color: Colors.white),
                    label: Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        )),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (controller.base64Image.value.isNotEmpty && controller.showResults.value) {
      // Show processed image with bounding boxes
      Uint8List bytes = base64Decode(controller.base64Image.value);
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    } else if (controller.capturedImage.value != null) {
      // Show original image
      return Image.file(
        controller.capturedImage.value!,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    } else {
      return Container(
        color: Colors.grey[300],
        child: Center(child: Text('No image')),
      );
    }
  }

  Widget _buildAnalysisProgress() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.teal,
                ),
              ),
              SizedBox(width: 16),
              Text(
                'Analyzing image...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          LinearProgressIndicator(
            value: controller.analysisProgress.value,
            backgroundColor: Colors.grey[200],
            color: Colors.teal,
            minHeight: 6,
          ),
          SizedBox(height: 8),
          Text(
            '${(controller.analysisProgress.value * 100).toInt()}%',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsWidget() {
    if (controller.detectedDiseases.isEmpty) {
      return Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 48,
              color: Colors.green,
            ),
            SizedBox(height: 16),
            Text(
              'No diseases detected',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'The bird appears to be healthy',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detected Issues',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        ...controller.detectedDiseases.asMap().entries.map((entry) {
          int index = entry.key;
          String disease = entry.value;
          return _buildDiseaseCard(disease, index);
        }).toList(),
      ],
    );
  }

  Widget _buildDiseaseCard(String disease, int index) {
    double confidence = index < controller.confidenceScores.length 
        ? controller.confidenceScores[index] 
        : 0.0;
    
    Color confidenceColor = controller.getConfidenceColor(confidence);
    String accuracy = controller.getAccuracyPercentage(index);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: confidenceColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Problem',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: confidenceColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  accuracy,
                  style: TextStyle(
                    fontSize: 12,
                    color: confidenceColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            disease,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          // Animated Progress Bar
          TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 1000),
            tween: Tween(begin: 0.0, end: confidence),
            builder: (context, value, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Confidence Level',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${(value * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: value,
                    backgroundColor: Colors.grey[200],
                    color: confidenceColor,
                    minHeight: 4,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}