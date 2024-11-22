import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinema/common/constants/translation_constants.dart';
import 'package:cinema/common/extensions/string_extensions.dart';
import 'package:cinema/data/models/booking_model.dart';
import 'package:cinema/di/get_it.dart';
import 'package:cinema/domain/entities/movie_entity.dart';
import 'package:cinema/presentation/blocs/booking/booking_bloc.dart';
import 'package:cinema/presentation/journeys/tickets/ticket_confirmation_screen.dart';
import 'package:cinema/presentation/theme/theme_color.dart';
import 'package:cinema/presentation/journeys/payment/payment_form.dart';
import 'package:cinema/data/data_sources/seat_booking_local_data_source.dart';

class PaymentScreen extends StatefulWidget {
  final List<String> selectedSeats;
  final int showtimeId;
  final String showtime;
  final double price;
  final MovieEntity movie;
  final int bookingId;
  final double totalAmount;

  const PaymentScreen({
    Key? key,
    required this.selectedSeats,
    required this.showtimeId,
    required this.showtime,
    required this.price,
    required this.movie,
    required this.bookingId,
    required this.totalAmount,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _cardNumberController;
  late final TextEditingController _cardHolderController;
  late final TextEditingController _expiryDateController;
  late final TextEditingController _cvvController;

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController();
    _cardHolderController = TextEditingController();
    _expiryDateController = TextEditingController();
    _cvvController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TranslationConstants.payment.t(context)),
      ),
      body: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is PaymentProcessing) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is PaymentCompleted) {
            final seatBookingLocalDataSource = getItInstance<SeatBookingLocalDataSource>();
            print('Saving seats for showtime: ${widget.showtimeId}');
            seatBookingLocalDataSource.saveBookedSeats(
              widget.selectedSeats,
              widget.showtimeId,
              widget.showtime,
              widget.movie.id,
            ).then((_) {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketConfirmationScreen(
                    ticket: state.ticket,
                  ),
                ),
              );
            });
          } else if (state is BookingError) {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop(); // Đóng loading dialog nếu đang hiển thị
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                PaymentForm(
                  formKey: _formKey,
                  cardNumberController: _cardNumberController,
                  cardHolderController: _cardHolderController,
                  expiryDateController: _expiryDateController,
                  cvvController: _cvvController,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.royalBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _processPayment,
                    child: Text(
                      TranslationConstants.pay.t(context),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _processPayment() {
    if (_formKey.currentState?.validate() ?? false) {
      final booking = BookingModel(
        showtime: widget.showtime,
        id: widget.bookingId,
        showtimeId: widget.showtimeId,
        userId: 1,
        selectedSeats: widget.selectedSeats,
        bookingStatus: 'pending',
        bookingTime: DateTime.now(),
        totalAmount: widget.totalAmount,
      );

      final bookingBloc = BlocProvider.of<BookingBloc>(context);
      bookingBloc.add(
        ProcessPaymentEvent(
          movieId: widget.movie.id,
          bookingId: widget.bookingId,
          showtimeId: widget.showtimeId,
          userId: 1,
          movieTitle: widget.movie.title,
          showtime: widget.showtime,
          selectedSeats: widget.selectedSeats,
          totalAmount: widget.totalAmount,
          cardNumber: _cardNumberController.text,
          expiryDate: _expiryDateController.text,
          cvv: _cvvController.text,
          cardHolderName: _cardHolderController.text,
        ),
      );
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }
}