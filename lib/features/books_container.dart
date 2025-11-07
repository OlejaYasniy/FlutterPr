import 'package:flutter/material.dart';
import 'package:untitled1/features/screens/book_added_screen.dart';
import 'package:untitled1/features/screens/book_form_screen.dart';
import 'package:untitled1/features/screens/book_list_screen.dart';
import 'book.dart';

class BooksContainer extends StatefulWidget {
  const BooksContainer({Key? key}) : super(key: key);

  @override
  State<BooksContainer> createState() => _BooksContainerState();
}

class _BooksContainerState extends State<BooksContainer> {
  final List<Book> _books = [];
  Book? _lastDeletedBook;
  int? _lastDeletedIndex;

  // ADDED: открытие формы как нового маршрута (вертикальная навигация push)
  void _openAddForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (formCtx) => BookFormScreen(
          onSave: ({
            required String title,
            required String author,
            String description = "",
            String? coverUrl,
          }) {
            final newBook = Book(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: title,
              author: author,
              description: description,
              createdAt: DateTime.now(),
              isRead: false,
              coverUrl: coverUrl,
            );

            setState(() {
              _books.add(newBook);
            });
            Navigator.pushReplacement(
              formCtx,
              MaterialPageRoute(
                builder: (_) => BookAddedScreen(
                  title: title,
                  onGoToList: () => Navigator.pop(formCtx),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _toggleBook(String id) {
    final index = _books.indexWhere((b) => b.id == id);
    if (index == -1) return;
    setState(() {
      _books[index] = _books[index].copyWith(isRead: !_books[index].isRead);
    });
  }

  void _deleteBook(String id) {
    final index = _books.indexWhere((b) => b.id == id);
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Книга восстановлена'),
          backgroundColor: Colors.teal,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BookListScreen(
      books: _books,
      onAddBook: _openAddForm,
      onToggleBook: _toggleBook,
      onDeleteBook: _deleteBook,
    );
  }
}
