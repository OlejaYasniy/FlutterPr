import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../domain/book.dart';
import '../../domain/books_repository.dart';

class BooksCubit extends Cubit<List<Book>> {
  BooksCubit(this._repo) : super(_repo.getAll());

  final BooksRepository _repo;

  void addBook(Book book) {
    _repo.add(book);
    emit(_repo.getAll());
  }

  void toggle(String id) {
    _repo.toggleRead(id);
    emit(_repo.getAll());
  }

  void updateBook(Book updated) {
    _repo.update(updated);
    emit(_repo.getAll());
  }

  Book? getById(String id) => _repo.getById(id);

  void delete(BuildContext context, String id) {
    final list = _repo.getAll();
    final idx = list.indexWhere((b) => b.id == id);
    if (idx == -1) return;

    final removed = list[idx];
    _repo.delete(id);
    emit(_repo.getAll());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Книга "${removed.title}" удалена'),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Отменить',
          textColor: Colors.white,
          onPressed: () => undoDelete(context, removed, idx),
        ),
      ),
    );
  }

  void undoDelete(BuildContext context, Book removed, int index) {
    _repo.insertAt(index, removed);
    emit(_repo.getAll());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Книга восстановлена'),
        backgroundColor: Colors.teal,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
