import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/books_cubit.dart';
import 'book_list_screen.dart';
import 'book_form_screen.dart';
import 'book_added_screen.dart';
import 'horizontal_screen.dart';
import '../domain/book.dart';

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
          path: '/demo/horizontal',
          builder: (context, state) => const DemoHorizontalScreen(),
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
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
