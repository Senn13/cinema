class PaymentDetailsModel {
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String cardHolderName;

  PaymentDetailsModel({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.cardHolderName,
  });

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'cardHolderName': cardHolderName,
    };
  }
}