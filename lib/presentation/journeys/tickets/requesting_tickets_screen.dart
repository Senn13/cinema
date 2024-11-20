import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinema/data/models/ticket_model.dart';
import 'package:cinema/presentation/blocs/booking/booking_bloc.dart';

class RequestingTicketsScreen extends StatefulWidget {
  const RequestingTicketsScreen({Key? key}) : super(key: key);

  @override
  State<RequestingTicketsScreen> createState() => _RequestingTicketsScreenState();
}

class _RequestingTicketsScreenState extends State<RequestingTicketsScreen> {
  @override
  void initState() {
    super.initState();
    // Load tickets khi vào màn hình
    context.read<BookingBloc>().add(LoadUserTicketsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Requesting Tickets',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          print('Current state: $state'); // Debug log

          if (state is TicketsLoaded) {
            final requestingTickets = state.tickets
                .where((ticket) => ticket.status == 'cancellation_pending')
                .toList();

            print('Found ${requestingTickets.length} requesting tickets'); // Debug log

            if (requestingTickets.isEmpty) {
              return const Center(
                child: Text(
                  'No pending refund requests',
                  style: TextStyle(color: Colors.black),
                ),
              );
            }

            return ListView.builder(
              itemCount: requestingTickets.length,
              itemBuilder: (context, index) {
                final ticket = requestingTickets[index];
                return RequestingTicketCard(ticket: ticket);
              },
            );
          }

          if (state is TicketsEmpty) {
            return const Center(
              child: Text(
                'No tickets found',
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          if (state is BookingError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class RequestingTicketCard extends StatelessWidget {
  final TicketModel ticket;

  const RequestingTicketCard({
    Key? key,
    required this.ticket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.movieTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Date & Time: ${ticket.showtime}',
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              'Seats: ${ticket.seats.join(", ")}',
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              'Amount to Refund: \$${ticket.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.black),
            ),
            Text(
              'Request Time: ${ticket.bookingTime}',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            const Chip(
              label: Text(
                'Processing Refund',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}