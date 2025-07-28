import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:prettyrini/feature/diagnosis_v2/controller/diagnosis_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

class DiagnosisResultScreen extends StatelessWidget {
  final DiagnosisController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: controller.reset,
        ),
        title: Text(
          'Diagnosis Result',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final result = controller.diagnosisResult.value;
        if (result == null) return SizedBox.shrink();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Analyzed Image
              Container(
                height: 250,
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
                  child: result.imageBase64.isNotEmpty
                      ? Image.memory(
                          base64Decode(result.imageBase64),
                          fit: BoxFit.cover,
                        )
                      : controller.selectedImage.value != null
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

              // Results Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detected Problems',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Problem Cards
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: result.diseases.length,
                      itemBuilder: (context, index) {
                        String disease = result.diseases[index];
                        double confidence = result.confidences[index] /
                            100.0; // Convert percentage to decimal

                        return Container(
                          margin: EdgeInsets.only(bottom: 16),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Problem Header
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getProblemColor(disease)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Problem #${index + 1}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: _getProblemColor(disease),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors.grey[400],
                                  ),
                                ],
                              ),

                              SizedBox(height: 12),

                              // Disease Name
                              Text(
                                disease,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),

                              SizedBox(height: 8),

                              // Confidence (show as percentage)
                              Text(
                                'Confidence: ${result.confidences[index].toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),

                              SizedBox(height: 12),

                              // Confidence Bar
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: confidence,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _getConfidenceColor(confidence),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 12),

                              // Additional Info
                              Row(
                                children: [
                                  _buildInfoChip('Severity',
                                      _getSeverityLevel(confidence)),
                                  SizedBox(width: 8),
                                  _buildInfoChip('Duration',
                                      _getEstimatedDuration(disease)),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: controller.reset,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: Colors.grey[400]!, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              'New Diagnosis',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle save or share functionality
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2E7D32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                            ),
                            child: Text(
                              'Save Result',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getProblemColor(String disease) {
    switch (disease.toLowerCase()) {
      case 'newcastle disease':
        return Colors.red;
      case 'infectious coryza':
        return Colors.orange;
      case 'coccidiosis':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence > 0.6) return Colors.green;
    if (confidence > 0.4) return Colors.orange;
    return Colors.red;
  }

  String _getSeverityLevel(double confidence) {
    if (confidence > 0.6) return 'High';
    if (confidence > 0.4) return 'Medium';
    return 'Low';
  }

  String _getEstimatedDuration(String disease) {
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
}
