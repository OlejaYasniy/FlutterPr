import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/app_theme_mode.dart';
import '../cubit/theme_cubit.dart';

class BooksSettingsScreen extends StatelessWidget {
  const BooksSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: BlocBuilder<ThemeCubit, AppThemeMode>(
        builder: (context, mode) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('О приложении'),
                subtitle: Text('Домашняя библиотека (демо)'),
              ),
              const Divider(),

              const ListTile(
                leading: Icon(Icons.security),
                title: Text('Политика данных'),
                subtitle: Text('Книги хранятся в памяти приложения'),
              ),
              const Divider(),

              const Text('Тема оформления', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),

              RadioListTile<AppThemeMode>(
                value: AppThemeMode.system,
                groupValue: mode,
                title: const Text('Системная'),
                onChanged: (v) => _setTheme(context, v),
              ),
              RadioListTile<AppThemeMode>(
                value: AppThemeMode.light,
                groupValue: mode,
                title: const Text('Светлая'),
                onChanged: (v) => _setTheme(context, v),
              ),
              RadioListTile<AppThemeMode>(
                value: AppThemeMode.dark,
                groupValue: mode,
                title: const Text('Тёмная'),
                onChanged: (v) => _setTheme(context, v),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _setTheme(BuildContext context, AppThemeMode? mode) async {
    if (mode == null) return;

    final ok = await context.read<ThemeCubit>().setMode(mode);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось сохранить настройку (SharedPrefs).')),
      );
    }
  }
}
