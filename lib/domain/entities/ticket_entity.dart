import 'package:equatable/equatable.dart';

class TicketEntity extends Equatable {
  final int id;
  final String movieTitle;
  final String showtime;
  final List<String> seats;
  final double totalAmount;
  final String confirmationCode;
  final String qrCode;
  final DateTime bookingTime;
  final String? status;
  final int showtimeId;
  final int movieId;

  const TicketEntity({
    required this.id,
    required this.movieTitle,
    required this.showtime,
    required this.seats,
    required this.totalAmount,
    required this.confirmationCode,
    required this.qrCode,
    required this.bookingTime,
    required this.showtimeId,
    required this.movieId,
    this.status,
  });

  @override
  List<Object> get props => [
    id,
    movieTitle,
    showtime,
    seats,
    totalAmount,
    confirmationCode,
    qrCode,
    bookingTime,
    status ?? '',
    showtimeId,
    movieId,
  ];
}