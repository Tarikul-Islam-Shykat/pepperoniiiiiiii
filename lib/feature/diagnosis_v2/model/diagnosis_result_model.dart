class DiagnosisResult {
  final List<String> labels;
  final String imageBase64;

  // Parsed data from labels
  final List<String> diseases;
  final List<double> confidences;

  DiagnosisResult({
    required this.labels,
    required this.imageBase64,
    required this.diseases,
    required this.confidences,
  });

  factory DiagnosisResult.fromJson(Map<String, dynamic> json) {
    List<String> labels = List<String>.from(json['labels']);

    // Parse diseases and confidences from labels
    List<String> diseases = [];
    List<double> confidences = [];

    for (String label in labels) {
      // Split "Newcastle Disease: 44%" into disease and confidence
      List<String> parts = label.split(':');
      if (parts.length == 2) {
        String disease = parts[0].trim();
        String confidenceStr = parts[1].trim().replaceAll('%', '');

        diseases.add(disease);
        confidences.add(double.tryParse(confidenceStr) ?? 0.0);
      }
    }

    return DiagnosisResult(
      labels: labels,
      imageBase64: json['image_base64'] ?? '',
      diseases: diseases,
      confidences: confidences,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'labels': labels,
      'image_base64': imageBase64,
    };
  }
}

class Problem {
  final String name;
  final List<String> symptoms;
  final String duration;
  final String severity;

  Problem({
    required this.name,
    required this.symptoms,
    required this.duration,
    required this.severity,
  });
}
