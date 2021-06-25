part of 'genre_bloc.dart';

@immutable
abstract class GenreState {}

class GenreInitial extends GenreState {}

class SuccessFetchGenres extends GenreState {
  SuccessFetchGenres(this.genresModel);
  final GenresModel genresModel;
}

class FailFetchGenres extends GenreState {}
