import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'office_list_controller.dart';
import '../../utils/api_endpoints.dart';

class CreateOfficeController extends GetxController {
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

  RxBool isactive = false.obs;

  Future<void> createnow() async {
    try {
      isLoading.value = true;

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read("userToken")}',
      };
      var url = Uri.parse("${ApiEndPoints.baseUrl}accounting/offices");

      Map body = {
        'name': nameController.text,
        'code': idController.text,
        'location': locationController.text,
        'address': addressController.text,
        'phone': phoneController.text,
        "is_active": isactive.value,
        'notes': notesController.text,
        'create_default_account': true,
        'default_account_name': defaultnameController.text,
        'accounting_currency_code': currencyController.text,
        'account_type': "cash",
        'opening_balance': amountController.text,
      };
      print(body);
      http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );

      print("body" + response.body.toString());
      print("statuscode" + response.statusCode.toString());
      final results = jsonDecode(response.body);
      if (response.statusCode == 201) {
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
          isactive.value = false;
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
