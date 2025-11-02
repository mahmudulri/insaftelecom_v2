import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PriceTextView extends StatelessWidget {
  final String? price;
  final TextStyle? textStyle; // Accepting text style as a parameter

  const PriceTextView({super.key, this.price, this.textStyle});

  @override
  Widget build(BuildContext context) {
    double priceDouble = double.tryParse(price ?? '0') ?? 0;
    String formattedPrice = priceDouble.toStringAsFixed(2);

    return Text(
      NumberFormat.currency(
        locale: 'en_US',
        symbol: '',
        decimalDigits: 2,
      ).format(double.parse(formattedPrice)),
      style: textStyle, // Using the provided text style
    );
  }
}
