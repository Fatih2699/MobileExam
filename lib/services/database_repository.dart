import 'dart:convert';
import 'dart:io';

import 'package:movielib_final/models/genre_model.dart';
import 'package:movielib_final/models/movie.dart';
import 'package:movielib_final/models/movie_response_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseRepository {
  static DatabaseRepository _databaseRepository;
  static Database _database;

  String _favoriteTable = 'favorites';
  String _movieTable = 'movie';
  String _moviesListTable = 'movies_list';
  String _genresTable = 'genres_list';

  DatabaseRepository._internal();

  factory DatabaseRepository() {
    if (_databaseRepository == null) {
      _databaseRepository = DatabaseRepository._internal();
    }
    return _databaseRepository;
  }

  Future<Database> _getDb() async {
    if (_database == null) {
      _database = await _initializeDatabase();
    }
    return _database;
  }

  Future<Database> _initializeDatabase() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    final path = join(appDirectory.path, 'movie_app.db');
    return openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('CREATE TABLE $_favoriteTable(id INTEGER PRIMARY KEY)');
    await db.execute(
        'CREATE TABLE $_movieTable(id INTEGER PRIMARY KEY, movie TEXT)');
    await db.execute(
        'CREATE TABLE $_moviesListTable(id INTEGER PRIMARY KEY, movies TEXT)');
    await db.execute(
        'CREATE TABLE $_genresTable(id INTEGER PRIMARY KEY, genres TEXT)');
  }

  Future<bool> favoriteMovie(int id) async {
    final db = await _getDb();
    if (await isFavorite(id)) {
      await removeFavoritesMovie(id);
      return false;
    } else {
      await db.insert(_favoriteTable, {'id': id}, nullColumnHack: 'id');
      return true;
    }
  }

  Future<bool> isFavorite(int movieID) async {
    final db = await _getDb();
    var res = await db
        .rawQuery('SELECT id FROM $_favoriteTable WHERE id=?', [movieID]);
    return res.length > 0;
  }

  Future<List<Movie>> getFavoritesMovie() async {
    final db = await _getDb();
    List<Movie> movies = [];
    final res = await db.rawQuery('SELECT * FROM $_favoriteTable');
    List<int> ids = res.map<int>((e) => e['id']).toList();
    await Future.forEach(ids, (e) async => movies.add(await getMovie(e)));
    return movies;
  }

  Future<bool> removeFavoritesMovie(int movieID) async {
    final db = await _getDb();
    final res =
        await db.delete(_favoriteTable, where: 'id=?', whereArgs: [movieID]);
    return res > 0;
  }

  Future<void> removeAllFavorites() async {
    final db = await _getDb();
    await db.delete(_favoriteTable);
  }

  Future<void> addMovie(Movie movie) async {
    if (await isMovieStored(movie.id)) {
      await removeMovie(movie.id);
    } else {
      final db = await _getDb();
      await db.insert(_movieTable, movieToMapSqf(movie));
    }
  }

  Future<Movie> getMovie(int id) async {
    final db = await _getDb();
    final res =
        await db.rawQuery('SELECT * FROM $_movieTable WHERE id=?', [id]);
    return Movie.fromMap(jsonDecode(res.first['movie']));
  }

  Future<bool> isMovieStored(int movieID) async {
    final db = await _getDb();
    var res =
        await db.rawQuery('SELECT id FROM $_movieTable WHERE id=?', [movieID]);
    return res.length > 0;
  }

  Future<void> removeMovie(int id) async {
    final db = await _getDb();
    await db.rawQuery('DELETE FROM $_movieTable WHERE id=?', [id]);
  }

  Future<void> removeMovies() async {
    // Remove movies except Favorite movies
    final db = await _getDb();
    final favMoviesID = await db.rawQuery('SELECT * FROM $_favoriteTable');
    final list = favMoviesID.map((e) => e['id']).toList();
    final fields = list.map((e) => '?').toString();
    await db.rawQuery('DELETE FROM $_movieTable WHERE id NOT IN $fields', list);
  }

  Future<bool> hasStoredMovies() async {
    final db = await _getDb();
    return (await db.rawQuery('SELECT id FROM $_moviesListTable WHERE id=1'))
            .length >
        0;
  }

  Future<void> addMoviesList(MovieResponse movieResponse) async {
    final db = await _getDb();
    if (!await hasStoredMovies()) {
      await db.insert(
          _moviesListTable, MovieResponse.movieResponseToMapSqf(movieResponse));
    } else {
      await db.rawUpdate('UPDATE $_moviesListTable SET movies=?',
          [MovieResponse.movieResponseToMap(movieResponse)]);
    }
  }

  Future<MovieResponse> getMoviesList() async {
    final db = await _getDb();
    final list =
        await db.rawQuery('SELECT * FROM $_moviesListTable WHERE id=1');
    final mr = MovieResponse.movieResponseFromMap(list.first['movies']);
    return mr;
  }

  Future<bool> hasStoredGenres() async {
    final db = await _getDb();
    return (await db.rawQuery('SELECT id FROM $_genresTable WHERE id=0'))
            .length >
        0;
  }

  Future<void> addGenres(GenresModel genresModel) async {
    final db = await _getDb();
    if (!await hasStoredGenres()) {
      await db.insert(_genresTable,
          {"id": 0, "genres": GenresModel.movieToMap(genresModel)});
    } else {
      await db.rawUpdate('UPDATE $_genresTable SET genres=?',
          [GenresModel.movieToMap(genresModel)]);
    }
  }

  Future<GenresModel> getGenres() async {
    final db = await _getDb();
    final list = await db.rawQuery('SELECT * FROM $_genresTable WHERE id=0');
    return GenresModel.genresModelFromMap(list.first['genres']);
  }
}
