import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../domain/book.dart';

class BooksCubit extends Cubit<List<Book>> {
  BooksCubit() : super(const []);

  void addBook(Book book) {
    emit([...state, book]);
  }
  void toggle(String id) {
    final updated = state
        .map((b) => b.id == id ? b.copyWith(isRead: !b.isRead) : b)
        .toList();
    emit(updated);
  }
  void delete(BuildContext context, String id) {
    final idx = state.indexWhere((b) => b.id == id);
    if (idx == -1) return;

    final removed = state[idx];
    final list = [...state]..removeAt(idx);
    emit(list);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Книга "${removed.title}" удалена'),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.red.shade700,
        action: SnackBarAction(
          label: 'Отменить',
          textColor: Colors.white,
          onPressed: () => undoDelete(context, removed, idx),
        ),
      ),
    );
  }
  void undoDelete(BuildContext context, Book removed, int index) {
    final list = [...state]..insert(index, removed);
    emit(list);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Книга восстановлена'),
        backgroundColor: Colors.teal,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
