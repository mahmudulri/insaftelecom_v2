import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:insaftelecom/global_controller/time_zone_controller.dart';

import '../global_controller/font_controller.dart';

String convertToDate(String utcTimeString) {
  try {
    DateTime utcTime = DateTime.parse(utcTimeString);

    Duration offset = DateTime.now().timeZoneOffset;

    DateTime localTime = utcTime.add(offset);

    return DateFormat('yyyy-MM-dd', 'en_US').format(localTime);
  } catch (e) {
    return "";
  }
}

String convertToLocalTime(String utcTimeString) {
  try {
    DateTime utcTime = DateTime.parse(utcTimeString);

    Duration offset = DateTime.now().timeZoneOffset;

    DateTime localTime = utcTime.add(offset);

    return DateFormat('hh:mm:ss a', 'en_US').format(localTime);
  } catch (e) {
    return "";
  }
}
