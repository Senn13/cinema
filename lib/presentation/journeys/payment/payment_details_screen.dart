import 'package:cinema/presentation/blocs/booking/booking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:cinema/data/models/payment_details_model.dart';
import 'package:cinema/data/models/ticket_model.dart';
import 'package:cinema/presentation/journeys/tickets/ticket_confirmation_screen.dart';
import 'package:cinema/common/constants/translation_constants.dart';
import 'package:cinema/common/extensions/string_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinema/presentation/journeys/payment/payment_form.dart';

class PaymentDetailsScreen extends StatefulWidget {
  final int bookingId;

  const PaymentDetailsScreen({
    Key? key,
    required this.bookingId,
  }) : super(key: key);

  @override
  _PaymentDetailsScreenState createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is PaymentProcessing) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is PaymentCompleted) {
          Navigator.of(context).pop(); // Hide loading
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (routeContext) => BlocProvider.value(
                value: BlocProvider.of<BookingBloc>(context),
                child: TicketConfirmationScreen(
                  ticket: state.ticket,
                ),
              ),
            ),
          );
        } else if (state is BookingError) {
          Navigator.of(context).pop(); // Hide loading if shown
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            TranslationConstants.paymentDetails.t(context),
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PaymentForm(
                formKey: _formKey,
                cardNumberController: _cardNumberController,
                cardHolderController: _cardHolderController,
                expiryDateController: _expiryDateController,
                cvvController: _cvvController,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _processCreditCardPayment,
                child: Text(TranslationConstants.pay.t(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processCreditCardPayment() {
    if (_formKey.currentState?.validate() ?? false) {
      final bookingBloc = context.read<BookingBloc>();
      final booking = bookingBloc.state;
      if (booking is BookingLoaded) {
        final paymentDetails = PaymentDetailsModel(
          cardNumber: _cardNumberController.text,
          expiryDate: _expiryDateController.text,
          cvv: _cvvController.text,
          cardHolderName: _cardHolderController.text,
        );

        bookingBloc.add(
          ProcessPaymentEvent(
            bookingId: widget.bookingId,
            showtimeId: booking.showtime.id,
            userId: booking.userId,
            selectedSeats: booking.selectedSeats,
            totalAmount: booking.totalAmount,
            cardNumber: paymentDetails.cardNumber,
            expiryDate: paymentDetails.expiryDate,
            cvv: paymentDetails.cvv,
            cardHolderName: paymentDetails.cardHolderName,
            movieTitle: booking.showtime.movieTitle,
            showtime: booking.showtime.toString(),
            movieId: booking.showtime.movieId,
          ),
        );
      }
    }
  }
}