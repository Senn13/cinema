import 'package:cinema/domain/entities/movie_entity.dart';
import 'package:cinema/presentation/journeys/home/movie_carousel/movie_page_view.dart';
import 'package:cinema/presentation/widgets/movie_app_bar.dart';
import 'package:flutter/material.dart';

class MovieCarouselWidget extends StatelessWidget {
  final List<MovieEntity> movies;
  final int defaultIndex;

  const MovieCarouselWidget({
    Key? key,
    @required required this.movies,
    @required required this.defaultIndex,
  }) : assert(defaultIndex >= 0, 'default index cannot be less than 0'),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MovieAppBar(),
        MoviePageView(
          movies: movies,
          initialPage: defaultIndex,
        ),
      ],
    );
  }
}