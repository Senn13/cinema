import 'package:cinema/domain/entities/ticket_entity.dart';

class TicketModel extends TicketEntity {
  final String status; // active, cancellation_pending, cancelled

  const TicketModel({
    required int id,
    required String movieTitle,
    required String showtime,
    required List<String> seats,
    required double totalAmount,
    required String confirmationCode,
    required String qrCode,
    required DateTime bookingTime,
    this.status = 'active',
  }) : super(
    id: id,
    movieTitle: movieTitle,
    showtime: showtime,
    seats: seats,
    totalAmount: totalAmount,
    confirmationCode: confirmationCode,
    qrCode: qrCode,
    bookingTime: bookingTime,
  );

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'],
      movieTitle: json['movieTitle'],
      showtime: json['showtime'],
      seats: List<String>.from(json['seats']),
      totalAmount: json['totalAmount'],
      confirmationCode: json['confirmationCode'],
      qrCode: json['qrCode'],
      bookingTime: DateTime.parse(json['bookingTime']),
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movieTitle': movieTitle,
      'showtime': showtime,
      'seats': seats,
      'totalAmount': totalAmount,
      'confirmationCode': confirmationCode,
      'qrCode': qrCode,
      'bookingTime': bookingTime.toIso8601String(),
      'status': status,
    };
  }

  TicketModel copyWith({String? status}) {
    return TicketModel(
      id: id,
      movieTitle: movieTitle,
      showtime: showtime,
      seats: seats,
      totalAmount: totalAmount,
      confirmationCode: confirmationCode,
      qrCode: qrCode,
      bookingTime: bookingTime,
      status: status ?? this.status,
    );
  }
}