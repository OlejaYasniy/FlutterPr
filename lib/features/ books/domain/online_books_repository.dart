import 'online_book.dart';

abstract class OnlineBooksRepository {
  Future<List<OnlineBook>> searchOpenLibrary(String query);
  Future<OnlineBook?> openLibraryByIsbn(String isbn);
  Future<OnlineBook?> openLibraryEditionDetails(String editionKey);
  
  Future<List<OnlineBook>> searchGutendex(String query);
  Future<OnlineBook?> gutendexDetails(int id);
}
