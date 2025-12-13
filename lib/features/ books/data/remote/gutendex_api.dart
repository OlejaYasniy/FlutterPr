import 'package:dio/dio.dart';

class GutendexApi {
  GutendexApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> search(String query) async {
    final r = await _dio.get(
      'https://gutendex.com/books',
      queryParameters: {'search': query},
    );
    return (r.data as Map).cast<String, dynamic>();
  }

  Future<Map<String, dynamic>> details(int id) async {
    final r = await _dio.get('https://gutendex.com/books/$id');
    return (r.data as Map).cast<String, dynamic>();
  }

}
