import 'package:equatable/equatable.dart';

abstract class ShowtimesEvent extends Equatable {
  const ShowtimesEvent();

  @override
  List<Object> get props => [];
}

class LoadShowtimesEvent extends ShowtimesEvent {
  final int movieId;
  const LoadShowtimesEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}