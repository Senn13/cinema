
import 'package:dartz/dartz.dart';
import 'package:cinema/domain/entities/app_error.dart';
import 'package:cinema/domain/repositories/booking_repository.dart';
import 'package:cinema/domain/entities/ticket_entity.dart';
import 'package:cinema/domain/usecases/usecases.dart';

class GetUserTickets extends UseCase<List<TicketEntity>, NoParams> {
  final BookingRepository bookingRepository;

  GetUserTickets(this.bookingRepository);

  @override
  Future<Either<AppError, List<TicketEntity>>> call(NoParams params) async {
    return await bookingRepository.getUserTickets();
  }
}

class NoParams {
  const NoParams();
}
