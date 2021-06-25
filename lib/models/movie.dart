import 'dart:convert';

import 'package:movielib_final/models/spoken_language.dart';

import 'company.dart';
import 'country.dart';
import 'genre_model.dart';

Movie movieFromMap(String str) => Movie.fromMap(json.decode(str));

Map<String, dynamic> movieToMapSqf(Movie data) => {
      'id': data.id,
      'movie': json.encode(data.toMap()),
    };

class Movie {
  Movie({
    this.adult,
    this.backdropPath,
    this.budget,
    this.genres,
    this.homepage,
    this.id,
    this.imdbId,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.productionCompanies,
    this.productionCountries,
    this.releaseDate,
    this.revenue,
    this.runtime,
    this.spokenLanguages,
    this.status,
    this.tagline,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
    this.favorite,
    this.genreIds,
  });

  bool adult;
  String backdropPath;
  int budget;
  List<Genre> genres;
  String homepage;
  int id;
  String imdbId;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  List<ProductionCompany> productionCompanies;
  List<ProductionCountry> productionCountries;
  DateTime releaseDate;
  int revenue;
  int runtime;
  List<SpokenLanguage> spokenLanguages;
  String status;
  String tagline;
  String title;
  bool video;
  double voteAverage;
  int voteCount;
  bool favorite;
  List<int> genreIds;

  String get poster => posterPath != null
      ? 'https://image.tmdb.org/t/p/w185' + posterPath
      : 'https://upload.wikimedia.org/wikipedia/commons/f/fc/No_picture_available.png';

  String get backdrop => 'https://image.tmdb.org/t/p/w185' + backdropPath;

  String get date =>
      '${releaseDate.month}-${releaseDate.day}-${releaseDate.year}';

  static DateTime _getReleaseTime(String date) {
    try {
      return DateTime.parse(date);
    } catch (_) {
      return DateTime.now();
    }
  }

  static List<int> _getGenres(dynamic intList) {
    try {
      return List<int>.from(intList.map((x) => x));
    } catch (_) {
      return [];
    }
  }

  static String _getBackdrop(String path) {
    if (path == null) {
      return 'https://upload.wikimedia.org/wikipedia/commons/f/fc/No_picture_available.png';
    } else {
      return path;
    }
  }

  Movie.fromMapForList(Map<String, dynamic> json) {
    adult = json["adult"] ?? false;
    backdropPath = _getBackdrop(json['backdrop_path']);
    genreIds = _getGenres(json["genre_ids"]);
    id = json["id"];
    originalLanguage = json["original_language"];
    originalTitle = json["original_title"] ?? '';
    overview = json["overview"] ?? '';
    popularity = json["popularity"] != null ? json["popularity"].toDouble() : 0;
    posterPath = json["poster_path"];
    releaseDate = _getReleaseTime(json["release_date"]);
    title = json["title"] ?? 'Başlık Yok';
    video = json["video"];
    voteAverage =
        json["vote_average"] != null ? json["vote_average"].toDouble() : 0;
    voteCount = json["vote_count"] ?? 0;
  }

  factory Movie.fromMap(Map<String, dynamic> json) => Movie(
        adult: json["adult"],
        backdropPath: _getBackdrop(json['backdrop_path']),
        budget: json["budget"],
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromMap(x))),
        homepage: json["homepage"],
        id: json["id"],
        imdbId: json["imdb_id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        productionCompanies: List<ProductionCompany>.from(
            json["production_companies"]
                .map((x) => ProductionCompany.fromMap(x))),
        productionCountries: List<ProductionCountry>.from(
            json["production_countries"]
                .map((x) => ProductionCountry.fromMap(x))),
        releaseDate: _getReleaseTime(json['release_date']),
        revenue: json["revenue"],
        runtime: json["runtime"],
        spokenLanguages: List<SpokenLanguage>.from(
            json["spoken_languages"].map((x) => SpokenLanguage.fromMap(x))),
        status: json["status"],
        tagline: json["tagline"],
        title: json["title"] ?? 'Başlık Yok',
        video: json["video"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toMap() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "budget": budget,
        "genres": List<dynamic>.from(genres.map((x) => x.toMap())),
        "homepage": homepage,
        "id": id,
        "imdb_id": imdbId,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "production_companies":
            List<dynamic>.from(productionCompanies.map((x) => x.toMap())),
        "production_countries":
            List<dynamic>.from(productionCountries.map((x) => x.toMap())),
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "revenue": revenue,
        "runtime": runtime,
        "spoken_languages":
            List<dynamic>.from(spokenLanguages.map((x) => x.toMap())),
        "status": status,
        "tagline": tagline,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  factory Movie.fromSqfMap(Map<String, dynamic> json) => Movie(
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromMap(x))),
        adult: json["adult"],
        backdropPath: _getBackdrop(json['backdrop_path']),
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"],
        posterPath: json["poster_path"],
        releaseDate: DateTime.parse(json["release_date"]),
        title: json["title"] != null ? json["title"] : 'Başlık Yok',
        video: json["video"],
        voteAverage: json["vote_average"],
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toMapSqf() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genres": genres != null
            ? List<dynamic>.from(genres.map((x) => x.toMap()))
            : [],
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}
