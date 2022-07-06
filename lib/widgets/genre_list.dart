import 'package:flutter/material.dart';
import 'package:movie_apps/bloc/get_movie_genre_bloc.dart';
import '../styles/theme.dart' as Style;
import '../models/genre.dart';
import 'genre_movies.dart';

class GenresList extends StatefulWidget {
  final List<Genre> genres ;

  const GenresList({Key? key, required this.genres}) : super(key: key);
  @override
  State<GenresList> createState() => _GenresListState(genres);

}

class _GenresListState extends State<GenresList> with SingleTickerProviderStateMixin {

  final List<Genre> genres;
  late TabController _tabController;
  _GenresListState(this.genres);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: genres.length, vsync: this);
    _tabController.addListener(() {
      if(_tabController.indexIsChanging) {
        moviesByGenreBloc.drainStream();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 307,
      child: DefaultTabController(
        length: genres.length,
        child: Scaffold(
          backgroundColor: Style.Colors.mainColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Style.Colors.secondColor,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              unselectedLabelColor: Style.Colors.titleColor,
              labelColor: Colors.white,
              isScrollable: true,
              tabs: genres.map((Genre genre) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 15, top: 10),
                  child: Text(
                    genre.name.toUpperCase()
                  ),
                );
              }).toList(),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: genres.map((Genre genre) {
              return GenreMovies(genreId: genre.id);
            }).toList(),
          ),
        ),
      ),
    );
  }

}