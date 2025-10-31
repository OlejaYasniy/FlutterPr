class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final DateTime createdAt;
  final bool isRead;
  final String? coverUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.description = "",
    required this.createdAt,
    this.isRead = false,
    this.coverUrl,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    DateTime? createdAt,
    bool? isRead,
    String? coverUrl,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      coverUrl: coverUrl ?? this.coverUrl,
    );
  }
}
