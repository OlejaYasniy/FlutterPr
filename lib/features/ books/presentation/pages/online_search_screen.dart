import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/online_book.dart';
import '../cubit/online_search_cubit.dart';

class OnlineSearchScreen extends StatefulWidget {
  const OnlineSearchScreen({super.key});

  @override
  State<OnlineSearchScreen> createState() => _OnlineSearchScreenState();
}

class _OnlineSearchScreenState extends State<OnlineSearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showDetails(BuildContext context, OnlineBook book) async {
    final cubit = context.read<OnlineSearchCubit>();

    OnlineBook? details;

    if (book.source == OnlineSource.openLibrary) {
      if (book.isbn != null) {
        details = await cubit.loadOpenLibraryByIsbn(book.isbn!);
      } else if (book.olEditionKey != null) {
        details = await cubit.loadOpenLibraryEdition(book.olEditionKey!);
      }
    } else {
      if (book.gutendexId != null) {
        details = await cubit.loadGutendexDetails(book.gutendexId!);
      }
    }

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(details?.title ?? book.title),
        content: Text(details?.description ?? 'Детали загружены (см. источник).'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Онлайн-поиск')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Запрос',
                      hintText: 'например: Harry Potter',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (v) => context.read<OnlineSearchCubit>().search(v),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => context.read<OnlineSearchCubit>().search(_controller.text),
                  child: const Text('Найти'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<OnlineSearchCubit, OnlineSearchState>(
                builder: (context, state) {
                  if (state is OnlineSearchIdle) {
                    return const Center(child: Text('Введите запрос и нажмите "Найти"'));
                  }
                  if (state is OnlineSearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is OnlineSearchError) {
                    return Center(child: Text('Ошибка: ${state.message}'));
                  }
                  final data = state as OnlineSearchLoaded;

                  return ListView(
                    children: [
                      const Text('Open Library', style: TextStyle(fontWeight: FontWeight.bold)),
                      ...data.openLibrary.map((b) => ListTile(
                        title: Text(b.title),
                        subtitle: Text(b.author),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () => _showDetails(context, b),
                      )),
                      const Divider(),
                      const Text('Gutendex', style: TextStyle(fontWeight: FontWeight.bold)),
                      ...data.gutendex.map((b) => ListTile(
                        title: Text(b.title),
                        subtitle: Text(b.author),
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () => _showDetails(context, b),
                      )),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
