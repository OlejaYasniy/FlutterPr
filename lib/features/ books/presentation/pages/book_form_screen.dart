import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/book.dart';
import '../cubit/books_cubit.dart';

class BookFormScreen extends StatefulWidget {
  const BookFormScreen({super.key});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _coverUrlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _coverUrlController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final cubit = context.read<BooksCubit>();

      final book = Book(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        description: _descriptionController.text.trim(),
        createdAt: DateTime.now(),
        isRead: false,
        coverUrl: _coverUrlController.text.trim().isEmpty
            ? null
            : _coverUrlController.text.trim(),
      );

      cubit.addBook(book);

      context.replace(
        '/books/added?title=${Uri.encodeComponent(book.title)}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить книгу'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.book,
                  size: 50,
                  color: Colors.teal.shade700,
                ),
              ),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Название книги *',
                hintText: 'Например: Война и мир',
                prefixIcon: Icon(Icons.book, color: Colors.teal),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Пожалуйста, введите название книги'
                  : null,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(
                labelText: 'Автор *',
                hintText: 'Например: Лев Толстой',
                prefixIcon: Icon(Icons.person, color: Colors.teal),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Пожалуйста, введите автора книги'
                  : null,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Описание (необязательно)',
                hintText: 'Краткое описание или заметка',
                prefixIcon: Icon(Icons.description, color: Colors.teal),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _coverUrlController,
              decoration: const InputDecoration(
                labelText: 'URL обложки (необязательно)',
                hintText: 'https://example.com/cover.jpg',
                prefixIcon: Icon(Icons.image, color: Colors.teal),
                helperText: 'Введите ссылку на изображение обложки',
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text(
                'Сохранить книгу',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.close),
              label: const Text('Отменить'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
