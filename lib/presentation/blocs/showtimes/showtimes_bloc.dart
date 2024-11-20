import 'package:cinema/data/data_sources/booking_remote_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinema/data/models/showtime_model.dart';
import 'showtimes_event.dart';
import 'showtimes_state.dart';

class ShowtimesBloc extends Bloc<ShowtimesEvent, ShowtimesState> {
  final BookingRemoteDataSource remoteDataSource;

  ShowtimesBloc({required this.remoteDataSource}) : super(ShowtimesInitialState()) {
    on<LoadShowtimesEvent>(_onLoadShowtimes);
  }

  Future<void> _onLoadShowtimes(
    LoadShowtimesEvent event,
    Emitter<ShowtimesState> emit,
  ) async {
    try {
      emit(ShowtimesLoadingState());
      final showtimes = await remoteDataSource.getShowtimes(event.movieId);
      if (showtimes.isEmpty) {
        emit(ShowtimesErrorState('No showtimes available'));
      } else {
        emit(ShowtimesLoadedState(showtimes));
      }
    } catch (e) {
      print('Error loading showtimes: $e');
      emit(ShowtimesErrorState('Failed to load showtimes'));
    }
  }
}