import 'package:cinema/common/constants/translation_constants.dart';
import 'package:cinema/common/extensions/string_extensions.dart';
import 'package:cinema/data/data_sources/seat_booking_local_data_source.dart';
import 'package:cinema/di/get_it.dart';
import 'package:cinema/domain/entities/movie_entity.dart';
import 'package:cinema/presentation/journeys/payment/payment_screen.dart';
import 'package:cinema/presentation/theme/theme_color.dart';
import 'package:flutter/material.dart';

class SeatSelectionScreen extends StatefulWidget {
  final int showtimeId;
  final double price;
  final MovieEntity movie;
  final String showtime;

  const SeatSelectionScreen({
    Key? key,
    required this.showtimeId,
    required this.price,
    required this.movie,
    required this.showtime,
  }) : super(key: key);

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  // Các màu sắc chung
  static const seatAvailableColor = Color(0xFFE8F5E9); // Xanh lá nhạt
  static const seatSelectedColor = AppColor.royalBlue; // Xanh dơng đậm
  static const seatBookedColor = Color(0xFFFFCDD2); // Đỏ đậm hơn cho ghế đã đặt
  static const screenColor = Color(0xFF90CAF9); // Xanh dương nhạt
  
  // Các biến state
  Set<String> selectedSeats = {};
  List<String> bookedSeats = [];
  
  @override
  void initState() {
    super.initState();
    _loadBookedSeats();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBookedSeats();
  }

  Future<void> _loadBookedSeats() async {
    if (!mounted) return;
    
    try {
      final seatBookingLocalDataSource = getItInstance<SeatBookingLocalDataSource>();
      final bookings = await seatBookingLocalDataSource.getValidBookedSeats(
        widget.showtimeId,
        widget.showtime,
      );
      
      if (mounted) {
        setState(() {
          bookedSeats = bookings.map((booking) => booking.seatNumber).toList();
          print('Loaded booked seats for showtime ${widget.showtimeId}: ${bookedSeats.join(", ")}');
        });
      }
    } catch (e) {
      print('Error loading booked seats: $e');
    }
  }

  void _proceedToPayment() {
    final totalAmount = widget.price * selectedSeats.length;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          selectedSeats: selectedSeats.toList(),
          showtimeId: widget.showtimeId,
          showtime: widget.showtime,
          price: widget.price,
          movie: widget.movie,
          bookingId: DateTime.now().millisecondsSinceEpoch,
          totalAmount: totalAmount,
        ),
      ),
    ).then((_) {
      selectedSeats.clear();
      _loadBookedSeats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TranslationConstants.selectSeats.t(context),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          _buildSeatLegend(),
          _buildScreen(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                childAspectRatio: 1,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemBuilder: (context, index) {
                final seatNumber = _getSeatNumber(index);
                final isBooked = bookedSeats.contains(seatNumber);
                return _buildSeat(seatNumber, !isBooked);
              },
              itemCount: 64,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${TranslationConstants.selected.t(context)}: ${selectedSeats.length} ${TranslationConstants.seats.t(context)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      '${TranslationConstants.totalAmount.t(context)}: \$${(selectedSeats.length * widget.price).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.royalBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: selectedSeats.isNotEmpty ? _proceedToPayment : null,
                    child: Text(
                      TranslationConstants.proceedToPayment.t(context),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeat(String seatNumber, bool isAvailable) {
    final isBooked = bookedSeats.contains(seatNumber);
    final isSelected = selectedSeats.contains(seatNumber);
    
    return GestureDetector(
      onTap: isBooked ? null : () {
        setState(() {
          if (isSelected) {
            selectedSeats.remove(seatNumber);
          } else {
            selectedSeats.add(seatNumber);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isBooked 
              ? seatBookedColor 
              : isSelected 
                  ? seatSelectedColor 
                  : seatAvailableColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
            bottomLeft: Radius.circular(3),
            bottomRight: Radius.circular(3),
          ),
          boxShadow: [
            BoxShadow(
              color: isBooked
                  ? Colors.red.withOpacity(0.3) // Thêm shadow cho ghế đã đặt
                  : isSelected 
                      ? seatSelectedColor.withOpacity(0.5)
                      : Colors.grey.withOpacity(0.2),
              spreadRadius: 0.5,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          border: Border.all(
            color: isBooked 
                ? Colors.red // Viền đậm hơn cho ghế đã đặt
                : isSelected 
                    ? seatSelectedColor 
                    : Colors.grey.withOpacity(0.3),
            width: isBooked ? 1.5 : 1, // Viền dày hơn cho ghế đã đặt
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chair,
                  size: isBooked ? 18 : 16, // Icon lớn hơn cho ghế đã đặt
                  color: isBooked 
                      ? Colors.red // Màu đỏ đậm hơn cho icon ghế đã đặt
                      : isSelected 
                          ? Colors.white 
                          : Colors.grey[600],
                ),
                const SizedBox(height: 1),
                Text(
                  seatNumber,
                  style: TextStyle(
                    fontSize: isBooked ? 11 : 10, // Chữ lớn hơn cho ghế đã đặt
                    fontWeight: FontWeight.bold,
                    color: isBooked 
                        ? Colors.red // Màu đỏ đậm hơn cho chữ ghế đã đặt
                        : isSelected 
                            ? Colors.white 
                            : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScreen() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            decoration: BoxDecoration(
              color: screenColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: screenColor),
            ),
            child: const Text(
              'SCREEN',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  screenColor.withOpacity(0.1),
                  screenColor,
                  screenColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendItem(Colors.white, TranslationConstants.available.t(context)),
          const SizedBox(width: 16),
          _buildLegendItem(seatSelectedColor, TranslationConstants.selected.t(context)),
          const SizedBox(width: 16),
          _buildLegendItem(seatBookedColor, TranslationConstants.booked.t(context)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    final isBooked = label == TranslationConstants.booked.t(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isBooked ? Colors.red : color,
                width: isBooked ? 1.5 : 1,
              ),
            ),
            child: Icon(
              Icons.chair,
              size: 16,
              color: isBooked ? Colors.red : (color == Colors.white ? Colors.grey[600] : Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBooked ? FontWeight.bold : FontWeight.w500,
              color: isBooked ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _getSeatNumber(int index) {
    return String.fromCharCode(65 + (index ~/ 8)) + 
           (index % 8 + 1).toString();
  }
}