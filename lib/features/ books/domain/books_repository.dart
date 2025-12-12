import 'book.dart';

abstract class BooksRepository {
  List<Book> getAll();
  Book? getById(String id);

  void add(Book book);
  void update(Book book);
  void delete(String id);
  void insertAt(int index, Book book);

  void toggleRead(String id);
}
