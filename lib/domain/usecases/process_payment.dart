import 'package:cinema/domain/entities/app_error.dart';
import 'package:cinema/domain/entities/booking_entity.dart';
import 'package:cinema/domain/repositories/booking_repository.dart';
import 'package:cinema/domain/usecases/usecases.dart';
import 'package:dartz/dartz.dart';

class ProcessPayment extends UseCase<bool, PaymentParams> {
  final BookingRepository bookingRepository;

  ProcessPayment(this.bookingRepository);

  @override
  Future<Either<AppError, bool>> call(PaymentParams params) async {
    return await bookingRepository.confirmPayment(
      params.bookingId,
      params.cardNumber,
      params.expiryDate,
      params.cvv,
      params.cardHolderName,
    );
  }
}

class PaymentParams {
  final int bookingId;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String cardHolderName;

  PaymentParams({
    required this.bookingId,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.cardHolderName,
  });
}