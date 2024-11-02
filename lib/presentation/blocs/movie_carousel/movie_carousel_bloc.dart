import 'package:bloc/bloc.dart';
import 'package:cinema/domain/entities/movie_entity.dart';
import 'package:cinema/domain/entities/no_params.dart';
import 'package:cinema/domain/usecases/get_trending.dart';
import 'package:cinema/presentation/blocs/movie_backdrop/movie_backdrop_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'dart:async';

part 'movie_carousel_event.dart';
part 'movie_carousel_state.dart';

class MovieCarouselBloc extends Bloc<MovieCarouselEvent, MovieCarouselState> {
  final GetTrending getTrending;
  final MovieBackdropBloc movieBackdropBloc;

  MovieCarouselBloc({
    @required required this.getTrending,
    @required required this.movieBackdropBloc,
  }) : super(MovieCarouselInitial()); 
  

  @override
  Stream<MovieCarouselState> mapEventToState(
    MovieCarouselEvent event,
  ) async* {
    if (event is CarouselLoadEvent) {
      final moviesEither = await getTrending(NoParams());
      yield moviesEither.fold(
        (l) {
          return MovieCarouselError();
        },
        (movies) {
          movieBackdropBloc
              .add(MovieBackdropChangedEvent(movies[event.defaultIndex]));
          return MovieCarouselLoaded(
            movies: movies,
            defaultIndex: event.defaultIndex,
          );
        },
      );
    }
  }
}
