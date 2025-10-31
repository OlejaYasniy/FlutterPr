import 'package:flutter/material.dart';
import 'book.dart';
import 'screens/book_list_screen.dart';
import 'screens/book_form_screen.dart';

enum Screen { list, form }

class BooksContainer extends StatefulWidget {
  const BooksContainer({Key? key}) : super(key: key);

  @override
  State<BooksContainer> createState() => _BooksContainerState();
}

class _BooksContainerState extends State<BooksContainer> {
  final List<Book> _books = [];
  Screen _currentScreen = Screen.list;

  Book? _lastDeletedBook;
  int? _lastDeletedIndex;

  void _showForm() {
    setState(() {
      _currentScreen = Screen.form;
    });
  }
  void _createBook({
    required String title,
    required String author,
    String description = "",
  }) {
    final newBook = Book(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      author: author,
      description: description,
      createdAt: DateTime.now(),
      isRead: false,
    );

    setState(() {
      _books.add(newBook);
      _currentScreen = Screen.list;
    });

    _showSnackBar(
      'Книга "${title}" успешно добавлена',
      Colors.green,
    );
  }

  void _toggleBook(String id) {
    setState(() {
      final index = _books.indexWhere((book) => book.id == id);
      if (index != -1) {
        _books[index] = _books[index].copyWith(
          isRead: !_books[index].isRead,
        );
      }
    });
  }

  void _deleteBook(String id) {
    final index = _books.indexWhere((book) => book.id == id);
    if (index == -1) return;

    setState(() {
      _lastDeletedBook = _books[index];
      _lastDeletedIndex = index;
      _books.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Книга "${_lastDeletedBook!.title}" удалена'),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Отменить',
          textColor: Colors.white,
          onPressed: _undoDelete,
        ),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }
  void _undoDelete() {
    if (_lastDeletedBook != null && _lastDeletedIndex != null) {
      setState(() {
        _books.insert(_lastDeletedIndex!, _lastDeletedBook!);
        _lastDeletedBook = null;
        _lastDeletedIndex = null;
      });

      _showSnackBar('Книга восстановлена', Colors.teal);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    switch (_currentScreen) {
      case Screen.list:
        body = BookListScreen(
          books: _books,
          onAddBook: _showForm,
          onToggleBook: _toggleBook,
          onDeleteBook: _deleteBook,
        );
        break;
      case Screen.form:
        body = BookFormScreen(
          onSave: ({
            required String title,
            required String author,
            String description = "",
          }) {
            _createBook(
              title: title,
              author: author,
              description: description,
            );
          },
        );
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: body,
    );
  }
}
