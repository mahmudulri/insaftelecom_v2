import 'package:get/get.dart';
import '../models/wallets_model.dart';
import '../services/wallet_service.dart';

class WalletsController extends GetxController {
  var isLoading = false.obs;
  var allwallets = WalletsModel().obs;

  var selectedWalletId = RxnInt();

  List<Wallet> get wallets => allwallets.value.data?.wallets ?? [];

  Wallet? get selectedWallet {
    if (wallets.isEmpty) return null;

    return wallets.firstWhereOrNull(
      (w) => w.walletId == selectedWalletId.value,
    );
  }

  void fetchwalletsData() async {
    try {
      isLoading(true);

      final value = await WalletService().fetchwalletes();
      allwallets.value = value;

      final activeId = value.data?.activeWallet?.walletId;

      if (activeId != null) {
        selectedWalletId.value = activeId;
      } else if ((value.data?.wallets ?? []).isNotEmpty) {
        selectedWalletId.value = value.data!.wallets!.first.walletId;
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading(false);
    }
  }

  void selectWallet(int? walletId) {
    selectedWalletId.value = walletId;
  }
}
