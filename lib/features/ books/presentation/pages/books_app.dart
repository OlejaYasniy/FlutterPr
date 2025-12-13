import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../data/in_memory_books_repository.dart';
import '../../data/settings_repository_impl.dart';
import '../../data/shared_prefs_data_source.dart';
import '../../domain/books_repository.dart';
import '../../domain/app_theme_mode.dart';
import '../../domain/online_books_repository.dart';
import '../../domain/settings_repository.dart';
import '../cubit/books_cubit.dart';
import '../cubit/online_search_cubit.dart';
import '../cubit/theme_cubit.dart';
import '../../data/auth_tokens_repository_impl.dart';
import '../../data/secure_storage_data_source.dart';
import '../../domain/auth_tokens_repository.dart';
import '../cubit/auth_cubit.dart';
import 'book_list_screen.dart';
import 'book_form_screen.dart';
import 'book_added_screen.dart';
import 'book_details_screen.dart';
import 'book_edit_screen.dart';
import 'books_stats_screen.dart';
import 'books_settings_screen.dart';
import 'package:dio/dio.dart';
import '../../data/remote/open_library_api.dart';
import '../../data/remote/gutendex_api.dart';
import '../../data/online_books_repository_impl.dart';
import 'online_search_screen.dart';


class BooksApp extends StatelessWidget {
  const BooksApp({super.key});

  ThemeMode _toFlutterThemeMode(AppThemeMode mode) => switch (mode) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const BookListScreen()),
        GoRoute(path: '/books/new', builder: (context, state) => const BookFormScreen()),
        GoRoute(
          path: '/books/added',
          builder: (context, state) {
            final title = state.uri.queryParameters['title'] ?? '';
            return BookAddedScreen(title: title, onGoToList: () => context.go('/'));
          },
        ),
        GoRoute(path: '/books/stats', builder: (context, state) => const BooksStatsScreen()),
        GoRoute(path: '/settings', builder: (context, state) => const BooksSettingsScreen()),
        GoRoute(
          path: '/books/:id/edit',
          builder: (context, state) => BookEditScreen(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/books/:id',
          builder: (context, state) => BookDetailsScreen(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/online',
          builder: (context, state) => BlocProvider(
            create: (_) => OnlineSearchCubit(context.read()),
            child: const OnlineSearchScreen(),
          ),
        ),

      ],
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<BooksRepository>(create: (_) => InMemoryBooksRepository()),
        RepositoryProvider<SettingsRepository>(
          create: (_) => SettingsRepositoryImpl(const SharedPrefsDataSource()),
        ),
        RepositoryProvider<AuthTokensRepository>(
          create: (_) => AuthTokensRepositoryImpl(SecureStorageDataSource()),
        ),
        RepositoryProvider<OnlineBooksRepository>(
          create: (_) {
            final dio = Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 15),
              ),
            );

            return OnlineBooksRepositoryImpl(
              openLibrary: OpenLibraryApi(dio),
              gutendex: GutendexApi(dio),
            );
          },
        ),

      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => BooksCubit(context.read<BooksRepository>())),
          BlocProvider(create: (context) => ThemeCubit(context.read<SettingsRepository>())..load()),
          BlocProvider(create: (context) => AuthCubit(context.read<AuthTokensRepository>())..loadToken()),
        ],
        child: BlocBuilder<ThemeCubit, AppThemeMode>(
          builder: (context, mode) {
            return MaterialApp.router(
              title: 'Домашняя библиотека',
              debugShowCheckedModeBanner: false,
              routerConfig: router,
              theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
              darkTheme: ThemeData.dark(useMaterial3: true),
              themeMode: _toFlutterThemeMode(mode),
            );
          },
        ),
      ),
    );
  }
}
