import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:movielib_final/models/genre_model.dart';
import 'package:movielib_final/models/movie.dart';
import 'package:movielib_final/models/movie_response_model.dart';
import 'package:movielib_final/models/trailer_model.dart';

class MovieApiProvider {
  Client client = Client();
  final apiKey = "?api_key=7fa1acc57078f55722ada3185ba7c265";
  //?api_key=7fa1acc57078f55722ada3185ba7c265&language=tr
  final baseUrl = "https://api.themoviedb.org/3/";

  Future<MovieResponse> fetchMovieList(
      {bool isPopular = false, int page = 1}) async {
    final type = isPopular ? 'movie/popular' : 'movie/now_playing';
    final response =
        await client.get(Uri.parse(baseUrl + type + apiKey + '&page=$page'));
    //baseUrl + type + apiKey + '&page=$page'
    if (response.statusCode == 200) {
      return MovieResponse.fromMap(jsonDecode(response.body), !isPopular);
    } else {
      throw Exception('Filed to load posts');
    }
  }

  Future<Movie> fetchMovie(int id) async {
    final response = await client.get(Uri.parse('${baseUrl}movie/$id$apiKey'));
    if (response.statusCode == 200) {
      return movieFromMap(response.body);
    } else {
      throw Exception('Filed to load posts');
    }
  }

  Future<GenresModel> fetchGenreList() async {
    final response =
        await client.get(Uri.parse(baseUrl + 'genre/movie/list' + apiKey));
    if (response.statusCode == 200) {
      return GenresModel.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Filed to load genres');
    }
  }

  Future<TrailersModel> fetchMovieTrailers(int id) async {
    final response =
        await client.get(Uri.parse('${baseUrl}movie/$id/videos$apiKey'));
    if (response.statusCode == 200) {
      return trailersModelFromMap(response.body);
    } else {
      throw Exception('Filed to load trailers');
    }
  }

  Future<MovieResponse> searchMovie(String query) async {
    final path =
        '${baseUrl}search/multi$apiKey&query=$query&include_adult=true';
    final res = await client.get(Uri.parse(path));
    if (res.statusCode == 200) {
      return MovieResponse.fromMap(jsonDecode(res.body), false);
    } else {
      throw Exception('Filed to load search');
    }
  }
}
