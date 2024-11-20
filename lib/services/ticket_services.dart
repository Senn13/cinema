import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:cinema/data/models/ticket_model.dart';

class TicketService {
  Future<File> generateTicketPDF(TicketModel ticket) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Container(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'CINEMA TICKET',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 20),
              _buildTicketRow('Movie:', ticket.movieTitle),
              _buildTicketRow('Date & Time:', ticket.showtime),
              _buildTicketRow('Seats:', ticket.seats.join(", ")),
              _buildTicketRow('Total Amount:', '\$${ticket.totalAmount.toStringAsFixed(2)}'),
              _buildTicketRow('Confirmation Code:', ticket.confirmationCode),
              pw.SizedBox(height: 20),
              pw.Divider(thickness: 2),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text(
                  'Please show this ticket at the cinema entrance',
                  style: pw.TextStyle(
                    fontStyle: pw.FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/ticket_${ticket.id}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  pw.Widget _buildTicketRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value),
          ),
        ],
      ),
    );
  }

  Future<void> downloadTicket(TicketModel ticket) async {
    try {
      final file = await generateTicketPDF(ticket);
      final downloads = await getDownloadsDirectory();
      if (downloads != null) {
        final savedFile = await file.copy('${downloads.path}/ticket_${ticket.id}.pdf');
        print('Ticket saved to: ${savedFile.path}');
      }
    } catch (e) {
      print('Error downloading ticket: $e');
      rethrow;
    }
  }

  Future<void> shareTicket(TicketModel ticket) async {
    try {
      final file = await generateTicketPDF(ticket);
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Movie Ticket - ${ticket.movieTitle}',
        text: 'Here is your movie ticket for ${ticket.movieTitle}',
      );
    } catch (e) {
      print('Error sharing ticket: $e');
      rethrow;
    }
  }
}