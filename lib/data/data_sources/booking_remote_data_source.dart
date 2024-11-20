import 'package:cinema/data/core/api_client.dart';
import 'package:cinema/data/models/showtime_model.dart';
import 'package:cinema/data/models/booking_model.dart';
import 'package:cinema/data/models/ticket_model.dart';

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
      final response = await _client.get(
        'movie/$movieId',
        params: {
          'append_to_response': 'release_dates',
        },
      );

      final movieTitle = response['title'] as String;
      final posterPath = response['poster_path'] as String?;

      final List<ShowtimeModel> showtimes = [];
      final standardTimes = ['10:30', '13:00', '15:30', '18:00', '20:30'];

      for (int day = 0; day < 7; day++) {
        final date = DateTime.now().add(Duration(days: day));
        
        showtimes.add(
          ShowtimeModel(
            id: DateTime.now().millisecondsSinceEpoch + day,
            movieId: movieId,
            movieTitle: movieTitle,
            posterPath: posterPath ?? '',
            times: standardTimes,
            screenType: '2D',
            price: 10.0,
            showDate: date,
          ),
        );

        if (day % 2 == 0) {
          final eveningTimes = ['18:30', '21:00'];
          showtimes.add(
            ShowtimeModel(
              id: DateTime.now().millisecondsSinceEpoch + day + 100,
              movieId: movieId,
              movieTitle: movieTitle,
              posterPath: posterPath ?? '',
              times: eveningTimes,
              screenType: '3D',
              price: 15.0,
              showDate: date,
            ),
          );
        }
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