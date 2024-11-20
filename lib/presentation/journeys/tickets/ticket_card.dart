import 'package:cinema/presentation/journeys/tickets/ticket_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:cinema/data/models/ticket_model.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;

  const TicketCard({
    Key? key,
    required this.ticket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: Card(
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
                'Amount: \$${ticket.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Tap to view details',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}