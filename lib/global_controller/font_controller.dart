// controllers/font_controller.dart
import 'package:get/get.dart';

class FontController extends GetxController {
  // Default font name (set to null to fallback to system default)
  final RxString? fontFamily = 'Iranfontregular'.obs;

  void setFont(String? font) {
    fontFamily!.value = font!;
  }

  String? get currentFont => fontFamily!.value;
}
