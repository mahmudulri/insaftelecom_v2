import 'package:insaftelecom/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:insaftelecom/controllers/bundle_controller.dart';
import 'package:insaftelecom/controllers/service_controller.dart';
import 'package:insaftelecom/utils/colors.dart';

import '../global_controller/font_controller.dart';

class PasteRestrictionFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final bool containsOnlyEnglishDigits = RegExp(
      r'^[0-9]+$',
    ).hasMatch(newValue.text);

    if (!containsOnlyEnglishDigits) {
      Get.snackbar(
        "Error",
        "Only English number format is allowed",
        colorText: Colors.white,
        duration: const Duration(milliseconds: 1000),
        backgroundColor: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );

      return oldValue;
    }

    return newValue;
  }
}

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.confirmPinController,
    required this.languageData,
  });

  final TextEditingController confirmPinController;
  final String languageData;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final GetStorage box = GetStorage();

  final FocusNode _numberFocusNode = FocusNode();

  String? errorMessage;

  int get maximumLength {
    return int.tryParse(box.read("maxlength")?.toString() ?? "") ?? 20;
  }

  void validateInput(String input) {
    if (!mounted) return;

    final String cleanInput = input.trim();

    if (cleanInput.isEmpty) {
      setState(() {
        errorMessage = null;
      });

      box.write("permission", "no");
      return;
    }

    if (cleanInput.length == maximumLength) {
      setState(() {
        errorMessage = null;
      });

      box.write("permission", "yes");
      return;
    }

    setState(() {
      errorMessage = null;
    });

    box.write("permission", "no");
  }

  @override
  void dispose() {
    _numberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 50,
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 1,
              color: AppColors.primaryColor.withOpacity(0.20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: widget.confirmPinController,
              focusNode: _numberFocusNode,
              autofocus: false,
              maxLength: maximumLength,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              style: TextStyle(color: Colors.grey.shade600),
              inputFormatters: [
                PasteRestrictionFormatter(),
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(maximumLength),
              ],
              decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                hintText: widget.languageData,
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontFamily: box.read("language")?.toString() == "Fa"
                      ? Get.find<FontController>().currentFont
                      : null,
                  fontSize: 14,
                ),
              ),
              onChanged: validateInput,
              onSubmitted: (_) {
                _numberFocusNode.unfocus();
              },
            ),
          ),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 5),
          KText(text: errorMessage!, color: Colors.red, fontSize: 12),
        ],
      ],
    );
  }
}
