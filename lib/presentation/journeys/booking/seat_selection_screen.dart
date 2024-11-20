import 'package:cinema/common/constants/translation_constants.dart';
import 'package:cinema/common/extensions/string_extensions.dart';
import 'package:cinema/data/models/booking_model.dart';
import 'package:cinema/di/get_it.dart';
import 'package:cinema/domain/entities/movie_entity.dart';
import 'package:cinema/presentation/blocs/booking/booking_bloc.dart';
import 'package:cinema/presentation/journeys/payment/payment_screen.dart';
import 'package:cinema/presentation/theme/theme_color.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeatSelectionScreen extends StatefulWidget {
  final int showtimeId;
  final double price;
  final MovieEntity movie;

  const SeatSelectionScreen({
    Key? key,
    required this.showtimeId,
    required this.price,
    required this.movie,
  }) : super(key: key);

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  Set<String> selectedSeats = {};

  void _proceedToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          bookingId: DateTime.now().millisecondsSinceEpoch,
          showtimeId: widget.showtimeId,
          userId: 1,
          movieTitle: widget.movie.title,
          showtime: DateTime.now().toString(),
          selectedSeats: selectedSeats.toList(),
          totalAmount: selectedSeats.length * widget.price,
        ),
      ),
    );
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
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  'SCREEN',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final seatNumber = String.fromCharCode(65 + (index ~/ 8)) + 
                                 (index % 8 + 1).toString();
                return _buildSeat(seatNumber, true);
              },
              itemCount: 64, // 8x8 grid
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
    final isSelected = selectedSeats.contains(seatNumber);
    
    return GestureDetector(
      onTap: isAvailable ? () {
        setState(() {
          if (isSelected) {
            selectedSeats.remove(seatNumber);
          } else {
            selectedSeats.add(seatNumber);
          }
        });
      } : null,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColor.royalBlue 
              : (isAvailable ? Colors.white : Colors.grey),
          border: Border.all(
            color: isSelected ? AppColor.royalBlue : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            seatNumber,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
          _buildLegendItem(AppColor.royalBlue, TranslationConstants.selected.t(context)),
          const SizedBox(width: 16),
          _buildLegendItem(Colors.grey, TranslationConstants.occupied.t(context)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}