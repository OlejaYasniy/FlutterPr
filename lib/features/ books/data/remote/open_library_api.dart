import 'package:dio/dio.dart';

class OpenLibraryApi {
  OpenLibraryApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> search(String query) async {
    final r = await _dio.get(
      'https://openlibrary.org/search.json',
      queryParameters: {'q': query},
    );
    return (r.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> byIsbn(String isbn) async {
    final r = await _dio.get(
      'https://openlibrary.org/api/books',
      queryParameters: {
        'bibkeys': 'ISBN:$isbn',
        'format': 'json',
        'jscmd': 'data',
      },
    );
    return (r.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> editionDetails(String editionKey) async {
    final key = editionKey.startsWith('/books/') ? editionKey : '/books/$editionKey';
    final r = await _dio.get('https://openlibrary.org$key.json');
    return (r.data as Map).cast<String, dynamic>();
  }
}
