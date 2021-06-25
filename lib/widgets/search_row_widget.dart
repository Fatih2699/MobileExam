import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movielib_final/blocs/search_cubit.dart';
import 'package:movielib_final/ui/movie_detail.dart';

import 'cached_image.dart';

class SearchRow extends StatefulWidget {
  SearchRow({this.child});

  final Widget child;

  @override
  _SearchRowState createState() => _SearchRowState();
}

class _SearchRowState extends State<SearchRow> {
  TextEditingController textEditingController;

  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer timer;
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Arama',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 30,
                    fontWeight: FontWeight.w700),
              ),
              if (widget.child != null) widget.child,
            ],
          ),
          SizedBox(height: 6),
          TextField(
            controller: textEditingController,
            focusNode: focusNode,
            onChanged: (v) {
              timer?.cancel();
              timer = Timer(Duration(seconds: 2), () {
                context.read<SearchCubit>().searchMovie(v);
              });
            },
            style: TextStyle(color: Colors.white, fontSize: 28),
            decoration: InputDecoration(
                hintText: 'Film,Oyuncu,Yönetmen...',
                hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => clearResults(),
                ),
                border: UnderlineInputBorder()),
          ),
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state.notFound) {
                return Container(
                  color: Colors.grey[800],
                  child: Center(child: Text('Bir Şey Bulunamadı')),
                );
              } else if (state.movieResponse == null) {
                return Center();
              }
              return Container(
                height: MediaQuery.of(context).size.height * 0.4,
                color: Colors.grey[800],
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.movieResponse.results.length,
                  itemBuilder: (context, i) => ListTile(
                    leading: CachedImage(state.movieResponse.results[i].poster,
                        width: 60),
                    title: Text(state.movieResponse.results[i].title),
                    onTap: () {
                      MovieDetail.route(
                          context, state.movieResponse.results[i].id);
                      clearResults();
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void clearResults() {
    context.read<SearchCubit>().clearResults();
    focusNode.unfocus();
    textEditingController.clear();
  }
}
