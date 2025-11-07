import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../book.dart';
import '../screens/book_list_screen.dart';
import '../screens/book_form_screen.dart';
import '../screens/book_added_screen.dart';
import '../screens/horizontal_screen.dart';

class BooksStore {
  BooksStore._();
  static final BooksStore I = BooksStore._();

  final List<Book> books = [];
  Book? _lastDeleted;
  int? _lastIndex;

  void add(Book b) => books.add(b);

  void toggle(String id) {
    final i = books.indexWhere((b) => b.id == id);
    if (i == -1) return;
    books[i] = books[i].copyWith(isRead: !books[i].isRead);
  }

  void delete(BuildContext context, String id) {
    final i = books.indexWhere((b) => b.id == id);
    if (i == -1) return;
    _lastDeleted = books[i];
    _lastIndex = i;
    books.removeAt(i);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Книга "${_lastDeleted!.title}" удалена'),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.red.shade700,
        action: SnackBarAction(
          label: 'Отменить',
          textColor: Colors.white,
          onPressed: () => undo(context),
        ),
      ),
    );
  }

  void undo(BuildContext context) {
    if (_lastDeleted != null && _lastIndex != null) {
      books.insert(_lastIndex!, _lastDeleted!);
      _lastDeleted = null;
      _lastIndex = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Книга восстановлена'),
          backgroundColor: Colors.teal,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BookListScreen(
        books: BooksStore.I.books,
        onAddBook: () => context.push('/books/new'),
        onToggleBook: (id) {
          BooksStore.I.toggle(id);
          (context as Element).markNeedsBuild();
        },
        onDeleteBook: (id) {
          BooksStore.I.delete(context, id);
          (context as Element).markNeedsBuild();
        },
      ),
    ),
    GoRoute(
      path: '/books/new',
      builder: (context, state) => BookFormScreen(
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
          BooksStore.I.add(newBook);
          // Рисунок 6 — горизонтальная замена текущего маршрута
          context.replace('/books/added?title=${Uri.encodeComponent(title)}');
        },
      ),
    ),
    GoRoute(
      path: '/books/added',
      builder: (context, state) {
        final title = state.uri.queryParameters['title'] ?? '';
        return BookAddedScreen(
          title: title,
          onGoToList: () => context.go('/'), // сброс ветки к корню
        );
      },
    ),
    GoRoute(
      path: '/demo/horizontal',
      builder: (context, state) => const DemoHorizontalScreen(),
    ),
  ],
);
