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
    // Check if new value comes from pasting
    if (newValue.text.length > oldValue.text.length) {
      // Try parsing the new value to an integer
      if (int.tryParse(newValue.text) == null) {
        // If it's not an integer, return the old value (block paste)
        Get.snackbar(
          "Error",
          "Only allow english number format",
          colorText: Colors.white,
          duration: Duration(milliseconds: 1000),
          backgroundColor: Colors.black,
        );
        return oldValue;
      }
    }

    return newValue;
  }
}

class CustomTextField extends StatefulWidget {
  final TextEditingController confirmPinController;

  final String languageData;

  CustomTextField({
    required this.confirmPinController,
    required this.languageData,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final box = GetStorage();

  final serviceController = Get.find<ServiceController>();
  final bundleController = Get.find<BundleController>();

  String? errorMessage;

  void validateInput(String input) {
    // If input is empty, clear the company_id, reset permission, and fetch all bundles
    if (input.isEmpty) {
      setState(() {
        box.write("company_id", "");
        box.write("permission", "no");
        errorMessage = null;
      });
      bundleController.finalList.clear();
      bundleController.initialpage = 1;
      bundleController.fetchallbundles();
      print("Input is empty. Cleared company_id and fetched all bundles.");
      return; // Exit the method early
    }

    // Continue with validation if input is not empty
    bool isValid = serviceController.reserveDigit.any(
      (digit) => input.startsWith(digit),
    );

    if (!isValid) {
      setState(() {
        errorMessage =
            "Please enter a correct ${box.read("maxlength")} digit Number";
        box.write("permission", "no");
      });
    } else {
      setState(() {
        box.write("permission", "yes");
        errorMessage = null; // Clear error when valid
      });
    }

    // Only proceed when the input length is 3, 4, or 10
    if (input.length == 3 || input.length == 4 || input.length == 10) {
      final services = serviceController.allserviceslist.value.data!.services;
      bool matchFound = false;

      for (var service in services) {
        for (var code in service.company!.companycodes!) {
          print("Checking reservedDigit: ${code.reservedDigit}");

          // Check if the input starts with the reservedDigit
          if (input.startsWith(code.reservedDigit.toString())) {
            // Set the matched company_id
            box.write("company_id", service.companyId);
            bundleController.initialpage = 1;

            // Clear and fetch bundles
            bundleController.finalList.clear();
            serviceController.fetchservices();
            bundleController.fetchallbundles();

            print(
              "Matched company_id: ${service.companyId} with input: $input",
            );
            matchFound = true;
            break;
          }
        }
        if (matchFound) break;
      }

      // If no match is found, clear the list and fetch all bundles
      if (!matchFound) {
        bundleController.finalList.clear();
        bundleController.initialpage = 1;
        bundleController.fetchallbundles();

        print(
          "No match found for input: $input. Cleared the finalList and fetched all bundles.",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
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
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              maxLength: int.parse(box.read("maxlength").toString()),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontFamily: box.read("language").toString() == "Fa"
                    ? Get.find<FontController>().currentFont
                    : null,
              ),
              controller: widget.confirmPinController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                PasteRestrictionFormatter(), // Custom formatter to restrict paste
                FilteringTextInputFormatter.digitsOnly, // Allow digits only
              ],
              decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none,
                hintText: widget.languageData,
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontFamily: box.read("language").toString() == "Fa"
                      ? Get.find<FontController>().currentFont
                      : null,
                  fontSize: 14,
                ),
              ),
              onChanged: (value) {
                validateInput(value);
              },
            ),
          ),
        ),
        if (errorMessage != null)
          KText(text: errorMessage!, color: Colors.white, fontSize: 12),
      ],
    );
  }
}
