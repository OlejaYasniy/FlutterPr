import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/books_cubit.dart';
import 'book_list_screen.dart';
import 'book_form_screen.dart';
import 'book_added_screen.dart';
import 'book_details_screen.dart';
import 'book_edit_screen.dart';
import 'books_stats_screen.dart';
import 'books_settings_screen.dart';

class BooksApp extends StatelessWidget {
  const BooksApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const BookListScreen(),
        ),

        GoRoute(
          path: '/books/new',
          builder: (context, state) => const BookFormScreen(),
        ),
        GoRoute(
          path: '/books/added',
          builder: (context, state) {
            final title = state.uri.queryParameters['title'] ?? '';
            return BookAddedScreen(
              title: title,
              onGoToList: () => context.go('/'),
            );
          },
        ),
        GoRoute(
          path: '/books/stats',
          builder: (context, state) => const BooksStatsScreen(),
        ),

        // НЕ /books, тоже статический
        GoRoute(
          path: '/settings',
          builder: (context, state) => const BooksSettingsScreen(),
        ),

        // ДИНАМИЧЕСКИЕ — в конце
        GoRoute(
          path: '/books/:id/edit',
          builder: (context, state) =>
              BookEditScreen(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/books/:id',
          builder: (context, state) =>
              BookDetailsScreen(id: state.pathParameters['id']!),
        ),
      ],
    );

    return BlocProvider(
      create: (_) => BooksCubit(),
      child: MaterialApp.router(
        title: 'Домашняя библиотека',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 2,
          ),
        ),
      ),
    );
  }
}
