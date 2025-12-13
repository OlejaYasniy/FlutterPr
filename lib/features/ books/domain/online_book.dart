enum OnlineSource { openLibrary, gutendex }

class OnlineBook {
  final OnlineSource source;
  final String title;
  final String author;
  final String? description;
  final String? coverUrl;
  final String? olEditionKey;
  final String? isbn;
  final int? gutendexId;

  const OnlineBook({
    required this.source,
    required this.title,
    required this.author,
    this.description,
    this.coverUrl,
    this.olEditionKey,
    this.isbn,
    this.gutendexId,
  });
}
