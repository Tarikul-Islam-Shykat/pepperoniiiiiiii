class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  final double rating;
  final String weight;
  final int categoryId;
  final bool isTopSelling;
  final bool isNewProduct;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.rating,
    required this.weight,
    required this.categoryId,
    this.isTopSelling = false,
    this.isNewProduct = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      image: json['image'],
      rating: json['rating'].toDouble(),
      weight: json['weight'],
      categoryId: json['categoryId'],
      isTopSelling: json['isTopSelling'] ?? false,
      isNewProduct: json['isNewProduct'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'rating': rating,
      'weight': weight,
      'categoryId': categoryId,
      'isTopSelling': isTopSelling,
      'isNewProduct': isNewProduct,
    };
  }
}