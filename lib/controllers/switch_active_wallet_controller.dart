import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../controllers/wallets_controller.dart';
import '../utils/api_endpoints.dart';

class SwitchActiveWalletController extends GetxController {
  final box = GetStorage();

  final RxBool isLoading = false.obs;
  final RxInt selectedSwitchWalletId = 0.obs;

  String responseMessage = "";

  void setWalletId(int walletId) {
    selectedSwitchWalletId.value = walletId;
  }

  Future<bool> switchActiveWallet({required int walletId}) async {
    try {
      isLoading.value = true;
      responseMessage = "";

      final url = Uri.parse("${ApiEndPoints.baseUrl}wallets/switch");
      print(url);

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${box.read("userToken")}',
          'Accept': 'application/json',
        },
        body: {"wallet_id": walletId.toString()},
      );

      print("Switch Wallet Status: ${response.statusCode}");
      print("Switch Wallet Body: ${response.body}");

      final data = json.decode(response.body);

      responseMessage = data["message"]?.toString() ?? "Something went wrong";

      if (response.statusCode == 200 || response.statusCode == 201) {
        final bool success =
            data["success"] == true || data["status"] == "success";

        if (success) {
          final int activeWalletId =
              data["data"]?["active_wallet"]?["wallet_id"] ?? walletId;

          final WalletsController walletsController =
              Get.find<WalletsController>();

          walletsController.selectWallet(activeWalletId);

          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print("Switch Wallet Error: $e");
      responseMessage = "Something went wrong";
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
