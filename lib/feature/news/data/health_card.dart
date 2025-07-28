class HealthCard {
  final String id;
  final String title;
  final String description;
  final String image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  HealthCard({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create HealthCard from API response
  factory HealthCard.fromJson(Map<String, dynamic> json) {
    return HealthCard(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  // Convert HealthCard to JSON (if needed for local storage or other purposes)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

enum HealthType {
  heart,
  blood,
  water,
  step,
  weight,
  health,
}
