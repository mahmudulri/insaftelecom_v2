import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../controllers/wallets_controller.dart';
import '../utils/api_endpoints.dart';

class TransferToBalanceController extends GetxController {
  final box = GetStorage();

  final RxBool isLoading = false.obs;
  final RxString responseMessage = "".obs;

  Future<bool> transferToBalance({
    required int walletId,
    required String amount,
  }) async {
    try {
      isLoading.value = true;
      responseMessage.value = "";

      final url = Uri.parse(
        "${ApiEndPoints.baseUrl}wallets/transfer-to-balance",
      );
      print(url);

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${box.read("userToken")}',
          'Accept': 'application/json',
        },
        body: {"wallet_id": walletId.toString(), "amount": amount},
      );

      print("Transfer Status: ${response.statusCode}");
      print("Transfer Body: ${response.body}");

      final data = json.decode(response.body);

      responseMessage.value =
          data["message"]?.toString() ?? "Something went wrong";

      if (response.statusCode == 200 || response.statusCode == 201) {
        final bool success =
            data["success"] == true || data["status"] == "success";

        if (success) {
          final WalletsController walletsController =
              Get.find<WalletsController>();

          walletsController.selectWallet(walletId);

          return true;
        }

        return false;
      }

      return false;
    } catch (e) {
      print("Transfer Error: $e");
      responseMessage.value = "Something went wrong";
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
