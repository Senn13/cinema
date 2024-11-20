import 'package:bloc/bloc.dart';
import 'package:cinema/data/models/ticket_model.dart';
import 'package:equatable/equatable.dart';
import 'package:cinema/data/models/booking_model.dart';
import 'package:cinema/data/models/showtime_model.dart';
import 'package:cinema/domain/usecases/get_showtime.dart';
import 'package:cinema/domain/usecases/get_user_tickets.dart';
import 'package:cinema/domain/usecases/process_payment.dart';
import 'package:dartz/dartz.dart';
import 'package:cinema/data/data_sources/ticket_local_data_source.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final TicketLocalDataSource _ticketLocalDataSource;

  BookingBloc(this._ticketLocalDataSource) : super(BookingInitial()) {
    on<ProcessPaymentEvent>(_onProcessPayment);
    on<LoadUserTicketsEvent>(_onLoadUserTickets);
    on<RequestCancellationEvent>(_onRequestCancellation);
  }

  Future<void> _onProcessPayment(
    ProcessPaymentEvent event,
    Emitter<BookingState> emit,
  ) async {
    try {
      emit(PaymentProcessing());
      
      final ticket = TicketModel(
        id: event.bookingId,
        movieTitle: event.movieTitle,
        showtime: event.showtime,
        seats: event.selectedSeats,
        totalAmount: event.totalAmount,
        confirmationCode: 'CONF-${event.bookingId}',
        qrCode: 'BOOKING-${event.bookingId}',
        bookingTime: DateTime.now(),
      );
      
      await _ticketLocalDataSource.saveTicket(ticket);
      emit(PaymentCompleted(ticket: ticket));
    } catch (e) {
      emit(BookingError(message: 'Payment failed. Please try again.'));
    }
  }

  Future<void> _onLoadUserTickets(
    LoadUserTicketsEvent event,
    Emitter<BookingState> emit,
  ) async {
    try {
      emit(TicketsLoading());
      final tickets = await _ticketLocalDataSource.getTickets();
      
      if (tickets.isEmpty) {
        emit(TicketsEmpty());
      } else {
        emit(TicketsLoaded(tickets: tickets));
      }
    } catch (e) {
      emit(BookingError(message: 'Failed to load tickets'));
    }
  }

  Future<void> _onRequestCancellation(
    RequestCancellationEvent event,
    Emitter<BookingState> emit,
  ) async {
    try {
      emit(TicketsLoading());
      
      final tickets = await _ticketLocalDataSource.getTickets();
      final updatedTickets = tickets.map((ticket) {
        if (ticket.id == event.ticketId) {
          return ticket.copyWith(status: 'cancellation_pending');
        }
        return ticket;
      }).toList();
      
      await _ticketLocalDataSource.saveTickets(updatedTickets);
      emit(TicketsLoaded(tickets: updatedTickets));
      
    } catch (e) {
      emit(BookingError(message: 'Failed to request cancellation'));
    }
  }
}