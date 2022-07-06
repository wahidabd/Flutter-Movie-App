import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_apps/bloc/get_genres_bloc.dart';
import 'package:movie_apps/models/genre_response.dart';

import '../models/genre.dart';
import 'genre_list.dart';

class GenresScreen extends StatefulWidget {
  const GenresScreen({Key? key}) : super(key: key);

  @override
  State<GenresScreen> createState() => _GenresScreenState();

}

class _GenresScreenState extends State<GenresScreen> {

  @override
  void initState() {
    super.initState();
    genreBloc.getGenres();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, AsyncSnapshot<GenreResponse> snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data!.error != "") {
            return _buildErrorWidget(snapshot.data!.error);
          }
          return _buildGenreWidget(snapshot.data!);
        }else if(snapshot.hasError){
          return _buildErrorWidget(snapshot.error as String);
        }else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: SizedBox(
        height: 307,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(height: 25, width: 25, child: CircularProgressIndicator()),
            SizedBox(height: 19),
            Text(
              'Loading Genres....',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error occured: $error',
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _buildGenreWidget(GenreResponse data){
    List<Genre> genres = data.genres;
    if(genres.isEmpty){
      return Container(
        child: const Text('No Genre'),
      );
    }else{
      return GenresList(genres: genres);
    }
  }

}