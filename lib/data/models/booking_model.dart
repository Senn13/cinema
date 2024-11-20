import 'package:cinema/domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required int id,
    required int showtimeId,
    required int userId,
    required List<String> selectedSeats,
    required double totalAmount,
    required String bookingStatus,
    required DateTime bookingTime,
  }) : super(
          id: id,
          showtimeId: showtimeId,
          userId: userId,
          selectedSeats: selectedSeats,
          totalAmount: totalAmount,
          bookingStatus: bookingStatus,
          bookingTime: bookingTime,
        );

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      showtimeId: json['showtimeId'],
      userId: json['userId'],
      selectedSeats: json['selectedSeats'],
      totalAmount: json['totalAmount'],
      bookingStatus: json['bookingStatus'],
      bookingTime: DateTime.parse(json['bookingTime']),
    );
  }
}