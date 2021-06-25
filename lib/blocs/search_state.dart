part of 'search_cubit.dart';

class SearchState {
  SearchState({this.movieResponse, this.notFound = false});

  final MovieResponse movieResponse;
  final bool notFound;
}
