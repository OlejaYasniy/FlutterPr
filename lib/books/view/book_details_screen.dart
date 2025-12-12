import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/books_cubit.dart';
import '../domain/book.dart';
import 'widgets/book_cover.dart';

class BookDetailsScreen extends StatelessWidget {
  final String id;
  const BookDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksCubit, List<Book>>(
      builder: (context, _) {
        final cubit = context.read<BooksCubit>();
        final book = cubit.getById(id);

        if (book == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Книга не найдена')),
            body: const Center(child: Text('Запись отсутствует')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Детали книги'),
            actions: [
              IconButton(
                tooltip: 'Редактировать',
                onPressed: () => context.push('/books/${book.id}/edit'),
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                tooltip: 'Удалить',
                onPressed: () => context.read<BooksCubit>().delete(context, book.id),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookCover(coverUrl: book.coverUrl, width: 90, height: 130),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(book.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Автор: ${book.author}'),
                        const SizedBox(height: 8),
                        Text('Статус: ${book.isRead ? "Прочитана" : "Не прочитана"}'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Описание', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(book.description.isEmpty ? '—' : book.description),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.read<BooksCubit>().toggle(book.id),
                icon: Icon(book.isRead ? Icons.restart_alt : Icons.done),
                label: Text(book.isRead ? 'Сделать непрочитанной' : 'Отметить прочитанной'),
              ),
            ],
          ),
        );
      },
    );
  }
}
