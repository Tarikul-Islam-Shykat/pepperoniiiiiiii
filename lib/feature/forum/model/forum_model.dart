// models/forum_model.dart
class ForumPost {
  final String id;
  final String description;
  final String? image;
  final ForumUser user;
  final List<ForumReact> forumReact;

  ForumPost({
    required this.id,
    required this.description,
    this.image,
    required this.user,
    required this.forumReact,
  });

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      user: ForumUser.fromJson(json['user'] ?? {}),
      forumReact: (json['ForumReact'] as List?)
              ?.map((item) => ForumReact.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'image': image,
      'user': user.toJson(),
      'ForumReact': forumReact.map((item) => item.toJson()).toList(),
    };
  }
}

class ForumUser {
  final String fullName;
  final String? image;
  final String? location;

  ForumUser({
    required this.fullName,
    this.image,
    this.location,
  });

  factory ForumUser.fromJson(Map<String, dynamic> json) {
    return ForumUser(
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

class ForumReact {
  // Add properties as needed based on your react structure

  ForumReact();

  factory ForumReact.fromJson(Map<String, dynamic> json) {
    return ForumReact();
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class ForumResponse {
  final bool success;
  final String message;
  final ForumData data;

  ForumResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ForumResponse.fromJson(Map<String, dynamic> json) {
    return ForumResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ForumData.fromJson(json['data'] ?? {}),
    );
  }
}

class ForumData {
  final ForumMeta meta;
  final List<ForumPost> data;

  ForumData({
    required this.meta,
    required this.data,
  });

  factory ForumData.fromJson(Map<String, dynamic> json) {
    return ForumData(
      meta: ForumMeta.fromJson(json['meta'] ?? {}),
      data: (json['data'] as List?)
              ?.map((item) => ForumPost.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class ForumMeta {
  final int page;
  final int limit;
  final int total;

  ForumMeta({
    required this.page,
    required this.limit,
    required this.total,
  });

  factory ForumMeta.fromJson(Map<String, dynamic> json) {
    return ForumMeta(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
    );
  }
}
