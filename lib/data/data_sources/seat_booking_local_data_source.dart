import 'dart:convert';
import 'package:cinema/data/data_sources/ticket_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeatBookingInfo {
  final String seatNumber;
  final int showtimeId;
  final DateTime bookingTime;
  final String showtime;
  final int movieId;

  SeatBookingInfo({
    required this.seatNumber,
    required this.showtimeId,
    required this.bookingTime,
    required this.showtime,
    required this.movieId,
  });

  Map<String, dynamic> toJson() => {
    'seatNumber': seatNumber,
    'showtimeId': showtimeId,
    'bookingTime': bookingTime.toIso8601String(),
    'showtime': showtime,
    'movieId': movieId,
  };

  factory SeatBookingInfo.fromJson(Map<String, dynamic> json) {
    return SeatBookingInfo(
      seatNumber: json['seatNumber'] as String? ?? '',
      showtimeId: json['showtimeId'] as int? ?? 0,
      bookingTime: json['bookingTime'] != null 
          ? DateTime.parse(json['bookingTime'] as String)
          : DateTime.now(),
      showtime: json['showtime'] as String? ?? '',
      movieId: json['movieId'] as int? ?? 0,
    );
  }
}

class SeatBookingLocalDataSource {
  static const String KEY_BOOKED_SEATS = 'booked_seats';
  final SharedPreferences _prefs;
  final TicketLocalDataSource _ticketLocalDataSource;

  SeatBookingLocalDataSource(this._prefs, this._ticketLocalDataSource);

  String _getBookedSeatsKey(int showtimeId) {
    return '${KEY_BOOKED_SEATS}_$showtimeId';
  }

  Future<List<SeatBookingInfo>> getValidBookedSeats(int showtimeId, String showtime) async {
    try {
      List<SeatBookingInfo> allBookedSeats = [];
      final specificKey = _getBookedSeatsKey(showtimeId);
      print('Getting booked seats for showtime ID: $showtimeId');

      // Lấy ghế từ tickets
      final tickets = await _ticketLocalDataSource.getTickets();
      for (var ticket in tickets) {
        if (ticket.status == 'active' && ticket.showtimeId == showtimeId) {
          print('Found matching ticket: ${ticket.id} with seats: ${ticket.seats.join(", ")}');
          for (var seat in ticket.seats) {
            allBookedSeats.add(SeatBookingInfo(
              seatNumber: seat,
              showtimeId: ticket.showtimeId,
              bookingTime: ticket.bookingTime,
              showtime: ticket.showtime,
              movieId: ticket.movieId,
            ));
          }
        }
      }

      // Lấy ghế từ SharedPreferences
      final bookingsString = _prefs.getString(specificKey);
      if (bookingsString != null && bookingsString.isNotEmpty) {
        final List<dynamic> bookingsJson = jsonDecode(bookingsString);
        final tempBookings = bookingsJson
            .map((json) => SeatBookingInfo.fromJson(json))
            .toList();
        allBookedSeats.addAll(tempBookings);
      }

      print('Found ${allBookedSeats.length} booked seats for showtime $showtimeId: ${allBookedSeats.map((b) => b.seatNumber).join(", ")}');
      return allBookedSeats;
    } catch (e) {
      print('Error getting booked seats: $e');
      return [];
    }
  }

  Future<void> saveBookedSeats(List<String> seats, int showtimeId, String showtime, int movieId) async {
    try {
      final specificKey = _getBookedSeatsKey(showtimeId);
      print('Saving booked seats with key: $specificKey, showtime: $showtime'); // Debug log

      // Lấy danh sách ghế hiện tại
      final currentBookings = await getValidBookedSeats(showtimeId, showtime);
      
      // Thêm ghế mới
      final newBookings = seats.map((seat) => SeatBookingInfo(
        seatNumber: seat,
        showtimeId: showtimeId,
        bookingTime: DateTime.now(),
        showtime: showtime,
        movieId: movieId,
      )).toList();

      currentBookings.addAll(newBookings);
      
      // Lưu với key cụ thể
      final bookingsJson = currentBookings.map((b) => b.toJson()).toList();
      await _prefs.setString(specificKey, jsonEncode(bookingsJson));
      print('Saved ${seats.length} new seats for showtime $showtimeId at $showtime: ${seats.join(", ")}');
    } catch (e) {
      print('Error saving booked seats: $e');
      throw e;
    }
  }
}