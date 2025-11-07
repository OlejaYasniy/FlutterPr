import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../book.dart';
import '../widgets/book_cover.dart';

class BookListScreen extends StatelessWidget {
  final List<Book> books;
  final VoidCallback onAddBook;
  final ValueChanged<String> onToggleBook;
  final ValueChanged<String> onDeleteBook;

  const BookListScreen({
    Key? key,
    required this.books,
    required this.onAddBook,
    required this.onToggleBook,
    required this.onDeleteBook,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Домашняя библиотека'),
        actions: [
          IconButton(
            tooltip: 'Горизонтальная демо',
            icon: const Icon(Icons.view_carousel),
            onPressed: () => context.push('/demo/horizontal'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${books.length} книг',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      body: books.isEmpty ? _buildEmptyState() : _buildBookList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onAddBook,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Добавить книгу'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_outlined, size: 100, color: Colors.grey.shade400),
          const SizedBox(height: 24),
          Text('Библиотека пуста',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          Text(
            'Нажмите кнопку ниже,\nчтобы добавить первую книгу',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildBookList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Dismissible(
          key: ValueKey(book.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => onDeleteBook(book.id),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.delete_sweep, color: Colors.white, size: 36),
          ),
          child: Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: BookCover(coverUrl: book.coverUrl, width: 56, height: 80),
              title: Text(
                book.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: book.isRead ? TextDecoration.lineThrough : null,
                  color: book.isRead ? Colors.grey.shade600 : Colors.black87,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('✍️ ${book.author}', style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                  if (book.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      book.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => onToggleBook(book.id),
                    icon: Icon(book.isRead ? Icons.restart_alt : Icons.done),
                    color: Colors.teal,
                    tooltip: book.isRead ? 'Отметить как непрочитанную' : 'Отметить как прочитанную',
                  ),
                  IconButton(
                    onPressed: () => onDeleteBook(book.id),
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red,
                    tooltip: 'Удалить',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
