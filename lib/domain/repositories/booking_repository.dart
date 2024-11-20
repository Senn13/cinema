import 'package:cinema/data/models/booking_model.dart';
import 'package:cinema/data/models/showtime_model.dart';
import 'package:dartz/dartz.dart';
import 'package:cinema/domain/entities/app_error.dart';
import 'package:cinema/domain/entities/ticket_entity.dart';

abstract class BookingRepository {
  Future<Either<AppError, List<TicketEntity>>> getUserTickets();
  Future<Either<AppError, bool>> confirmPayment(
    int bookingId,
    String cardNumber,
    String expiryDate,
    String cvv,
    String cardHolderName,
  );
  Future<Either<AppError, List<ShowtimeModel>>> getShowtimes(int movieId);
  Future<Either<AppError, BookingModel>> createBooking(BookingModel booking);
  Future<Either<AppError, List<String>>> getAvailableSeats(int showtimeId);
}