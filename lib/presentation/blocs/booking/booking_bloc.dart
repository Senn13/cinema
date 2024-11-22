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
import 'package:cinema/data/data_sources/booking_remote_data_source.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final TicketLocalDataSource _ticketLocalDataSource;
  final BookingRemoteDataSource _bookingRemoteDataSource;

  BookingBloc(this._ticketLocalDataSource, this._bookingRemoteDataSource) 
      : super(BookingInitial()) {
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
      
      // Xử lý payment với remote
      final success = await _bookingRemoteDataSource.processPayment(
        event.bookingId,
        event.cardNumber,
      );

      if (!success) {
        throw Exception('Payment failed');
      }

      final ticket = TicketModel(
        id: event.bookingId,
        movieTitle: event.movieTitle,
        showtime: event.showtime,
        seats: event.selectedSeats,
        totalAmount: event.totalAmount,
        confirmationCode: 'CONF-${event.bookingId}',
        qrCode: 'BOOKING-${event.bookingId}',
        bookingTime: DateTime.now(),
        showtimeId: event.showtimeId,
        movieId: event.movieId,
        status: 'active',
      );
      
      await _ticketLocalDataSource.saveTicket(ticket);
      print('Payment completed for ticket: ${ticket.id}'); // Debug log
      emit(PaymentCompleted(ticket: ticket));
    } catch (e) {
      print('Payment error: $e'); // Debug log
      emit(BookingError(message: 'Payment failed: ${e.toString()}'));
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
      emit(BookingError(message: e.toString()));
    }
  }

  Future<void> _onRequestCancellation(
    RequestCancellationEvent event,
    Emitter<BookingState> emit,
  ) async {
    try {
      emit(CancellationProcessing());

      final tickets = await _ticketLocalDataSource.getTickets();
      final ticketToUpdate = tickets.firstWhere((t) => t.id == event.ticketId);

      // Cập nhật trạng thái thành requesting_refund
      final updatedTicket = TicketModel(
        id: ticketToUpdate.id,
        movieTitle: ticketToUpdate.movieTitle,
        showtime: ticketToUpdate.showtime,
        seats: ticketToUpdate.seats,
        totalAmount: ticketToUpdate.totalAmount,
        confirmationCode: ticketToUpdate.confirmationCode,
        qrCode: ticketToUpdate.qrCode,
        bookingTime: ticketToUpdate.bookingTime,
        showtimeId: ticketToUpdate.showtimeId,
        movieId: ticketToUpdate.movieId,
        status: TicketModel.STATUS_REQUESTING_REFUND,
      );

      await _ticketLocalDataSource.updateTicket(updatedTicket);
      
      // Load lại danh sách tickets
      final updatedTickets = await _ticketLocalDataSource.getTickets();
      emit(TicketsLoaded(tickets: updatedTickets));
    } catch (e) {
      emit(BookingError(message: 'Failed to request refund: ${e.toString()}'));
    }
  }
}