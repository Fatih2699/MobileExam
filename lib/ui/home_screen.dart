import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movielib_final/blocs/genre_bloc.dart';
import 'package:movielib_final/blocs/movie_bloc.dart';
import 'package:movielib_final/blocs/search_cubit.dart';
import 'package:movielib_final/models/genre_model.dart';
import 'package:movielib_final/services/movie_repository.dart';
import 'package:movielib_final/widgets/home_card.dart';
import 'package:movielib_final/widgets/movie_card.dart';
import 'package:movielib_final/widgets/movie_horizontal_card.dart';
import 'package:movielib_final/widgets/search_row_widget.dart';

import 'favorite_movie_screen.dart';
import 'login_screen.dart';
import 'movie_detail.dart';
import 'movie_list.dart';

class HomeScreen extends StatelessWidget {
  static route(BuildContext context) {
    final repo = context.read<MovieRepository>();
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<MovieBloc>(create: (context) => MovieBloc(repo)),
            BlocProvider<GenreBloc>(create: (context) => GenreBloc(repo)),
            BlocProvider<SearchCubit>(create: (context) => SearchCubit(repo)),
          ],
          child: HomeScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<MovieBloc>().add(FetchAllMovies());
    context.read<GenreBloc>().add(FetchAllGenres());
    return Scaffold(
        backgroundColor: Colors.transparent, body: _HomeScreenBody());
  }
}

class _HomeScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenreBloc, GenreState>(
      builder: (context, state) => state is SuccessFetchGenres
          ? SafeArea(
              child: ListView(
                primary: false,
                children: [
                  SearchRow(
                    child: PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 0,
                          child: TextButton.icon(
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.white,
                            ),
                            label: Text('Favoriler'),
                            onPressed: () => FavoriteMovieScreen.route(context),
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: TextButton.icon(
                            icon: Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            label: Text('ÇIKIŞ YAP'),
                            onPressed: () {
                              print("Deneme");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                              cikisYap();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  _RecentMoviesRow(),
                  _PopularMoviesRow(state.genresModel),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  void cikisYap() async {
    if (auth.currentUser != null) {
      await auth.signOut();
      Fluttertoast.showToast(
          msg: "ÇIKIŞ YAPILDI.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    } else {
      debugPrint("Oturum açmış kullanıcı yok.");
    }
  }
}

class _RecentMoviesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeCardWidget(
      title: 'SON EKLENEN',
      onPress: () => MoviesList.route(context, popular: false),
      child: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is SuccessFetchMovies) {
            return state.recent != null
                ? Container(
                    height: 230,
                    child: ListView.builder(
                      primary: false,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.recent.results.length,
                      itemBuilder: (context, i) {
                        final m = state.recent.results[i];
                        return MovieCard(
                          title: m.title,
                          posterPath: m.poster,
                          onPress: () => MovieDetail.route(context, m.id),
                        );
                      },
                    ),
                  )
                : Center(child: CircularProgressIndicator());
          } else if (state is FailFetchMovies) {
            return Center(child: Text('Film yüklenirken hata oluştu.'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _PopularMoviesRow extends StatelessWidget {
  _PopularMoviesRow(this.genresModel);

  final GenresModel genresModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeCardTitle(
          title: 'POPULAR',
          onPress: () => MoviesList.route(context, popular: true),
        ),
        BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is SuccessFetchMovies) {
              return state.popular != null
                  ? ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: state.popular.results.length,
                      separatorBuilder: (context, i) => Divider(),
                      itemBuilder: (context, i) {
                        final m = state.popular.results[i];
                        return MovieHorizontalCard(
                          m: m,
                          genresModel: genresModel,
                          onPress: () => MovieDetail.route(context, m.id),
                        );
                      },
                    )
                  : Center(child: CircularProgressIndicator());
            } else if (state is FailFetchMovies) {
              return Center(child: Text('Film yüklenirken hata oluştu.'));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
