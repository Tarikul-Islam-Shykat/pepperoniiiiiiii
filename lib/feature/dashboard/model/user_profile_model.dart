class UserProfile {
  final String name;
  final String imageUrl;

  UserProfile({required this.name, required this.imageUrl});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? 'Kathryn Murphy',
      imageUrl: json['picture']['medium'] ?? 'https://randomuser.me/api/portraits/women/1.jpg',
    );
  }
}