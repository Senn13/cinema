import 'package:dartz/dartz.dart';
import 'package:cinema/domain/entities/app_error.dart';
import 'package:cinema/domain/repositories/booking_repository.dart';
import 'package:cinema/data/models/booking_model.dart';

class CreateBooking {
  final BookingRepository repository;

  CreateBooking(this.repository);

  Future<Either<AppError, BookingModel>> call(BookingModel booking) async {
    return await repository.createBooking(booking);
  }
}