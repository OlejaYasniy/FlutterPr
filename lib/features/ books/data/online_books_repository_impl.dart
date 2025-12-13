import '../domain/online_book.dart';
import '../domain/online_books_repository.dart';
import 'remote/open_library_client.dart';
import 'remote/open_library_books_client.dart';
import 'remote/gutendex_client.dart';

class OnlineBooksRepositoryImpl implements OnlineBooksRepository {
  OnlineBooksRepositoryImpl({
    required OpenLibraryClient openLibrary,
    required OpenLibraryBooksClient openLibraryBooks,
    required GutendexClient gutendex,
  })  : _ol = openLibrary,
        _olBooks = openLibraryBooks,
        _gut = gutendex;

  final OpenLibraryClient _ol;
  final OpenLibraryBooksClient _olBooks;
  final GutendexClient _gut;

  @override
  Future<List<OnlineBook>> searchOpenLibrary(String query) async {
    final raw = await _ol.search(query);
    final json = _asMap(raw);

    final docs = (json['docs'] as List?) ?? const [];

    return docs.take(20).map((e) {
      final m = _asMap(e);

      final title = _str(m['title'])?.trim();
      final authors = _asList(m['author_name'])
          .map((x) => x.toString())
          .where((s) => s.trim().isNotEmpty)
          .toList();
      final author = authors.isNotEmpty ? authors.first : '—';

      final editionKeys = _asList(m['edition_key']).map((x) => x.toString()).toList();
      final olEditionKey = editionKeys.isNotEmpty ? '/books/${editionKeys.first}' : null;

      final isbns = _asList(m['isbn']).map((x) => x.toString()).toList();
      final isbn = isbns.isNotEmpty ? isbns.first : null;

      final coverI = m['cover_i'];
      final coverUrl = coverI != null ? 'https://covers.openlibrary.org/b/id/$coverI-L.jpg' : null;

      return OnlineBook(
        source: OnlineSource.openLibrary,
        title: (title == null || title.isEmpty) ? 'Без названия' : title,
        author: author,
        coverUrl: coverUrl,
        olEditionKey: olEditionKey,
        isbn: isbn,
      );
    }).toList();
  }

  @override
  Future<OnlineBook?> openLibraryByIsbn(String isbn) async {
    final raw = await _olBooks.byIsbn('ISBN:$isbn', 'json', 'data');
    final json = _asMap(raw);

    final key = 'ISBN:$isbn';
    final data = json[key];
    if (data == null) return null;

    final m = _asMap(data);

    final title = _str(m['title']) ?? 'Без названия';

    final authors = _asList(m['authors'])
        .map((a) => _str(_asMap(a)['name']))
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .toList();
    final author = authors.isNotEmpty ? authors.first : '—';

    final cover = _asMap(m['cover']);
    final coverUrl = _str(cover['large']) ?? _str(cover['medium']) ?? _str(cover['small']);

    final subtitle = _str(m['subtitle']);

    return OnlineBook(
      source: OnlineSource.openLibrary,
      title: title,
      author: author,
      description: subtitle,
      coverUrl: coverUrl,
      isbn: isbn,
    );
  }

  @override
  Future<OnlineBook?> openLibraryEditionDetails(String editionKey) async {
    final path = editionKey.startsWith('/books/') ? editionKey : '/books/$editionKey';

    final raw = await _olBooks.editionDetails('$path.json');
    final m = _asMap(raw);

    final title = _str(m['title']) ?? 'Без названия';

    String? description;
    final rawDesc = m['description'];
    if (rawDesc is String) description = rawDesc;
    if (rawDesc is Map && rawDesc['value'] != null) description = rawDesc['value'].toString();

    final author = '—';

    return OnlineBook(
      source: OnlineSource.openLibrary,
      title: title,
      author: author,
      description: description,
      olEditionKey: editionKey,
    );
  }

  @override
  Future<List<OnlineBook>> searchGutendex(String query) async {
    final raw = await _gut.search(query);
    final json = _asMap(raw);

    final results = (json['results'] as List?) ?? const [];

    return results.take(20).map((e) {
      final m = _asMap(e);

      final id = (m['id'] as num?)?.toInt();
      final title = _str(m['title']) ?? 'Без названия';

      final authors = _asList(m['authors'])
          .map((a) => _str(_asMap(a)['name']))
          .whereType<String>()
          .where((s) => s.trim().isNotEmpty)
          .toList();
      final author = authors.isNotEmpty ? authors.first : '—';

      final formats = _asMap(m['formats']);
      final coverUrl = _str(formats['image/jpeg']);

      return OnlineBook(
        source: OnlineSource.gutendex,
        title: title,
        author: author,
        coverUrl: coverUrl,
        gutendexId: id,
      );
    }).toList();
  }

  @override
  Future<OnlineBook?> gutendexDetails(int id) async {
    final raw = await _gut.details(id);
    final m = _asMap(raw);

    final title = _str(m['title']) ?? 'Без названия';

    final authors = _asList(m['authors'])
        .map((a) => _str(_asMap(a)['name']))
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .toList();
    final author = authors.isNotEmpty ? authors.first : '—';

    final formats = _asMap(m['formats']);
    final coverUrl = _str(formats['image/jpeg']);

    final downloadCount = (m['download_count'] as num?)?.toInt();

    final languages = _asList(m['languages'])
        .map((e) => e.toString())
        .where((s) => s.trim().isNotEmpty)
        .toList();

    final subjects = _asList(m['subjects'])
        .map((e) => e.toString())
        .where((s) => s.trim().isNotEmpty)
        .take(6)
        .toList();

    final summaries = _asList(m['summaries'])
        .map((e) => e.toString())
        .where((s) => s.trim().isNotEmpty)
        .take(2)
        .toList();

    final description = _buildGutendexDescription(
      downloadCount: downloadCount,
      languages: languages,
      subjects: subjects,
      summaries: summaries,
    );

    return OnlineBook(
      source: OnlineSource.gutendex,
      title: title,
      author: author,
      coverUrl: coverUrl,
      description: description,
      gutendexId: id,
    );
  }
  static Map<String, dynamic> _asMap(dynamic v) {
    if (v is Map<String, dynamic>) return v;
    if (v is Map) return v.map((k, val) => MapEntry(k.toString(), val));
    return <String, dynamic>{};
  }

  static List _asList(dynamic v) => v is List ? v : const [];

  static String? _str(dynamic v) => v == null ? null : v.toString();

  static String? _buildGutendexDescription({
    required int? downloadCount,
    required List<String> languages,
    required List<String> subjects,
    required List<String> summaries,
  }) {
    final lines = <String>[];

    if (summaries.isNotEmpty) {
      lines.addAll(summaries);
    }
    if (downloadCount != null) {
      lines.add('Скачиваний: $downloadCount');
    }
    if (languages.isNotEmpty) {
      lines.add('Языки: ${languages.join(', ')}');
    }
    if (subjects.isNotEmpty) {
      lines.add('Темы: ${subjects.join('; ')}');
    }

    final text = lines.join('\n\n').trim();
    return text.isEmpty ? null : text;
  }
}
