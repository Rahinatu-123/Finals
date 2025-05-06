class TechWord {
  final String id;
  final String term;
  final String definition;
  final String userId;
  final DateTime createdAt;
  final bool isApproved;

  TechWord({
    required this.id,
    required this.term,
    required this.definition,
    required this.userId,
    required this.createdAt,
    required this.isApproved,
  });

  factory TechWord.fromJson(Map<String, dynamic> json) {
    return TechWord(
      id: json['id'] as String,
      term: json['term'] as String,
      definition: json['definition'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isApproved: json['is_approved'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'term': term,
      'definition': definition,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'is_approved': isApproved,
    };
  }
}
