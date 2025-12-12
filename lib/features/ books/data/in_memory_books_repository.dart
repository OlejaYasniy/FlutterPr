import '../domain/book.dart';
import '../domain/books_repository.dart';

class InMemoryBooksRepository implements BooksRepository {
  final List<Book> _books = [];

  @override
  List<Book> getAll() => List.unmodifiable(_books);

  @override
  Book? getById(String id) {
    final i = _books.indexWhere((b) => b.id == id);
    return i == -1 ? null : _books[i];
  }

  @override
  void add(Book book) => _books.add(book);

  @override
  void update(Book book) {
    final i = _books.indexWhere((b) => b.id == book.id);
    if (i != -1) _books[i] = book;
  }

  @override
  void delete(String id) => _books.removeWhere((b) => b.id == id);

  @override
  void insertAt(int index, Book book) {
    final safe = index.clamp(0, _books.length);
    _books.insert(safe, book);
  }

  @override
  void toggleRead(String id) {
    final i = _books.indexWhere((b) => b.id == id);
    if (i != -1) _books[i] = _books[i].copyWith(isRead: !_books[i].isRead);
  }
}
