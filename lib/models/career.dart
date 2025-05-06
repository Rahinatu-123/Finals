class Career {
  final int id;
  final String title;
  final String description;
  final String skills;
  final String education;
  final String salaryRange;
  final String jobOutlook;
  final String? imagePath;
  final String? videoPath;
  final String? audioPath;
  final String? createdAt;
  final String? updatedAt;
  final List<String>? tools;
  final String? deviceFeature;

  Career({
    required this.id,
    required this.title,
    required this.description,
    required this.skills,
    required this.education,
    required this.salaryRange,
    required this.jobOutlook,
    this.imagePath,
    this.videoPath,
    this.audioPath,
    this.createdAt,
    this.updatedAt,
    this.tools,
    this.deviceFeature,
  });

  factory Career.fromJson(Map<String, dynamic> json) {
    return Career(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? 'Unknown title',
      description: json['description']?.toString() ?? 'No description available',
      skills: json['skills']?.toString() ?? '',
      education: json['education']?.toString() ?? '',
      salaryRange: json['salary_range']?.toString() ?? '',
      jobOutlook: json['job_outlook']?.toString() ?? '',
      imagePath: json['image_path']?.toString(),
      videoPath: json['video_path']?.toString(),
      audioPath: json['audio_path']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      tools: (json['tools'] as List?)?.map((e) => e.toString()).toList(),
      deviceFeature: json['device_feature']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'skills': skills,
      'education': education,
      'salary_range': salaryRange,
      'job_outlook': jobOutlook,
      'image_path': imagePath,
      'video_path': videoPath,
      'audio_path': audioPath,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'tools': tools,
      'device_feature': deviceFeature,
    };
  }
}
