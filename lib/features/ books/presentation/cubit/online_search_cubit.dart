import 'package:bloc/bloc.dart';
import '../../domain/online_book.dart';
import '../../domain/online_books_repository.dart';

sealed class OnlineSearchState {
  const OnlineSearchState();
}

class OnlineSearchIdle extends OnlineSearchState {
  const OnlineSearchIdle();
}

class OnlineSearchLoading extends OnlineSearchState {
  const OnlineSearchLoading();
}

class OnlineSearchLoaded extends OnlineSearchState {
  final List<OnlineBook> openLibrary;
  final List<OnlineBook> gutendex;
  const OnlineSearchLoaded({required this.openLibrary, required this.gutendex});
}

class OnlineSearchError extends OnlineSearchState {
  final String message;
  const OnlineSearchError(this.message);
}

class OnlineSearchCubit extends Cubit<OnlineSearchState> {
  OnlineSearchCubit(this._repo) : super(const OnlineSearchIdle());

  final OnlineBooksRepository _repo;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;
    emit(const OnlineSearchLoading());
    try {
      // 2 запроса сразу: OpenLibrary + Gutendex
      final ol = await _repo.searchOpenLibrary(query);
      final gut = await _repo.searchGutendex(query);
      emit(OnlineSearchLoaded(openLibrary: ol, gutendex: gut));
    } catch (e) {
      emit(OnlineSearchError(e.toString()));
    }
  }

  // OpenLibrary ISBN (3-й запрос)
  Future<OnlineBook?> loadOpenLibraryByIsbn(String isbn) => _repo.openLibraryByIsbn(isbn);

  // OpenLibrary edition details (4-й запрос)
  Future<OnlineBook?> loadOpenLibraryEdition(String editionKey) => _repo.openLibraryEditionDetails(editionKey);

  // Gutendex details (5-й запрос)
  Future<OnlineBook?> loadGutendexDetails(int id) => _repo.gutendexDetails(id);
}
