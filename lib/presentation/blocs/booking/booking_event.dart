part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class LoadUserTicketsEvent extends BookingEvent {}

class LoadShowtimesEvent extends BookingEvent {
  final int movieId;

  const LoadShowtimesEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}

class SelectShowtimeEvent extends BookingEvent {
  final ShowtimeModel showtime;

  const SelectShowtimeEvent(this.showtime);

  @override
  List<Object> get props => [showtime];
}

class LoadSeatsEvent extends BookingEvent {
  final int showtimeId;

  const LoadSeatsEvent(this.showtimeId);

  @override
  List<Object> get props => [showtimeId];
}

class SelectSeatsEvent extends BookingEvent {
  final List<String> selectedSeats;

  const SelectSeatsEvent(this.selectedSeats);

  @override
  List<Object> get props => [selectedSeats];
}

class CreateBookingEvent extends BookingEvent {
  final BookingModel booking;

  const CreateBookingEvent(this.booking);

  @override
  List<Object> get props => [booking];
}

class ProcessPaymentEvent extends BookingEvent {
  final int bookingId;
  final int showtimeId;
  final int userId;
  final String movieTitle;
  final String showtime;
  final List<String> selectedSeats;
  final double totalAmount;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String cardHolderName;
  final int movieId;

  const ProcessPaymentEvent({
    required this.bookingId,
    required this.showtimeId,
    required this.userId,
    required this.movieTitle,
    required this.showtime,
    required this.selectedSeats,
    required this.totalAmount,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.cardHolderName,
    required this.movieId,
  });

  @override
  List<Object> get props => [
    bookingId,
    showtimeId,
    userId,
    movieTitle,
    showtime,
    selectedSeats,
    totalAmount,
    cardNumber,
    expiryDate,
    cvv,
    cardHolderName,
    movieId,
  ];
}

class CancelBookingEvent extends BookingEvent {
  final int bookingId;

  const CancelBookingEvent(this.bookingId);

  @override
  List<Object> get props => [bookingId];
}

class RequestCancellationEvent extends BookingEvent {
  final int ticketId;

  const RequestCancellationEvent(this.ticketId);

  @override
  List<Object> get props => [ticketId];
}