import 'package:cinema/di/get_it.dart';
import 'package:cinema/presentation/blocs/movie_backdrop/movie_backdrop_bloc.dart';
import 'package:cinema/presentation/blocs/movie_carousel/movie_carousel_bloc.dart';
import 'package:cinema/presentation/blocs/movie_tabbed/movie_tabbed_bloc.dart';
import 'package:cinema/presentation/blocs/search_movie/search_movie_bloc.dart';
import 'package:cinema/presentation/widgets/app_error_widget.dart';
import 'package:cinema/presentation/journeys/home/movie_carousel/movie_carousel_widget.dart';
import 'package:cinema/presentation/journeys/home/movie_tabbed/movie_tabbed_widget.dart';
import 'package:cinema/presentation/journeys/drawer/navigation_drawer.dart';
import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MovieCarouselBloc movieCarouselBloc;
  late MovieBackdropBloc movieBackdropBloc;
  late MovieTabbedBloc movieTabbedBloc;
  late SearchMovieBloc searchMovieBloc;

  @override
  void initState() {
    super.initState();
    movieCarouselBloc = getItInstance<MovieCarouselBloc>();
    movieBackdropBloc = movieCarouselBloc.movieBackdropBloc;
    movieTabbedBloc   = getItInstance<MovieTabbedBloc>();
    searchMovieBloc = getItInstance<SearchMovieBloc>();
    movieCarouselBloc.add(CarouselLoadEvent()); 
  }

  @override
  void dispose() {
    movieCarouselBloc?.close();
    movieBackdropBloc?.close();
    movieTabbedBloc?.close();
    searchMovieBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => movieCarouselBloc,),
        BlocProvider(create: (context) => movieBackdropBloc,),
        BlocProvider(create: (context) => movieTabbedBloc,),
        BlocProvider(create: (context) => searchMovieBloc,),
      ],
      child: Scaffold(
        drawer: const NavigationDrawer(),
        body: BlocBuilder<MovieCarouselBloc, MovieCarouselState>(
          bloc: movieCarouselBloc,
          builder: (context, state) {
            if (state is MovieCarouselLoaded) {
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  FractionallySizedBox(
                    alignment: Alignment.topCenter,
                    heightFactor: 0.6,
                    child: MovieCarouselWidget(
                      movies: state.movies,
                      defaultIndex: state.defaultIndex,
                    ),
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 0.4,
                    child: MovieTabbedWidget(),
                  ),
                ],
              );
            } else if (state is MovieCarouselError) {
              return AppErrorWidget(
                onPressed: () => movieCarouselBloc.add(
                  CarouselLoadEvent(),
                ),
                errorType: state.errorType,
              );
            } 
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
