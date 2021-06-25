import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movielib_final/blocs/movie_bloc.dart';
import 'package:movielib_final/models/genre_model.dart';
import 'package:movielib_final/models/movie.dart';
import 'package:movielib_final/models/trailer_model.dart';
import 'package:movielib_final/services/movie_repository.dart';
import 'package:movielib_final/widgets/app_text.dart';
import 'package:movielib_final/widgets/cached_image.dart';

import 'favorite_movie_screen.dart';

class MovieDetail extends StatefulWidget {
  static route(BuildContext context, int id) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => BlocProvider(
            create: (context) => MovieBloc(context.read<MovieRepository>()),
            child: MovieDetail(id)),
      ),
    );
  }

  MovieDetail(this.movieId);

  final int movieId;

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  Completer<void> _refreshCompleter;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer();
  }

  @override
  Widget build(BuildContext context) {
    context.read<MovieBloc>().add(FetchMovie(this.widget.movieId));
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: BlocConsumer<MovieBloc, MovieState>(
        listener: (context, state) {
          if (state is SuccessFavoriteMovie) {
            _scaffoldKey.currentState
              // ignore: deprecated_member_use
              ..hideCurrentSnackBar()
              // ignore: deprecated_member_use
              ..showSnackBar(
                SnackBar(
                  backgroundColor: Colors.white,
                  action: SnackBarAction(
                    textColor: Colors.black,
                    label: 'Favorilere Git',
                    onPressed: () => FavoriteMovieScreen.route(context),
                  ),
                  content: Text(state.text),
                ),
              );
          }
          if (state is RefreshFavoriteMovie) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
        },
        builder: (context, state) {
          if (state is SuccessFetchMovie) {
            return _scaffoldBody(context, state.movie, state.trailersModel);
          } else if (state is FailFetchMovie) {
            return Center(child: Text('Detayler Yüklenirken Hata Oluştu.'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _scaffoldBody(
      BuildContext context, Movie movie, TrailersModel trailersModel) {
    final size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () {
        context
            .read<MovieBloc>()
            .add(FetchMovie(this.widget.movieId, refresh: true));
        return _refreshCompleter.future;
      },
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: size.width,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      image: ExtendedNetworkImageProvider(
                        movie.poster.replaceAll('w185', 'w400'),
                        cache: true,
                      ),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: 70,
                          width: size.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withOpacity(0.0),
                                Colors.grey.withOpacity(0.90),
                                Colors.white,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: size.width - 40,
                              margin: EdgeInsets.only(bottom: 10.0),
                              child: AppText(
                                movie.title,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            GenresRow(movie.genres),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    /* TextButton.icon(
                        label: Text('Set reminder'),
                        icon: Icon(Icons.schedule),
                        onPressed: () =>
                            setReminder(movie.id, movie.title, movie.overview)),*/
                    IconButton(
                        icon: movie.favorite
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red.shade400,
                              )
                            : Icon(Icons.favorite_outline),
                        onPressed: () => context
                            .read<MovieBloc>()
                            .add(AddToFavorite(movie.id))),
                  ],
                ),
              ],
            ),
            Divider(indent: 20.0, endIndent: 20.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  movieProps(
                    AppText(
                      movie.popularity.toStringAsFixed(4),
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    AppText('Popülerlik', fontSize: 18),
                  ),
                  movieProps(
                    Icon(Icons.star, color: Colors.white, size: 24),
                    Row(
                      children: [
                        AppText(movie.voteAverage.toString(),
                            fontSize: 20, fontWeight: FontWeight.bold),
                        AppText('/10', fontSize: 18),
                      ],
                    ),
                  ),
                  movieProps(
                    AppText(
                      movie.voteCount.toString(),
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    AppText(
                      'Oy Sayısı',
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Divider(indent: 20.0, endIndent: 20.0),
            detailCard(
              title: 'Açıklama',
              child: AppText(movie.overview, fontSize: 18),
            ),
            detailCard(
              title: 'Fragmanlar',
              child: trailersModel != null
                  ? TrailersCol(trailersModel, backdropPath: movie.backdrop)
                  : Text('İnternet Bağlantınız Yok'),
            ),
          ],
        ),
      ),
    );
  }

  Column movieProps(Widget stCol, ndCol) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [stCol, ndCol],
    );
  }

  Widget detailCard({String title, Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 12),
          child
        ],
      ),
    );
  }
}

class GenresRow extends StatelessWidget {
  GenresRow(this.genres);

  final List<Genre> genres;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: Wrap(
        spacing: 10.0,
        runSpacing: 8.0,
        children: genres
            .map((e) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(e.name),
                ))
            .toList(),
      ),
    );
  }
}

class TrailersCol extends StatelessWidget {
  TrailersCol(this.trailersModel, {@required this.backdropPath});

  final String backdropPath;
  final TrailersModel trailersModel;

  @override
  Widget build(BuildContext context) {
    return trailersModel == null
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: trailersModel.results.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              childAspectRatio: 1.2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, i) => InkWell(
              onTap: () => context
                  .read<MovieBloc>()
                  .add(PlayTrailer(trailersModel.results[i].key)),
              child: Stack(
                children: [
                  Wrap(
                    runSpacing: 4,
                    children: [
                      CachedImage(backdropPath),
                      AppText(trailersModel.results[i].name),
                    ],
                  ),
                  Icon(Icons.play_arrow)
                ],
              ),
            ),
          );
  }
}
