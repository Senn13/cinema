import 'dart:convert';

import 'package:cinema/data/core/api_client.dart';
import 'package:cinema/data/models/showtime_model.dart';
import 'package:cinema/data/models/booking_model.dart';
import 'package:cinema/data/models/ticket_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BookingRemoteDataSource {
  Future<List<ShowtimeModel>> getShowtimes(int movieId);
  Future<BookingModel> createBooking(BookingModel booking);
  Future<bool> processPayment(int bookingId, String paymentMethod);
  Future<List<String>> getAvailableSeats(int showtimeId);
  Future<List<TicketModel>> getUserTickets();
  Future<bool> confirmPayment(
    int bookingId,
    String cardNumber,
    String expiryDate,
    String cvv,
    String cardHolderName,
  );
}

class BookingRemoteDataSourceImpl extends BookingRemoteDataSource {
  final ApiClient _client;

  BookingRemoteDataSourceImpl(this._client);

  @override
  Future<List<ShowtimeModel>> getShowtimes(int movieId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final now = DateTime.now();
      final List<ShowtimeModel> showtimes = [];
      
      // Tạo 3 ngày chiếu khác nhau
      for (int day = 0; day < 3; day++) {
        final showDate = DateTime(now.year, now.month, now.day + day);
        
        // Tạo các suất chiếu riêng biệt
        for (int hour in [10, 13, 16, 19, 22]) {
          // Tạo ID duy nhất cho mỗi suất chiếu
          final showtimeId = int.parse('$movieId${showDate.day}$hour');
          
          // Tạo thời gian chiếu dạng "HH:mm"
          final timeString = '${hour.toString().padLeft(2, '0')}:00';

          showtimes.add(ShowtimeModel(
            id: showtimeId,
            movieId: movieId,
            movieTitle: 'Movie $movieId',
            posterPath: '/path/to/poster',
            showDate: showDate,
            time: timeString,
            price: 75000.0 + (hour - 10) * 5000, // Giá thay đổi theo giờ
            screenType: hour % 2 == 0 ? '2D' : '3D',
          ));
        }
      }

      // Sắp xếp theo ngày và giờ
      showtimes.sort((a, b) {
        int dateCompare = a.showDate.compareTo(b.showDate);
        if (dateCompare != 0) return dateCompare;
        return a.time.compareTo(b.time);
      });

      print('Generated showtimes:');
      for (var showtime in showtimes) {
        print('ID: ${showtime.id}, Date: ${showtime.showDate}, Time: ${showtime.time}');
      }

      return showtimes;
    } catch (e) {
      print('Error fetching showtimes: $e');
      throw Exception('Failed to fetch showtimes');
    }
  }

  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      return BookingModel(
        showtime: booking.showtime,
        id: DateTime.now().millisecondsSinceEpoch,
        showtimeId: booking.showtimeId,
        userId: booking.userId,
        selectedSeats: booking.selectedSeats,
        bookingStatus: 'pending',
        bookingTime: DateTime.now(),
        totalAmount: booking.totalAmount,
      );
    } catch (e) {
      throw Exception('Failed to create booking');
    }
  }

  @override
  Future<List<String>> getAvailableSeats(int showtimeId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Tạo danh sách ghế mẫu từ A1 đến E10
      return List.generate(50, (index) {
        final row = String.fromCharCode(65 + (index ~/ 10)); // A, B, C, D, E
        final seatNum = (index % 10) + 1; // 1 to 10
        return '$row$seatNum';
      });
    } catch (e) {
      throw Exception('Failed to get available seats');
    }
  }

  @override
  Future<bool> processPayment(int bookingId, String paymentMethod) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      return true;
    } catch (e) {
      throw Exception('Failed to process payment');
    }
  }

  @override
  Future<List<TicketModel>> getUserTickets() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      return [
        TicketModel(
          showtimeId: 1,
          movieId: 1,
          id: 1,
          movieTitle: "Test Movie",
          showtime: "14:30 - ${DateTime.now().toString().split(' ')[0]}",
          seats: ["A1", "A2"],
          totalAmount: 20.0,
          confirmationCode: 'CONF-001',
          qrCode: 'BOOKING-001',
          bookingTime: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
    } catch (e) {
      throw Exception('Failed to fetch user tickets');
    }
  }

  @override
  Future<bool> confirmPayment(
    int bookingId,
    String cardNumber,
    String expiryDate,
    String cvv,
    String cardHolderName,
  ) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      return true;
    } catch (e) {
      print('Payment Error: $e');
      throw Exception('Failed to process payment');
    }
  }
}