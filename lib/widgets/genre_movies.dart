import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_apps/bloc/get_movie_genre_bloc.dart';
import 'package:movie_apps/screens/detail_screen.dart';
import '../styles/theme.dart' as Style;
import '../models/movie.dart';
import '../models/movie_response.dart';

class GenreMovies extends StatefulWidget {
  final int genreId;

  const GenreMovies({Key? key, required this.genreId}) : super(key: key);

  @override
  State<GenreMovies> createState() => _GenreMoviesState(genreId);

}

class _GenreMoviesState extends State<GenreMovies> {

  final int genreId;
  _GenreMoviesState(this.genreId);

  @override
  void initState() {
    super.initState();
    moviesByGenreBloc.getMoviesByGenre(genreId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: moviesByGenreBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot){
        if(snapshot.hasData){
          if(snapshot.data!.error.isNotEmpty){
            return _buildErrorWidget(snapshot.data!.error);
          }
          return _buildMoviesByGenreWidget(snapshot.data!);
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
        height: 270,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Loading Genre Movies...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
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
            'Error occurred: $error',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesByGenreWidget(MovieResponse data){
    List<Movie> movies = data.movies;
    if (movies.isEmpty) {
      return Container(
        child: const Text('No Movies'),
      );
    } else {
      return Container(
        height: 270,
        padding: const EdgeInsets.only(left: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                right: 10,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailScreen(),
                    ),
                  );
                },
                child: Column(
                  children: [
                    movies[index].poster == null
                        ? Container(
                      width: 120,
                      height: 180,
                      decoration: const BoxDecoration(
                        color: Style.Colors.secondColor,
                        borderRadius:
                        BorderRadius.all(Radius.circular(2)),
                        shape: BoxShape.rectangle,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            EvaIcons.filmOutline,
                            color: Colors.white,
                            size: 50,
                          )
                        ],
                      ),
                    )
                        : Container(
                      width: 120,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(2),
                        ),
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://image.tmdb.org/t/p/w200${movies[index].poster}"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 100,
                      child: Text(
                        movies[index].title,
                        maxLines: 2,
                        style: const TextStyle(
                          height: 1.4,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          movies[index].rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        RatingBar.builder(
                          itemSize: 8,
                          initialRating: movies[index].rating / 2,
                          minRating: 1,
                          direction: Axis.horizontal,
                          unratedColor: Colors.white,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                          const EdgeInsets.symmetric(horizontal: 2),
                          itemBuilder: (context, _) => const Icon(
                            EvaIcons.star,
                            color: Style.Colors.secondColor,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }

}