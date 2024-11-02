import 'package:cinema/common/constants/size_constants.dart';
import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:cinema/common/screenutil/screenutil.dart';
import 'package:cinema/domain/entities/movie_entity.dart';
import 'package:cinema/presentation/blocs/movie_backdrop/movie_backdrop_bloc.dart';
import 'package:cinema/presentation/journeys/home/movie_carousel/animated_movie_card_widget.dart';
import 'package:cinema/presentation/journeys/home/movie_carousel/movie_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoviePageView extends StatefulWidget {
  final List<MovieEntity> movies;
  final int initialPage;

  const MoviePageView({
    Key? key,
    @required required this.movies,
    @required required this.initialPage,
  })  : assert(initialPage >= 0, 'initialPage cannot be less than 0'),
        super(key: key);

  @override
  _MoviePageViewState createState() => _MoviePageViewState();
}

class _MoviePageViewState extends State<MoviePageView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.initialPage,
      keepPage: false,
      viewportFraction: 0.7,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Sizes.dimen_10.h.toDouble()),
      height: ScreenUtil.screenHeight * 0.35,
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          final MovieEntity movie = widget.movies[index];
          return AnimatedMovieCardWidget(
            index: index,
            pageController: _pageController,
            key: ValueKey(movie.id),
            movieId: movie.id, 
            posterPath: movie.posterPath, 
          );

        },
        pageSnapping: true,
        itemCount: widget.movies.length ?? 0,
        onPageChanged: (index) {
          BlocProvider.of<MovieBackdropBloc>(context)
            .add(MovieBackdropChangedEvent(widget.movies[index]));
        },
      ),
    );
  }
}