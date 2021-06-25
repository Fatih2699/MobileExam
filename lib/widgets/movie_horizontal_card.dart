import 'package:flutter/material.dart';
import 'package:movielib_final/models/genre_model.dart';
import 'package:movielib_final/models/movie.dart';
import 'package:movielib_final/ui/movie_detail.dart';

import 'movie_card.dart';

class MovieHorizontalCard extends StatelessWidget {
  const MovieHorizontalCard({
    Key key,
    @required this.m,
    this.genresModel,
    this.onPress,
    this.onRemove,
    this.favBtn = false,
  }) : super(key: key);

  final Movie m;
  final GenresModel genresModel;
  final VoidCallback onPress, onRemove;
  final bool favBtn;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MovieCard(
          posterPath: m.poster,
          onPress: () => MovieDetail.route(context, m.id),
        ),
        Expanded(
          child: Container(
            height: 180,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  m.title,
                  style: TextStyle(fontSize: 20),
                  softWrap: false,
                ),
                Text(
                  '${m.releaseDate.year}-${m.releaseDate.month}-${m.releaseDate.day}',
                  style: TextStyle(fontSize: 16),
                ),
                if (genresModel != null)
                  Text(
                    genresModel.getGenreTitle(m.genreIds),
                    style: TextStyle(color: Colors.black),
                  ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow.shade600),
                    RichText(
                      text: TextSpan(
                          text: m.voteAverage.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                text: '/10',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal))
                          ]),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (favBtn)
                        TextButton(
                          child: Text(
                            'Kaldır',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: onRemove,
                        ),
                      SizedBox(width: 12.0),
                      OutlinedButton(
                          child: Text(
                            'Sayfayı Aç',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: onPress),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
