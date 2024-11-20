import 'package:equatable/equatable.dart';
import 'package:cinema/data/models/showtime_model.dart';

abstract class ShowtimesState extends Equatable {
  const ShowtimesState();
  
  @override
  List<Object> get props => [];
}

class ShowtimesInitialState extends ShowtimesState {}

class ShowtimesLoadingState extends ShowtimesState {}

class ShowtimesLoadedState extends ShowtimesState {
  final List<ShowtimeModel> showtimes;
  
  const ShowtimesLoadedState(this.showtimes);
  
  @override
  List<Object> get props => [showtimes];
}

class ShowtimesErrorState extends ShowtimesState {
  final String message;
  
  const ShowtimesErrorState(this.message);
  
  @override
  List<Object> get props => [message];
}