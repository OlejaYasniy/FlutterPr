import 'package:flutter/material.dart';

class BookAddedScreen extends StatelessWidget {
  final String title;
  final VoidCallback onGoToList;

  const BookAddedScreen({
    Key? key,
    required this.title,
    required this.onGoToList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Книга добавлена')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.teal, size: 72),
              const SizedBox(height: 16),
              Text('«$title» добавлена в библиотеку', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onGoToList, // Рисунок 20 — возврат на корень
                icon: const Icon(Icons.library_books),
                label: const Text('Вернуться к списку'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
