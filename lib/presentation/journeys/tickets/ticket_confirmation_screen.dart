import 'package:cinema/common/constants/route_constants.dart';
import 'package:cinema/common/constants/size_constants.dart';
import 'package:cinema/common/extensions/size_extensions.dart';
import 'package:cinema/presentation/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cinema/common/constants/translation_constants.dart';
import 'package:cinema/common/extensions/string_extensions.dart';
import 'package:cinema/data/models/ticket_model.dart';
import 'package:cinema/presentation/theme/theme_color.dart';
import 'package:cinema/services/ticket_services.dart';
import 'package:flutter/services.dart';

class TicketConfirmationScreen extends StatelessWidget {
  final TicketModel ticket;
  late final TicketService _ticketService;

  TicketConfirmationScreen({
    Key? key,
    required this.ticket,
  }) : super(key: key) {
    _ticketService = TicketService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.vulcan,
      appBar: AppBar(
        backgroundColor: AppColor.vulcan,
        title: Text(
          TranslationConstants.ticketConfirmation.t(context),
          style: const TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.withOpacity(0.08),
              AppColor.vulcan.withOpacity(0.98),
            ],
            stops: const [0.1, 0.7],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSuccessMessage(context),
                const SizedBox(height: 24),
                _buildTicketCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessMessage(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: 60,
        ),
        const SizedBox(height: 8),
        Text(
          TranslationConstants.paymentSuccessful.t(context),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.green.withOpacity(0.9),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
        ),
      ],
    );
  }

  Widget _buildTicketCard(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.9,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            ticket.movieTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.access_time, size: 18),
              const SizedBox(width: 8),
              Text(
                'Showtime: ${ticket.showtime}',
                style: const TextStyle(color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.event_seat, size: 18),
              const SizedBox(width: 8),
              Text(
                'Seats: ${ticket.seats.join(", ")}',
                style: const TextStyle(color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.attach_money, size: 18),
              const SizedBox(width: 8),
              Text(
                'Total Amount: \$${ticket.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  'CONFIRMATION CODE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 12,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ticket.confirmationCode,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Ticket QR Code',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black.withOpacity(0.7),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          QrImageView(
            data: ticket.qrCode,
            size: 150,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _handleDownload(context),
                  icon: const Icon(Icons.download, color: Colors.black),
                  label: const Text('Download',
                      style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.withOpacity(0.2),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _handleShare(context),
                  icon: const Icon(Icons.share, color: Colors.black),
                  label: const Text('Share',
                      style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.withOpacity(0.2),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteList.home,
                  (route) => false,
                );
              },
              icon: const Icon(Icons.home, color: Colors.black),
              label: const Text('Back to Home',
                  style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.withOpacity(0.2),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Colors.green.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDownload(BuildContext context) async {
    try {
      await _ticketService.downloadTicket(ticket);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ticket downloaded successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to download ticket'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleShare(BuildContext context) async {
    try {
      final String ticketInfo = '''
🎬 ${ticket.movieTitle}
🕒 Showtime: ${ticket.showtime}
💺 Seats: ${ticket.seats.join(", ")}
💰 Total Amount: \$${ticket.totalAmount.toStringAsFixed(2)}
🎫 Confirmation Code: ${ticket.confirmationCode}

Thank you for choosing our cinema! Enjoy your movie! 🍿
''';

      await Clipboard.setData(ClipboardData(text: ticketInfo));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ticket information copied to clipboard'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to copy ticket information: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}