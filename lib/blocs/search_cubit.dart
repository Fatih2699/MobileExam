import 'package:bloc/bloc.dart';
import 'package:movielib_final/models/movie_response_model.dart';
import 'package:movielib_final/services/movie_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._repository) : super(SearchState());

  MovieRepository _repository;

  void searchMovie(String query) async {
    if (query == null || query.isEmpty || query.length < 4) {
      emit(SearchState(movieResponse: null));
    } else {
      final res = await _repository.searchMovies(query);
      if (res.totalResults == 0)
        emit(SearchState(movieResponse: null, notFound: true));
      else
        emit(SearchState(movieResponse: res));
    }
  }

  void clearResults() {
    emit(SearchState(movieResponse: null));
  }
}
