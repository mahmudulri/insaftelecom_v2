import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_endpoints.dart';
import 'office_list_controller.dart';

class UpdateOfficeController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController defaultnameController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  OfficeListController officeListController = Get.put(OfficeListController());

  RxBool isLoading = false.obs;
  final box = GetStorage();

  RxString isActive = "0".obs;

  Future<void> updatenow(officeID) async {
    try {
      isLoading.value = true;

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read("userToken")}',
      };
      var url = Uri.parse("${ApiEndPoints.baseUrl}offices/$officeID");

      Map body = {
        'name': nameController.text,
        'code': idController.text,
        'location': locationController.text,
        'address': addressController.text,
        'phone': phoneController.text,
        "is_active": isActive.value.toString(),
        'notes': notesController.text,
        'default_account_name': defaultnameController.text,
        'accounting_currency_code': currencyController.text,
        'account_type': "cash",
        // 'opening_balance': amountController.text,
      };
      http.Response response = await http.put(
        url,
        body: jsonEncode(body),
        headers: headers,
      );

      print("body" + response.body.toString());
      print("statuscode" + response.statusCode.toString());
      final results = jsonDecode(response.body);
      if (response.statusCode == 200) {
        officeListController.finalList.clear();
        officeListController.initialpage = 1;
        officeListController.fetchofficelist();
        if (results["success"] == true) {
          Fluttertoast.showToast(
            msg: results["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          nameController.clear();
          idController.clear();
          locationController.clear();
          addressController.clear();
          phoneController.clear();
          isActive.value = "0";
          notesController.clear();
          defaultnameController.clear();
          currencyController.clear();
          amountController.clear();

          isLoading.value = false;
        } else {
          Get.snackbar(
            "Opps !",
            results["message"],
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          isLoading.value = false;
        }
      } else {
        Get.snackbar(
          "Opps !",
          results["message"],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
