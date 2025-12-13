import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'gutendex_client.g.dart';

@RestApi(baseUrl: 'https://gutendex.com')
abstract class GutendexClient {
  factory GutendexClient(Dio dio, {String baseUrl}) = _GutendexClient;

  @GET('/books')
  Future<dynamic> search(@Query('search') String query);

  @GET('/books/{id}')
  Future<dynamic> details(@Path('id') int id);
}
