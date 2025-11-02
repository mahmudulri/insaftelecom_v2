import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:insaftelecom/utils/api_endpoints.dart';
import '../global_controller/page_controller.dart';
import '../pages/network.dart';
import 'sub_reseller_controller.dart';

final subresellercontroller = Get.find<SubresellerController>();

class SetCommissionGroupController extends GetxController {
  final box = GetStorage();

  RxBool isLoading = false.obs;

  Future<void> setgroup(subID, groupID) async {
    try {
      isLoading.value = true;

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read("userToken")}',
      };
      var url = Uri.parse(
        "${ApiEndPoints.baseUrl}sub-resellers/set-sub-reseller-comission-group-id?sub_reseller_id=${subID}&sub_reseller_commission_group_id=${groupID}",
      );
      print(url);

      http.Response response = await http.post(url, headers: headers);

      print("body${response.body}");
      print("statuscode${response.statusCode}");

      final results = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (results["success"] == true) {
          isLoading.value = false;

          Fluttertoast.showToast(
            msg: "Status successfully changed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          subresellercontroller.fetchSubReseller();
          // Future.delayed(Duration(seconds: 1), () {
          //   final Mypagecontroller mypagecontroller = Get.find();
          //   mypagecontroller.changePage(Network(), isMainPage: false);
          // });
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
