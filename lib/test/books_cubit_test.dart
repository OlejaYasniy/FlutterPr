import 'package:flutter_test/flutter_test.dart';
import '../features/ books/domain/book.dart';
import '../features/ books/presentation/cubit/books_cubit.dart';

void main() {
  group('BooksCubit', () {
    test('addBook emits list with new book', () async {
      final cubit = BooksCubit();

      final book = Book(
        id: '1',
        title: 'Test',
        author: 'Author',
        createdAt: DateTime(2025, 1, 1),
      );
      final future = expectLater(
        cubit.stream,
        emitsInOrder(<dynamic>[
          [book],
        ]),
      );

      cubit.addBook(book);

      await future;
      await cubit.close();
    });

    test('toggle flips isRead for matching id', () async {
      final cubit = BooksCubit();

      final book = Book(
        id: '1',
        title: 'Test',
        author: 'Author',
        createdAt: DateTime(2025, 1, 1),
        isRead: false,
      );

      cubit.addBook(book);

      final future = expectLater(
        cubit.stream,
        emitsInOrder(<dynamic>[
          predicate<List<Book>>((list) {
            return list.length == 1 && list.first.id == '1' && list.first.isRead == true;
          }),
        ]),
      );

      cubit.toggle('1');

      await future;
      await cubit.close();
    });
  });
}
