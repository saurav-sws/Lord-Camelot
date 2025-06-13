class News {
  final int id;
  final String title;
  final String description;
  final String image;
  final String createdAt;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.createdAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'created_at': createdAt,
    };
  }
}
