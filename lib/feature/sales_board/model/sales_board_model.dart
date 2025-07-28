// models/sales_board_model.dart
class SalesBoardPost {
  final String id;
  final String description;
  final String? image;
  final double price;
  final int quantity;
  final SalesBoardUser user;

  SalesBoardPost({
    required this.id,
    required this.description,
    this.image,
    required this.price,
    required this.quantity,
    required this.user,
  });

  factory SalesBoardPost.fromJson(Map<String, dynamic> json) {
    return SalesBoardPost(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      user: SalesBoardUser.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'image': image,
      'price': price,
      'quantity': quantity,
      'user': user.toJson(),
    };
  }
}

class SalesBoardUser {
  final String fullName;
  final String? image;
  final String? location;

  SalesBoardUser({
    required this.fullName,
    this.image,
    this.location,
  });

  factory SalesBoardUser.fromJson(Map<String, dynamic> json) {
    return SalesBoardUser(
      fullName: json['fullName'] ?? '',
      image: json['image'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'image': image,
      'location': location,
    };
  }
}

class SalesBoardResponse {
  final bool success;
  final String message;
  final SalesBoardData data;

  SalesBoardResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SalesBoardResponse.fromJson(Map<String, dynamic> json) {
    return SalesBoardResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: SalesBoardData.fromJson(json['data'] ?? {}),
    );
  }
}

class SalesBoardData {
  final SalesBoardMeta meta;
  final List<SalesBoardPost> data;

  SalesBoardData({
    required this.meta,
    required this.data,
  });

  factory SalesBoardData.fromJson(Map<String, dynamic> json) {
    return SalesBoardData(
      meta: SalesBoardMeta.fromJson(json['meta'] ?? {}),
      data: (json['data'] as List?)
              ?.map((item) => SalesBoardPost.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class SalesBoardMeta {
  final int page;
  final int limit;
  final int total;

  SalesBoardMeta({
    required this.page,
    required this.limit,
    required this.total,
  });

  factory SalesBoardMeta.fromJson(Map<String, dynamic> json) {
    return SalesBoardMeta(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
    );
  }
}
