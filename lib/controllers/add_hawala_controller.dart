import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/hawala_currency_model.dart';
import '../utils/api_endpoints.dart';
import 'commission_group_controller.dart';
import 'hawala_list_controller.dart';

class AddHawalaController extends GetxController {
  final box = GetStorage();

  final hawalalistController = Get.find<HawalaListController>();

  TextEditingController senderNameController = TextEditingController();
  TextEditingController receiverNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController idcardController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();

  RxString currency = ''.obs;
  RxString currency2 = ''.obs;
  RxString branch = ''.obs;
  RxString finalAmount = ''.obs;

  RxBool isLoading = false.obs;

  RxString currencyID = "".obs;
  RxString paidbysender = "".obs;
  RxString paidbyreceiver = "".obs;
  RxString branchId = "".obs;

  Rx<Rate?> selectedRate = Rx<Rate?>(null);

  Future<bool> createhawala() async {
    try {
      isLoading.value = true;

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read("userToken")}',
      };

      var url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.otherendpoints.hawalalist,
      );

      Map body = {
        'sender_name': senderNameController.text,
        'receiver_name': receiverNameController.text,
        'hawala_amount': amountController.text.toString(),
        'receiver_father_name': fatherNameController.text,
        'receiver_id_card_number': idcardController.text,
        'hawala_amount_currency_id': currencyID.toString(),
        'commission_paid_by_sender': paidbysender.toString(),
        'commission_paid_by_receiver': paidbyreceiver.toString(),
        'hawala_branch_id': branchId.toString(),
      };

      http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      final results = jsonDecode(response.body);

      if (response.statusCode == 201 && results["success"] == true) {
        // Clear fields
        senderNameController.clear();
        receiverNameController.clear();
        amountController.clear();
        fatherNameController.clear();
        idcardController.clear();
        currencyID.value = "";
        paidbysender.value = "";
        paidbyreceiver.value = "";
        branchId.value = "";
        currency.value = "";
        currency2.value = "";
        branch.value = "";
        finalAmount.value = "";

        hawalalistController.fetchhawala();

        Fluttertoast.showToast(
          msg: results["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        return true;
      } else {
        Get.snackbar(
          "Oops!",
          results["message"],
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print("Error during createhawala: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
