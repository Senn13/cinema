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
          print('Current state: $state');

          if (state is TicketsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TicketsLoaded) {
            // Lọc ra các vé đang request refund
            final requestingTickets = state.tickets.where((ticket) => 
              ticket.status == 'requesting_refund').toList();

            if (requestingTickets.isEmpty) {
              return const Center(
                child: Text('No tickets requesting refund'),
              );
            }

            return ListView.builder(
              itemCount: requestingTickets.length,
              itemBuilder: (context, index) {
                final ticket = requestingTickets[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Movie: ${ticket.movieTitle}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Showtime: ${ticket.showtime}'),
                        Text('Seats: ${ticket.seats.join(", ")}'),
                        Text('Status: ${ticket.status}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }
}