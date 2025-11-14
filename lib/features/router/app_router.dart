import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
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
void setupDI() {
  final getIt = GetIt.I;
  if (!getIt.isRegistered<BooksStore>()) {
    getIt.registerSingleton<BooksStore>(BooksStore.I);
  }
}

class BooksStoreProvider extends InheritedWidget {
  final BooksStore store;

  const BooksStoreProvider({
    Key? key,
    required this.store,
    required Widget child,
  }) : super(key: key, child: child);

  static BooksStore of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BooksStoreProvider>()!
        .store;
  }

  @override
  bool updateShouldNotify(BooksStoreProvider oldWidget) =>
      store != oldWidget.store;
}

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        // использование InheritedWidget
        final store = BooksStoreProvider.of(context);
        return BookListScreen(
          books: store.books,
          onAddBook: () => context.push('/books/new'),
          onToggleBook: (id) {
            store.toggle(id);
            (context as Element).markNeedsBuild();
          },
          onDeleteBook: (id) {
            store.delete(context, id);
            (context as Element).markNeedsBuild();
          },
        );
      },
    ),
    GoRoute(
      path: '/books/new',
      builder: (context, state) {
        final store = BooksStoreProvider.of(context);
        return BookFormScreen(
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
            store.add(newBook);
            context.replace(
              '/books/added?title=${Uri.encodeComponent(title)}',
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/books/added',
      builder: (context, state) {
        final title = state.uri.queryParameters['title'] ?? '';
        return BookAddedScreen(
          title: title,
          onGoToList: () => context.go('/'),
        );
      },
    ),
    GoRoute(
      path: '/demo/horizontal',
      builder: (context, state) => const DemoHorizontalScreen(),
    ),
  ],
);
