class Story {
  final int id;
  final String title;
  final String content;
  final String author;
  final String date;
  final String category;

  Story({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.date,
    required this.category,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      title: json['title'] ?? 'Unknown title',
      content: json['content'] ?? 'No content available',
      author: json['author'] ?? 'Unknown author',
      date: json['date'] ?? 'Unknown date',
      category: json['category'] ?? 'General',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'date': date,
      'category': category,
    };
  }
}
