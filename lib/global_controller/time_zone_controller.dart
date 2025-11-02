import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:timezone_utc_offset/timezone_utc_offset.dart';

class TimeZoneController extends GetxController {
  final box = GetStorage();

  String? myzone;
  String sign = '';
  String hour = '';
  String minute = '';
  String result = '';

  @override
  void onInit() {
    super.onInit();
    setTimezoneOffset();
  }

  void setTimezoneOffset() {
    result = getTimezoneUTCOffset(myzone.toString()).toString();
    extractTimeDetails();
  }

  void extractTimeDetails() {
    if (result.startsWith('-')) {
      sign = '-';
      result = result.substring(1); // Remove the '-' for further processing
    } else {
      sign = '+';
    }

    // Split the time to extract hour and minute
    List<String> timeParts = result.split(':');
    if (timeParts.length >= 2) {
      hour = timeParts[0]; // Get the hour
      minute = timeParts[1]; // Get the minute
    }
  }
}
