import 'package:cinema/di/get_it.dart';
import 'package:cinema/presentation/blocs/movie_carousel/movie_carousel_bloc.dart';
import 'package:cinema/presentation/journeys/home/movie_carousel/movie_carousel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MovieCarouselBloc movieCarouselBloc;

  @override
  void initState() {
    super.initState();
    movieCarouselBloc = getItInstance<MovieCarouselBloc>(); // Ensure DI is working correctly
    movieCarouselBloc.add(CarouselLoadEvent()); // Dispatch the event to load the carousel
  }

  @override
  void dispose() {
    movieCarouselBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieCarouselBloc>(
      create: (context) => movieCarouselBloc,
      child: Scaffold(
        body: BlocBuilder<MovieCarouselBloc, MovieCarouselState>(
          bloc: movieCarouselBloc,
          builder: (context, state) {
            if (state is MovieCarouselLoaded) {
              print('Loaded');
              // Trạng thái dữ liệu đã được tải
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
                    child: Placeholder(color: Colors.white),
                  ),
                ],
              );
            } return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}