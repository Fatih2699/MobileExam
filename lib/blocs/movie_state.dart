part of 'movie_bloc.dart';

@immutable
abstract class MovieState {}

class MovieInitial extends MovieState {}

class SuccessFetchMovies extends MovieState {
  SuccessFetchMovies({this.recent, this.popular});

  final MovieResponse recent, popular;
}

class RefreshFavoriteMovie extends MovieState {}

class FailFetchMovies extends MovieState {}

class SuccessFetchMovie extends MovieState {
  SuccessFetchMovie({this.movie, this.trailersModel});

  final Movie movie;
  final TrailersModel trailersModel;
}

class FailFetchMovie extends MovieState {}

class SuccessFavoriteMovie extends MovieState {
  SuccessFavoriteMovie(this.text);

  final String text;
}

class SuccessFetchFavoriteMovies extends MovieState {
  SuccessFetchFavoriteMovies(this.movies);

  final List<Movie> movies;
}

class SuccessLoadMovies extends MovieState {
  SuccessLoadMovies(this.movieResponse);

  final MovieResponse movieResponse;
}

class FailLoadMovies extends MovieState {}
