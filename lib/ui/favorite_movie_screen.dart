import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movielib_final/blocs/movie_bloc.dart';
import 'package:movielib_final/services/movie_repository.dart';
import 'package:movielib_final/widgets/movie_horizontal_card.dart';

import 'movie_detail.dart';

class FavoriteMovieScreen extends StatelessWidget {
  static route(BuildContext context) => Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => BlocProvider(
            create: (context) => MovieBloc(context.read<MovieRepository>()),
            child: FavoriteMovieScreen()),
      )).then((_) => Navigator.pop(context));

  @override
  Widget build(BuildContext context) {
    context.read<MovieBloc>().add(FetchFavorites());
    return BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Favori Filmlerin'),
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => removeAllFavorites(context)),
          ],
        ),
        body: _successLoadedFavorites(context, state),
      );
    });
  }

  Widget _successLoadedFavorites(BuildContext context, MovieState state) {
    if (state is SuccessFetchFavoriteMovies) {
      return state.movies != null && state.movies.length > 0
          ? ListView.separated(
              itemCount: state.movies.length,
              padding: EdgeInsets.only(top: 20.0),
              separatorBuilder: (c, _) => Divider(),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, i) {
                final m = state.movies[i];
                return Dismissible(
                  key: Key(m.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (d) =>
                      context.read<MovieBloc>().add(RemoveFavorites(m.id)),
                  background: Container(
                    alignment: Alignment(0.7, 0),
                    color: Colors.pink,
                    child: Icon(Icons.delete, size: 26),
                  ),
                  child: MovieHorizontalCard(
                    m: m,
                    favBtn: true,
                    onPress: () => MovieDetail.route(context, m.id),
                    onRemove: () =>
                        context.read<MovieBloc>().add(RemoveFavorites(m.id)),
                  ),
                );
              })
          : Center(
              child: Text('Lütfen bir kaç film ekle'),
            );
    }
    return Center(child: CircularProgressIndicator());
  }

  void removeAllFavorites(BuildContext context) {
    context.read<MovieBloc>().add(ClearFavorites());
  }
}
