class Career {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> skills;
  final List<String> tools;
  final String simulationType;
  final String deviceFeature;

  Career({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.skills,
    required this.tools,
    required this.simulationType,
    required this.deviceFeature,
  });

  factory Career.fromJson(Map<String, dynamic> json) {
    return Career(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
      skills: List<String>.from(json['skills'] as List),
      tools: List<String>.from(json['tools'] as List),
      simulationType: json['simulation_type'] as String,
      deviceFeature: json['device_feature'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'skills': skills,
      'tools': tools,
      'simulation_type': simulationType,
      'device_feature': deviceFeature,
    };
  }
}
