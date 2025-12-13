import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'open_library_client.g.dart';

@RestApi(baseUrl: 'https://openlibrary.org')
abstract class OpenLibraryClient {
  factory OpenLibraryClient(Dio dio, {String baseUrl}) = _OpenLibraryClient;

  @GET('/search.json')
  Future<dynamic> search(@Query('q') String query);
}
