import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/books_cubit.dart';
import '../domain/book.dart';

class BooksStatsScreen extends StatelessWidget {
  const BooksStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Статистика')),
      body: BlocBuilder<BooksCubit, List<Book>>(
        builder: (context, books) {
          final total = books.length;
          final read = books.where((b) => b.isRead).length;
          final unread = total - read;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Всего: $total', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('Прочитано: $read', style: const TextStyle(fontSize: 16)),
                Text('Не прочитано: $unread', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 12),
                if (total > 0)
                  Text('Прогресс: ${((read / total) * 100).round()}%', style: const TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );
  }
}
