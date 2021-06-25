import 'dart:convert';

import 'movie.dart';

class MovieResponse {
  static MovieResponse movieResponseFromMap(String str,
          {bool isRecent = false}) =>
      MovieResponse.fromMap(json.decode(str), isRecent);

  static String movieResponseToMap(MovieResponse data) =>
      json.encode(data.toMap());

  static Map<String, dynamic> movieResponseToMapSqf(
          MovieResponse movieResponse) =>
      {
        "id": 1,
        "movies": movieResponseToMap(movieResponse),
      };

  MovieResponse({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  MovieResponse.fromMap(Map<String, dynamic> json, bool isRecent) {
    page = json["page"];
    results = json["results"] != null
        ? List<Movie>.from(json["results"].map((x) => Movie.fromMapForList(x)))
        : [];
    totalPages = json["total_pages"];
    totalResults = json["total_results"];

    if (isRecent) {
      results.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
    } else {
      results.sort((a, b) => b.popularity.compareTo(a.popularity));
    }
  }

  Map<String, dynamic> toMap() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toMapSqf())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}
