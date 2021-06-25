import 'dart:async';

import 'package:movielib_final/models/genre_model.dart';
import 'package:movielib_final/models/movie.dart';
import 'package:movielib_final/models/movie_response_model.dart';
import 'package:movielib_final/models/trailer_model.dart';

import 'database_repository.dart';
import 'movie_api_provider.dart';

class MovieRepository {
  final movieApiProvider = MovieApiProvider();
  final movieDB = DatabaseRepository();

  Future<MovieResponse> fetchAllMovies({bool isPopular, int page}) async {
    try {
      MovieResponse res;
      res = await movieApiProvider.fetchMovieList(
          isPopular: isPopular, page: page);
      if (isPopular) await movieDB.addMoviesList(res);
      return res;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<GenresModel> fetchGenreList() async {
    GenresModel genresModel;
    if (await movieDB.hasStoredGenres()) {
      genresModel = await movieDB.getGenres();
    } else {
      genresModel = await movieApiProvider.fetchGenreList();
      await movieDB.addGenres(genresModel);
    }
    return genresModel;
  }

  Future<Movie> fetchMovie(int id, {bool refresh = false}) async {
    Movie m;
    if (await movieDB.isMovieStored(id) && !refresh) {
      m = await movieDB.getMovie(id);
    } else {
      final mov = await movieApiProvider.fetchMovie(id);
      await movieDB.addMovie(mov);
      m = mov;
    }
    m.favorite = await movieDB.isFavorite(id);
    return m;
  }

  Future<TrailersModel> fetchMovieTrailers(int id) async {
    try {
      return await movieApiProvider.fetchMovieTrailers(id);
    } catch (e) {
      return null;
    }
  }

  Future<MovieResponse> searchMovies(String query) {
    return movieApiProvider.searchMovie(query);
  }
}
