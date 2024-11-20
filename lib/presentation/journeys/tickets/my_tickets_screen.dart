import 'package:cinema/data/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinema/common/constants/translation_constants.dart';
import 'package:cinema/common/extensions/string_extensions.dart';
import 'package:cinema/presentation/blocs/booking/booking_bloc.dart';
import 'package:cinema/presentation/journeys/tickets/requesting_tickets_screen.dart';
import 'package:cinema/presentation/journeys/tickets/ticket_confirmation_screen.dart';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({Key? key}) : super(key: key);

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(LoadUserTicketsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TranslationConstants.myTickets.t(context),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.pending_actions),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RequestingTicketsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is TicketsLoaded) {
            final activeTickets = state.tickets
                .where((ticket) => ticket.status == 'active')
                .toList();

            if (activeTickets.isEmpty) {
              return Center(
                child: Text(
                  TranslationConstants.noTickets.t(context),
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }

            return ListView.builder(
              itemCount: activeTickets.length,
              itemBuilder: (context, index) {
                final ticket = activeTickets[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicketConfirmationScreen(
                          ticket: ticket,
                        ),
                      ),
                    );
                  },
                  child: TicketCard(ticket: ticket),
                );
              },
            );
          }

          if (state is TicketsEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    TranslationConstants.noTickets.t(context),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BookingBloc>().add(LoadUserTicketsEvent());
                    },
                    child: Text(TranslationConstants.retry.t(context)),
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final TicketModel ticket;

  const TicketCard({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    ticket.movieTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                ),
                _buildStatusChip(),
              ],
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
              'Amount: \$${ticket.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.black),
            ),
            if (ticket.status == 'active') ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () => _showCancellationDialog(context),
                  child: const Text(
                    'Request Refund',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    String statusText;
    
    switch (ticket.status) {
      case 'active':
        chipColor = Colors.green;
        statusText = 'Active';
        break;
      case 'cancellation_pending':
        chipColor = Colors.orange;
        statusText = 'Refund Pending';
        break;
      case 'cancelled':
        chipColor = Colors.red;
        statusText = 'Refunded';
        break;
      default:
        chipColor = Colors.grey;
        statusText = 'Unknown';
    }

    return Chip(
      label: Text(
        statusText,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: chipColor,
    );
  }

  void _showCancellationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Confirm Refund Request',
          style: TextStyle(color: Colors.black),
        ),
        content: const Text(
          'Are you sure you want to request a refund for this ticket? This action cannot be undone.',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<BookingBloc>().add(RequestCancellationEvent(ticket.id));
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text(
              'Request Refund',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
