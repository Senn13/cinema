import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cinema/common/constants/size_constants.dart';
import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:cinema/data/models/showtime_model.dart';
import 'package:cinema/presentation/blocs/showtimes/showtimes_bloc.dart';
import 'package:cinema/presentation/journeys/booking/seat_selection_screen.dart';

class ShowtimesScreen extends StatelessWidget {
  final int movieId;
  final List<ShowtimeModel> showtimes;
  final Function(ShowtimeModel) onShowtimeSelect;

  const ShowtimesScreen({
    Key? key,
    required this.movieId,
    required this.showtimes,
    required this.onShowtimeSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Group showtimes by date
    final Map<DateTime, List<ShowtimeModel>> showtimesByDate = {};
    for (var showtime in showtimes) {
      if (!showtimesByDate.containsKey(showtime.showDate)) {
        showtimesByDate[showtime.showDate] = [];
      }
      showtimesByDate[showtime.showDate]!.add(showtime);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Showtime',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(Sizes.dimen_16.w.toDouble()),
        itemCount: showtimesByDate.length,
        itemBuilder: (context, index) {
          final date = showtimesByDate.keys.elementAt(index);
          final dateShowtimes = showtimesByDate[date]!;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _formatDate(date),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              ...dateShowtimes.map((showtime) => Card(
                margin: EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  title: Text(
                    '${showtime.screenType} - \$${showtime.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Wrap(
                    spacing: 8.0,
                    children: showtime.times.map((time) => 
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () => onShowtimeSelect(showtime),
                        child: Text(
                          time,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ).toList(),
                  ),
                ),
              )),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && 
        date.month == now.month && 
        date.day == now.day) {
      return 'Today';
    } else if (date.year == now.year && 
               date.month == now.month && 
               date.day == now.day + 1) {
      return 'Tomorrow';
    }
    return DateFormat('EEE, MMM d').format(date);
  }
}