class SeatEntity {
  final int id;
  final String row;
  final int seatNumber; 
  final bool isAvailable;
  final double price;

  SeatEntity({
    required this.id,
    required this.row,
    required this.seatNumber,
    required this.isAvailable,
    required this.price,
  });
}