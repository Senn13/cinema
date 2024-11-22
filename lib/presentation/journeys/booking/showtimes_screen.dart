import 'package:cinema/presentation/theme/theme_color.dart';
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
    final Map<DateTime, List<ShowtimeModel>> showtimesByDate = {};
    for (var showtime in showtimes) {
      final date = DateTime(
        showtime.showDate.year,
        showtime.showDate.month,
        showtime.showDate.day,
      );
      if (!showtimesByDate.containsKey(date)) {
        showtimesByDate[date] = [];
      }
      showtimesByDate[date]!.add(showtime);
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
          
          dateShowtimes.sort((a, b) => a.time.compareTo(b.time));
          
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _formatDate(date),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateShowtimes.first.screenType,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: dateShowtimes.map((showtime) => 
                          SizedBox(
                            width: 80, // Chiều rộng cố định cho mỗi nút
                            height: 36, // Chiều cao cố định cho mỗi nút
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                backgroundColor: Colors.white,
                                side: const BorderSide(color: AppColor.royalBlue),
                              ),
                              onPressed: () => onShowtimeSelect(showtime),
                              child: Text(
                                showtime.time,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ).toList(),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Price: \$${dateShowtimes.first.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, dd/MM/yyyy').format(date);
  }
}