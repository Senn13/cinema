import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:cinema/domain/entities/app_error.dart';
import 'package:cinema/data/models/showtime_model.dart';
import 'package:cinema/data/models/booking_model.dart';
import 'package:cinema/domain/repositories/booking_repository.dart';
import 'package:cinema/data/data_sources/booking_remote_data_source.dart';
import 'package:cinema/data/models/ticket_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BookingRepositoryImpl extends BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  final SharedPreferences prefs;

  BookingRepositoryImpl(this.remoteDataSource, this.prefs);

  @override
  Future<Either<AppError, List<ShowtimeModel>>> getShowtimes(int movieId) async {
    try {
      final showtimes = await remoteDataSource.getShowtimes(movieId);
      return Right(showtimes);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on Exception {
      return Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, BookingModel>> createBooking(BookingModel booking) async {
    try {
      final result = await remoteDataSource.createBooking(booking);
      return Right(result);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on Exception {
      return Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, List<String>>> getAvailableSeats(int showtimeId) async {
    try {
      final seats = await remoteDataSource.getAvailableSeats(showtimeId);
      return Right(seats);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on Exception {
      return Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, bool>> confirmPayment(
    int bookingId,
    String cardNumber,
    String expiryDate,
    String cvv,
    String cardHolderName,
  ) async {
    try {
      print('Repository - Confirming Payment:');
      print('Booking ID: $bookingId');
      print('Card Details: $cardNumber, $expiryDate');
      
      final result = await remoteDataSource.confirmPayment(
        bookingId,
        cardNumber,
        expiryDate,
        cvv,
        cardHolderName,
      );
      return Right(result);
    } on SocketException {
      print('Repository - Network Error');
      return Left(AppError(AppErrorType.network));
    } on Exception catch (e) {
      print('Repository - API Error: $e');
      return Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, List<TicketModel>>> getUserTickets() async {
    try {
      final tickets = await remoteDataSource.getUserTickets();
      return Right(tickets);
    } on SocketException {
      return const Left(AppError(AppErrorType.network));
    } on Exception {
      return const Left(AppError(AppErrorType.api));
    }
  }
}