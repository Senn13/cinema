import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinema/di/get_it.dart';
import 'package:cinema/domain/entities/movie_entity.dart';
import 'package:cinema/presentation/blocs/showtimes/showtimes_bloc.dart';
import 'package:cinema/presentation/blocs/showtimes/showtimes_event.dart';
import 'package:cinema/presentation/blocs/showtimes/showtimes_state.dart';
import 'package:cinema/presentation/journeys/booking/seat_selection_screen.dart';
import 'package:cinema/presentation/journeys/booking/showtimes_screen.dart';

class BookingScreen extends StatefulWidget {
  final MovieEntity movie;

  const BookingScreen({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late ShowtimesBloc _showtimesBloc;

  @override
  void initState() {
    super.initState();
    _showtimesBloc = getItInstance<ShowtimesBloc>();
    _showtimesBloc.add(LoadShowtimesEvent(widget.movie.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _showtimesBloc,
      child: Scaffold(
        body: BlocBuilder<ShowtimesBloc, ShowtimesState>(
          builder: (context, state) {
            if (state is ShowtimesLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ShowtimesLoadedState) {
              return ShowtimesScreen(
                movieId: widget.movie.id,
                showtimes: state.showtimes,
                onShowtimeSelect: (showtime) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeatSelectionScreen(
                        showtimeId: showtime.id,
                        price: showtime.price,
                        movie: widget.movie,
                      ),
                    ),
                  );
                },
              );
            }
            if (state is ShowtimesErrorState) {
              return Center(
                child: Text(state.message),
              );
            }
            return const Center(
              child: Text('No showtimes available'),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _showtimesBloc.close();
    super.dispose();
  }
}