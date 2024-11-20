import 'package:dartz/dartz.dart';
import 'package:cinema/domain/entities/app_error.dart';
import 'package:cinema/domain/repositories/booking_repository.dart';
import 'package:cinema/data/models/showtime_model.dart';

class GetShowtimes {
  final BookingRepository repository;

  GetShowtimes(this.repository);

  Future<Either<AppError, List<ShowtimeModel>>> call(int movieId) async {
    return await repository.getShowtimes(movieId);
  }
}