import 'package:flutter/material.dart';

class BooksSettingsScreen extends StatelessWidget {
  const BooksSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('О приложении'),
            subtitle: Text('Домашняя библиотека (демо)'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Политика данных'),
            subtitle: Text('Данные хранятся в памяти приложения'),
          ),
        ],
      ),
    );
  }
}
