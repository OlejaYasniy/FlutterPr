import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'open_library_books_client.g.dart';

@RestApi(baseUrl: 'https://openlibrary.org')
abstract class OpenLibraryBooksClient {
  factory OpenLibraryBooksClient(Dio dio, {String baseUrl}) = _OpenLibraryBooksClient;

  @GET('/api/books')
  Future<dynamic> byIsbn(
      @Query('bibkeys') String bibkeys,
      @Query('format') String format,
      @Query('jscmd') String jscmd,
      );

  @GET('{editionJsonPath}')
  Future<dynamic> editionDetails(@Path('editionJsonPath') String editionJsonPath);
}
