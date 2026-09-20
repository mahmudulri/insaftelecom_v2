import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class Accountextfield extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int? maxLines;
  final TextInputAction? textInputAction;

  final double height; // container height
  final double borderRadius; // custom radius
  final TextInputType keyboardType;

  Accountextfield({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.textInputAction,

    this.height = 55,
    this.borderRadius = 12,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        ),
      ),
    );
  }
}
