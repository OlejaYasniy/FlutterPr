import '../domain/online_book.dart';
import '../domain/online_books_repository.dart';
import 'remote/open_library_api.dart';
import 'remote/gutendex_api.dart';

class OnlineBooksRepositoryImpl implements OnlineBooksRepository {
  OnlineBooksRepositoryImpl({
    required OpenLibraryApi openLibrary,
    required GutendexApi gutendex,
  })  : _ol = openLibrary,
        _gut = gutendex;

  final OpenLibraryApi _ol;
  final GutendexApi _gut;

  @override
  Future<List<OnlineBook>> searchOpenLibrary(String query) async {
    final json = await _ol.search(query);
    final docs = (json['docs'] as List? ?? const []);

    return docs.take(20).map((e) {
      final m = (e as Map).cast<String, dynamic>();
      final title = (m['title'] as String?)?.trim().isNotEmpty == true ? m['title'] as String : 'Без названия';
      final authors = (m['author_name'] as List?)?.cast<dynamic>().map((x) => x.toString()).toList() ?? const [];
      final author = authors.isNotEmpty ? authors.first : '—';

      // edition_key обычно массив, возьмём первый
      final editionKeys = (m['edition_key'] as List?)?.cast<dynamic>().map((x) => x.toString()).toList() ?? const [];
      final editionKey = editionKeys.isNotEmpty ? 'OL${editionKeys.first}' : null;

      // isbn обычно массив, возьмём первый
      final isbns = (m['isbn'] as List?)?.cast<dynamic>().map((x) => x.toString()).toList() ?? const [];
      final isbn = isbns.isNotEmpty ? isbns.first : null;

      // cover_i -> URL обложки
      final coverI = m['cover_i'];
      final coverUrl = coverI != null ? 'https://covers.openlibrary.org/b/id/$coverI-L.jpg' : null;

      return OnlineBook(
        source: OnlineSource.openLibrary,
        title: title,
        author: author,
        coverUrl: coverUrl,
        olEditionKey: editionKeys.isNotEmpty ? '/books/${editionKeys.first}' : null,
        isbn: isbn,
      );
    }).toList();
  }

  @override
  Future<OnlineBook?> openLibraryByIsbn(String isbn) async {
    final json = await _ol.byIsbn(isbn);
    final key = 'ISBN:$isbn';
    final data = json[key];
    if (data is! Map) return null;

    final m = data.cast<String, dynamic>();
    final title = (m['title'] as String?) ?? 'Без названия';

    final authors = (m['authors'] as List?) ?? const [];
    final author = authors.isNotEmpty
        ? ((authors.first as Map?)?['name']?.toString() ?? '—')
        : '—';

    final cover = (m['cover'] as Map?)?.cast<String, dynamic>();
    final coverUrl = (cover?['large'] ?? cover?['medium'] ?? cover?['small'])?.toString();

    final desc = m['subtitle']?.toString(); // кратко, чтобы без сложных типов

    return OnlineBook(
      source: OnlineSource.openLibrary,
      title: title,
      author: author,
      description: desc,
      coverUrl: coverUrl,
      isbn: isbn,
    );
  }

  @override
  Future<OnlineBook?> openLibraryEditionDetails(String editionKey) async {
    final m = await _ol.editionDetails(editionKey);

    final title = (m['title'] as String?) ?? 'Без названия';

    // authors может быть массивом объектов со ссылками — для простоты показываем "—"
    final author = '—';

    String? description;
    final rawDesc = m['description'];
    if (rawDesc is String) description = rawDesc;
    if (rawDesc is Map && rawDesc['value'] != null) description = rawDesc['value'].toString();

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
    final json = await _gut.search(query);
    final results = (json['results'] as List? ?? const []);

    return results.take(20).map((e) {
      final m = (e as Map).cast<String, dynamic>();
      final id = (m['id'] as num?)?.toInt();

      final title = (m['title'] as String?) ?? 'Без названия';
      final authors = (m['authors'] as List? ?? const [])
          .cast<dynamic>()
          .map((a) => (a as Map?)?['name']?.toString() ?? '')
          .where((s) => s.trim().isNotEmpty)
          .toList();
      final author = authors.isNotEmpty ? authors.first : '—';

      final formats = (m['formats'] as Map?)?.cast<String, dynamic>();
      final coverUrl = formats?['image/jpeg']?.toString();

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
    final m = await _gut.details(id);

    final title = (m['title'] as String?) ?? 'Без названия';
    final authors = (m['authors'] as List? ?? const [])
        .cast<dynamic>()
        .map((a) => (a as Map?)?['name']?.toString() ?? '')
        .where((s) => s.trim().isNotEmpty)
        .toList();
    final author = authors.isNotEmpty ? authors.first : '—';

    final formats = (m['formats'] as Map?)?.cast<String, dynamic>();
    final coverUrl = formats?['image/jpeg']?.toString();

    return OnlineBook(
      source: OnlineSource.gutendex,
      title: title,
      author: author,
      coverUrl: coverUrl,
      gutendexId: id,
    );
  }
}
