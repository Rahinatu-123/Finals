class Story {
  final String id;
  final String name;
  final String role;
  final String content;
  final String? imageUrl;
  final String? videoUrl;
  final DateTime createdAt;
  final String userId;

  Story({
    required this.id,
    required this.name,
    required this.role,
    required this.content,
    this.imageUrl,
    this.videoUrl,
    required this.createdAt,
    required this.userId,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      videoUrl: json['video_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      userId: json['user_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'content': content,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
    };
  }
}
