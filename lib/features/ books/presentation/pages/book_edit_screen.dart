import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/book.dart';
import '../cubit/books_cubit.dart';

class BookEditScreen extends StatefulWidget {
  final String id;
  const BookEditScreen({super.key, required this.id});

  @override
  State<BookEditScreen> createState() => _BookEditScreenState();
}

class _BookEditScreenState extends State<BookEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _author;
  late final TextEditingController _description;
  late final TextEditingController _coverUrl;

  Book? _initial;

  @override
  void initState() {
    super.initState();
    _initial = context.read<BooksCubit>().getById(widget.id);

    _title = TextEditingController(text: _initial?.title ?? '');
    _author = TextEditingController(text: _initial?.author ?? '');
    _description = TextEditingController(text: _initial?.description ?? '');
    _coverUrl = TextEditingController(text: _initial?.coverUrl ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _description.dispose();
    _coverUrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_initial == null) return;
    if (!_formKey.currentState!.validate()) return;

    final updated = _initial!.copyWith(
      title: _title.text.trim(),
      author: _author.text.trim(),
      description: _description.text.trim(),
      coverUrl: _coverUrl.text.trim().isEmpty ? null : _coverUrl.text.trim(),
    );

    context.read<BooksCubit>().updateBook(updated);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_initial == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Редактирование')),
        body: const Center(child: Text('Книга не найдена')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Редактировать книгу')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Название *'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Введите название' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _author,
              decoration: const InputDecoration(labelText: 'Автор *'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Введите автора' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(labelText: 'Описание'),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _coverUrl,
              decoration: const InputDecoration(labelText: 'URL обложки'),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
