import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cinema/data/models/ticket_model.dart';

class TicketLocalDataSource {
  static const String KEY_TICKETS = 'tickets';
  final SharedPreferences _prefs;

  TicketLocalDataSource(this._prefs);

  Future<void> saveTicket(TicketModel ticket) async {
    try {
      final tickets = await getTickets();
      tickets.add(ticket);
      
      final ticketsJson = tickets.map((t) => t.toJson()).toList();
      await _prefs.setString(KEY_TICKETS, jsonEncode(ticketsJson));
      print('Saved ticket: ${ticket.id}'); // Debug log
    } catch (e) {
      print('Error saving ticket: $e');
      throw Exception('Failed to save ticket');
    }
  }

  Future<List<TicketModel>> getTickets() async {
    try {
      final ticketsString = _prefs.getString(KEY_TICKETS);
      if (ticketsString == null || ticketsString.isEmpty) {
        print('No tickets found'); // Debug log
        return [];
      }

      final List<dynamic> ticketsJson = jsonDecode(ticketsString);
      final tickets = ticketsJson.map((json) {
        // Đảm bảo các trường số được parse đúng
        json['id'] = json['id'] is String ? int.parse(json['id']) : json['id'];
        json['showtimeId'] = json['showtimeId'] is String ? 
            int.parse(json['showtimeId']) : json['showtimeId'];
        json['movieId'] = json['movieId'] is String ? 
            int.parse(json['movieId']) : json['movieId'];
        return TicketModel.fromJson(json);
      }).toList();
      return tickets;
    } catch (e) {
      print('Error getting tickets: $e');
      throw Exception('Failed to get tickets');
    }
  }

  Future<void> updateTicket(TicketModel updatedTicket) async {
    try {
      final tickets = await getTickets();
      final index = tickets.indexWhere((t) => t.id == updatedTicket.id);
      if (index != -1) {
        tickets[index] = updatedTicket;
        final ticketsJson = tickets.map((t) => t.toJson()).toList();
        await _prefs.setString(KEY_TICKETS, jsonEncode(ticketsJson));
      }
    } catch (e) {
      print('Error updating ticket: $e');
      throw Exception('Failed to update ticket');
    }
  }
}