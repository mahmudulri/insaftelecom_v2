import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../controllers/wallets_controller.dart';
import '../utils/api_endpoints.dart';

class TransferBetweenWalletController extends GetxController {
  final box = GetStorage();

  final RxBool isLoading = false.obs;
  final RxInt selectedToWalletId = 0.obs;
  final RxString responseMessage = "".obs;

  void setToWalletId(int walletId) {
    selectedToWalletId.value = walletId;
  }

  Future<bool> transferBetweenWallet({
    required int fromWalletId,
    required int toWalletId,
    required String amount,
  }) async {
    try {
      isLoading.value = true;
      responseMessage.value = "";

      final url = Uri.parse("${ApiEndPoints.baseUrl}wallets/transfer-between");
      print(url);

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${box.read("userToken")}',
          'Accept': 'application/json',
        },
        body: {
          "from_wallet_id": fromWalletId.toString(),
          "to_wallet_id": toWalletId.toString(),
          "amount": amount,
        },
      );

      print("Exchange Status: ${response.statusCode}");
      print("Exchange Body: ${response.body}");

      final data = json.decode(response.body);

      responseMessage.value =
          data["message"]?.toString() ?? "Something went wrong";

      if (response.statusCode == 200 || response.statusCode == 201) {
        final bool success =
            data["success"] == true || data["status"] == "success";

        if (success) {
          final WalletsController walletsController =
              Get.find<WalletsController>();

          walletsController.selectWallet(fromWalletId);

          return true;
        }

        return false;
      }

      return false;
    } catch (e) {
      print("Exchange Error: $e");
      responseMessage.value = "Something went wrong";
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
