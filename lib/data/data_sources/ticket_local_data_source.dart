import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cinema/data/models/ticket_model.dart';

class TicketLocalDataSource {
  static const String KEY_TICKETS = 'user_tickets';
  final SharedPreferences _prefs;

  TicketLocalDataSource(this._prefs);

  Future<void> saveTicket(TicketModel ticket) async {
    final tickets = await getTickets();
    tickets.add(ticket);
    await saveTickets(tickets);
  }

  Future<void> saveTickets(List<TicketModel> tickets) async {
    final ticketsJson = tickets.map((t) => t.toJson()).toList();
    await _prefs.setString(KEY_TICKETS, jsonEncode(ticketsJson));
  }

  Future<List<TicketModel>> getTickets() async {
    final ticketsString = _prefs.getString(KEY_TICKETS);
    if (ticketsString == null) return [];

    final ticketsJson = jsonDecode(ticketsString) as List;
    return ticketsJson
        .map((json) => TicketModel.fromJson(json))
        .toList();
  }
}