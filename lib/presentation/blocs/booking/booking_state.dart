part of 'booking_bloc.dart';

abstract class BookingState extends Equatable {
  const BookingState();
  
  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class PaymentProcessing extends BookingState {}

class PaymentCompleted extends BookingState {
  final TicketModel ticket;

  const PaymentCompleted({required this.ticket});

  @override
  List<Object> get props => [ticket];
}

class BookingError extends BookingState {
  final String message;

  const BookingError({required this.message});

  @override
  List<Object> get props => [message];
}

class TicketsState extends BookingState {}

class TicketsLoading extends TicketsState {}

class TicketsLoaded extends TicketsState {
  final List<TicketModel> tickets;

  TicketsLoaded({required this.tickets});

  @override
  List<Object> get props => [tickets];
}

class TicketsEmpty extends TicketsState {}

class ShowtimesLoaded extends BookingState {
  final List<ShowtimeModel> showtimes;

  const ShowtimesLoaded({required this.showtimes});

  @override
  List<Object> get props => [showtimes];
}

class ShowtimeSelected extends BookingState {
  final ShowtimeModel showtime;

  const ShowtimeSelected({required this.showtime});

  @override
  List<Object> get props => [showtime];
}

class SeatsSelected extends BookingState {
  final ShowtimeModel showtime;
  final List<String> selectedSeats;
  final double totalAmount;

  const SeatsSelected({
    required this.showtime,
    required this.selectedSeats,
    required this.totalAmount,
  });

  @override
  List<Object> get props => [showtime, selectedSeats, totalAmount];
}

class BookingLoaded extends BookingState {
  final ShowtimeModel showtime;
  final List<String> selectedSeats;
  final double totalAmount;
  final int userId;

  BookingLoaded({
    required this.showtime,
    required this.selectedSeats,
    required this.totalAmount,
    required this.userId,
  });

  @override
  List<Object> get props => [showtime, selectedSeats, totalAmount, userId];
}