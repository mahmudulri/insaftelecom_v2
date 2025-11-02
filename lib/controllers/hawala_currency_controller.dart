import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/hawala_currency_model.dart' as hawala;
import '../models/hawala_currency_model.dart';
import '../services/hawala_currency_service.dart';

final box = GetStorage();

class HawalaCurrencyController extends GetxController {
  var isLoading = false.obs;

  var allcurrencylist = HawalaCurrencyModel().obs;
  var hawalafilteredcurrency = HawalaCurrencyModel().obs;
  List<Map<String, dynamic>> pairList = [];

  String code = box.read("currency_code");

  void fetchcurrency() async {
    try {
      isLoading(true);
      await HawalaCurrencyApi().fetchcurrency().then((value) {
        allcurrencylist.value = value;

        // ✅ Filter: শুধু from_currency.code মিলে এমনগুলো
        List<Rate> filteredRates = value.data?.rates
                ?.where((rate) => rate.fromCurrency?.code == code)
                .toList() ??
            [];

        hawalafilteredcurrency.value = HawalaCurrencyModel(
          success: value.success,
          code: value.code,
          message: value.message,
          data: hawala.Data(rates: filteredRates),
          payload: value.payload,
        );

        print(hawalafilteredcurrency.toJson());

        isLoading(false);
      });

      isLoading(false);
    } catch (e) {
      print(e.toString());
    }
  }
}
