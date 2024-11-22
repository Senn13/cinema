import 'package:cinema/domain/entities/ticket_entity.dart';

class TicketModel extends TicketEntity {
  static const String STATUS_ACTIVE = 'active';
  static const String STATUS_CANCELLED = 'cancelled';
  static const String STATUS_REQUESTING_REFUND = 'requesting_refund';

  final String status;
  final int showtimeId;
  final int movieId;

  const TicketModel({
    required int id,
    required String movieTitle,
    required String showtime,
    required List<String> seats,
    required double totalAmount,
    required String confirmationCode,
    required String qrCode,
    required DateTime bookingTime,
    required this.showtimeId,
    required this.movieId,
    this.status = STATUS_ACTIVE,
  }) : super(
    id: id,
    movieTitle: movieTitle,
    showtime: showtime,
    seats: seats,
    totalAmount: totalAmount,
    confirmationCode: confirmationCode,
    qrCode: qrCode,
    bookingTime: bookingTime,
    showtimeId: showtimeId,
    movieId: movieId,
  );

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] as int,
      movieTitle: json['movieTitle'] as String,
      showtime: json['showtime'] as String,
      seats: (json['seats'] as List<dynamic>).map((e) => e.toString()).toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      confirmationCode: json['confirmationCode'] as String,
      qrCode: json['qrCode'] as String,
      bookingTime: DateTime.parse(json['bookingTime'] as String),
      status: json['status'] as String? ?? STATUS_ACTIVE,
      showtimeId: json['showtimeId'] as int,
      movieId: json['movieId'] as int,
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
      'showtimeId': showtimeId,
      'movieId': movieId,
    };
  }

  TicketModel copyWith({
    String? status,
    int? showtimeId,
    int? movieId,
  }) {
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
      showtimeId: showtimeId ?? this.showtimeId,
      movieId: movieId ?? this.movieId,
    );
  }
}