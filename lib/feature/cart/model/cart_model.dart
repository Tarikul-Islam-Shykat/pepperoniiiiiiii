// models/cart_model.dart

class CartItem {
  final String id;
  final String productId;
  final String name;
  final String image;
  final double price;
  int quantity;
  final double weight;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.weight,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>? ?? {};
    final images = product['images'] as List<dynamic>? ?? [];

    return CartItem(
      id: json['id'] ?? '',
      productId: product['id'] ?? '',
      name: product['name'] ?? '',
      image: images.isNotEmpty ? images[0].toString() : '',
      price: (product['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      weight: (product['weight'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'weight': weight,
    };
  }

  double get totalPrice => price * quantity;
}

class CartData {
  final List<CartItem> items;
  final double totalAmount;
  final int totalItems;

  CartData({
    required this.items,
    required this.totalAmount,
    required this.totalItems,
  });

  // Updated to handle your API response structure
  factory CartData.fromApiResponse(List<dynamic> cartItemsJson) {
    final items = cartItemsJson
        .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
        .toList();

    final totalItems = items.fold<int>(0, (sum, item) => sum + item.quantity);
    final totalAmount =
        items.fold<double>(0, (sum, item) => sum + item.totalPrice);

    return CartData(
      items: items,
      totalAmount: totalAmount,
      totalItems: totalItems,
    );
  }

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      totalItems: json['totalItems'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'totalItems': totalItems,
    };
  }
}
