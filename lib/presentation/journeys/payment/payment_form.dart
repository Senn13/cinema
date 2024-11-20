import 'package:flutter/material.dart';
import 'package:cinema/common/constants/translation_constants.dart';
import 'package:cinema/common/extensions/string_extensions.dart';
import 'package:flutter/services.dart';

class PaymentForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController cardNumberController;
  final TextEditingController cardHolderController;
  final TextEditingController expiryDateController;
  final TextEditingController cvvController;

  const PaymentForm({
    Key? key,
    required this.formKey,
    required this.cardNumberController,
    required this.cardHolderController,
    required this.expiryDateController,
    required this.cvvController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TranslationConstants.paymentDetails.t(context),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cardNumberController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: TranslationConstants.cardNumber.t(context),
                  labelStyle: const TextStyle(color: Colors.grey),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return TranslationConstants.invalidCardNumber.t(context);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cardHolderController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: TranslationConstants.cardHolderName.t(context),
                  labelStyle: const TextStyle(color: Colors.grey),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return TranslationConstants.invalidCardHolderName.t(context);
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: expiryDateController,
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        _ExpiryDateInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        labelText: TranslationConstants.expiryDate.t(context),
                        labelStyle: const TextStyle(color: Colors.grey),
                        hintText: 'MM/YY',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return TranslationConstants.invalidExpiryDate.t(context);
                        }
                        if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value!)) {
                          return TranslationConstants.invalidExpiryDate.t(context);
                        }
                        int month = int.parse(value.split('/')[0]);
                        if (month < 1 || month > 12) {
                          return TranslationConstants.invalidExpiryDate.t(context);
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: cvvController,
                      style: const TextStyle(color: Colors.black),
                      obscureText: true,
                      obscuringCharacter: '*',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: InputDecoration(
                        labelText: TranslationConstants.cvv.t(context),
                        labelStyle: const TextStyle(color: Colors.grey),
                        hintText: '***',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return TranslationConstants.invalidCvv.t(context);
                        }
                        if (value!.length != 3) {
                          return TranslationConstants.invalidCvv.t(context);
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    
    // Nếu đang xóa, cho phép xóa bình thường
    if (newText.length < oldValue.text.length) {
      return newValue;
    }

    // Nếu độ dài là 2, thêm dấu "/"
    if (newText.length == 2) {
      return TextEditingValue(
        text: '$newText/',
        selection: TextSelection.collapsed(offset: newText.length + 1),
      );
    }

    // Nếu độ dài > 2 và chưa có dấu "/", thêm vào
    if (newText.length > 2 && !newText.contains('/')) {
      final formatted = '${newText.substring(0, 2)}/${newText.substring(2)}';
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    // Giới hạn tổng độ dài là 5 (MM/YY)
    if (newText.length > 5) {
      return oldValue;
    }

    return newValue;
  }
}