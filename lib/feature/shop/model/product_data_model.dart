class Product {
  final String id;
  final String name;
  final String? description;
  final double price;
  final List<String> images;
  final double avgRating;
  final String? weight; // Keep as String for display
  final String? categoryId;
  final bool isTopSelling;
  final bool isNewProduct;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.images,
    required this.avgRating,
    this.weight,
    this.categoryId,
    this.isTopSelling = false,
    this.isNewProduct = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      price: _parseDouble(json['price']),
      images: _parseStringList(json['images']),
      avgRating: _parseDouble(json['avgRating']),
      weight: _parseWeight(json['weight']), // Handle weight conversion
      categoryId: json['categoryId']?.toString(),
      isTopSelling: json['isTopSelling'] ?? false,
      isNewProduct: json['isNewProduct'] ?? false,
    );
  }

  // Helper method to parse double values safely
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  // Helper method to parse string list safely
  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return [];
  }

  // Helper method to parse weight and convert to string with unit
  static String? _parseWeight(dynamic value) {
    if (value == null) return null;

    double weightValue;
    if (value is double) {
      weightValue = value;
    } else if (value is int) {
      weightValue = value.toDouble();
    } else if (value is String) {
      // If it's already a string, return as is
      return value;
    } else {
      return null;
    }

    // Convert numeric weight to string with appropriate unit
    if (weightValue < 1) {
      // Convert to grams if less than 1 kg
      return "${(weightValue * 1000).toInt()}g";
    } else {
      // Show in kg with 1 decimal place
      return "${weightValue.toStringAsFixed(1)}kg";
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'images': images,
      'avgRating': avgRating,
      'weight': weight,
      'categoryId': categoryId,
      'isTopSelling': isTopSelling,
      'isNewProduct': isNewProduct,
    };
  }

  // Helper method to get the first image or a placeholder
  String get primaryImage {
    return images.isNotEmpty ? images.first : '';
  }

  // Helper method to check if product has images
  bool get hasImages {
    return images.isNotEmpty;
  }

  // Helper method to get formatted price
  String get formattedPrice {
    return "\$${price.toStringAsFixed(2)}";
  }

  // Helper method to get formatted rating
  String get formattedRating {
    return avgRating > 0 ? "${avgRating.toStringAsFixed(1)}/5.0" : "No rating";
  }
}
