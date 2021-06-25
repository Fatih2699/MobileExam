import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movielib_final/models/movie.dart';
import 'package:movielib_final/models/movie_response_model.dart';
import 'package:movielib_final/models/trailer_model.dart';
import 'package:movielib_final/services/database_repository.dart';
import 'package:movielib_final/services/movie_repository.dart';
import 'package:url_launcher/url_launcher.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc(this._repository) : super(MovieInitial());
  final MovieRepository _repository;
  final movieDB = DatabaseRepository();

  @override
  Stream<MovieState> mapEventToState(
    MovieEvent event,
  ) async* {
    if (event is FetchAllMovies) {
      try {
        if (await movieDB.hasStoredMovies()) {
          var cached = await movieDB.getMoviesList();
          yield SuccessFetchMovies(recent: cached, popular: cached);
        }
        final recRes = await _repository.fetchAllMovies(isPopular: false);
        if (recRes != null) yield SuccessFetchMovies(recent: recRes);
        final popRes = await _repository.fetchAllMovies(isPopular: true);
        if (popRes != null)
          yield SuccessFetchMovies(recent: recRes, popular: popRes);
      } catch (e) {
        print(e);
        yield FailFetchMovies();
      }
    } else if (event is FetchMovie) {
      try {
        final response =
            await _repository.fetchMovie(event.id, refresh: event.refresh);
        if (event.refresh) {
          yield RefreshFavoriteMovie();
        }
        yield SuccessFetchMovie(movie: response);
        final trailerRes = await _repository.fetchMovieTrailers(event.id);
        if (trailerRes != null)
          yield SuccessFetchMovie(movie: response, trailersModel: trailerRes);
      } catch (e) {
        print(e);
        yield FailFetchMovie();
      }
    } else if (event is PlayTrailer) {
      try {
        await _launchURL('https://www.youtube.com/watch?v=' + event.videoKey);
      } catch (e) {
        print(e);
      }
    } else if (event is AddToFavorite) {
      final s = (state as SuccessFetchMovie);
      try {
        s.movie.favorite = await movieDB.favoriteMovie(event.movieID);
        yield SuccessFavoriteMovie(s.movie.favorite
            ? 'Film Favorilere Eklendi'
            : 'Film Favorilerden Kaldırıldı');
        yield s;
      } catch (e) {
        yield SuccessFavoriteMovie('Eklenirken Hata Oluştu.');
        yield s;
      }
    } else if (event is FetchFavorites) {
      try {
        final res = await movieDB.getFavoritesMovie();
        yield SuccessFetchFavoriteMovies(res);
      } catch (e) {
        print(e);
      }
    } else if (event is RemoveFavorites) {
      try {
        final s = (state as SuccessFetchFavoriteMovies);
        await movieDB.removeFavoritesMovie(event.movieID);
        yield SuccessFetchFavoriteMovies(
            s.movies.where((e) => e.id != event.movieID).toList());
      } catch (e) {
        print(e);
      }
    } else if (event is ClearFavorites) {
      try {
        await movieDB.removeAllFavorites();
        yield SuccessFetchFavoriteMovies([]);
      } catch (e) {
        print(e);
      }
    } else if (event is FetchMovies) {
      try {
        if (await movieDB.hasStoredMovies()) {
          var cached = await movieDB.getMoviesList();
          yield SuccessLoadMovies(cached);
        }
        final res = await _repository.fetchAllMovies(isPopular: event.popular);
        yield SuccessLoadMovies(res);
      } catch (e) {
        print(e);
        yield FailLoadMovies();
      }
    } else if (event is LoadMoreMovies) {
      try {
        final s = state as SuccessLoadMovies;
        final res = await _repository.fetchAllMovies(
            isPopular: event.popular, page: s.movieResponse.page + 1);
        if (s.movieResponse.totalPages != res.page) {
          s.movieResponse.page = res.page;
          s.movieResponse.results.addAll(res.results);
          yield SuccessLoadMovies(s.movieResponse);
        }
      } catch (e) {
        print(e);
        yield FailLoadMovies();
      }
    }
  }
}

_launchURL(String url) async {
  try {
    await launch(url);
  } catch (e) {
    print("HATAAA" + e.toString());
  }
}
