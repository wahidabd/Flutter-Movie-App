import 'package:flutter/material.dart';

class TopMovies extends StatefulWidget {
  const TopMovies({Key? key}) : super(key: key);

  @override
  State<TopMovies> createState() => _TopMoviesState();
}

class _TopMoviesState extends State<TopMovies> {
  @override
  Widget build(BuildContext context) {
    return Text("TOP");
  }

}