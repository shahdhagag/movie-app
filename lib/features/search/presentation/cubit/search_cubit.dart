import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/search_movies_usecase.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchMoviesUseCase searchMoviesUseCase;

  SearchCubit({required this.searchMoviesUseCase})
      : super(SearchInitial());

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final movies = await searchMoviesUseCase(query: query);

      emit(SearchSuccess(movies));
    } catch (e) {
      emit(SearchError(e.toString()));

    }
  }
}