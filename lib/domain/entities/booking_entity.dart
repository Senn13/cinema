import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final int id;
  final int showtimeId;
  final int userId;
  final List<String> selectedSeats;
  final double totalAmount;
  final String bookingStatus;
  final DateTime bookingTime;

  const BookingEntity({
    required this.id,
    required this.showtimeId,
    required this.userId,
    required this.selectedSeats,
    required this.totalAmount,
    required this.bookingStatus,
    required this.bookingTime,
  });

  @override
  List<Object> get props => [
    id,
    showtimeId,
    userId,
    selectedSeats,
    totalAmount,
    bookingStatus,
    bookingTime,
  ];
}