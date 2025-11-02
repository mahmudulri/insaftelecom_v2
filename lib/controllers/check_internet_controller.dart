import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  RxBool hasinternet = true.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((connectivityResults) {
      _updateConnectionStatus(connectivityResults);
    });
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResults) {
    if (connectivityResults.contains(ConnectivityResult.none)) {
      hasinternet.value = false;

      // Show the alert dialog if internet is disconnected
      Get.dialog(
        AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please connect to the internet.'),
          // actions: [
          //   ElevatedButton(
          //     onPressed: () {
          //       Get.back(); // Close the dialog manually
          //     },
          //     child: const Text('OK'),
          //   ),
          // ],
        ),
        barrierDismissible:
            false, // Prevent dismissing the dialog by tapping outside
      );
    } else {
      hasinternet.value = true;
      if (Get.isDialogOpen!) {
        Get.back(); // Close the dialog when internet is restored
      }
    }
  }
}
