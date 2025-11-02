import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:insaftelecom/global_controller/time_zone_controller.dart';

import '../global_controller/font_controller.dart';

final TimeZoneController timeZoneController = Get.put(TimeZoneController());
final box = GetStorage();
Text convertToDate(
  String utcTimeString, {
  TextStyle? style, // optional TextStyle parameter
}) {
  String localTimeString;
  try {
    // Parse the UTC time
    DateTime utcTime = DateTime.parse(utcTimeString);

    // Calculate the offset duration
    Duration offset = Duration(
      hours: int.parse(timeZoneController.hour),
      minutes: int.parse(timeZoneController.minute),
    );

    // Apply the offset
    DateTime localTime = timeZoneController.sign == "+"
        ? utcTime.add(offset)
        : utcTime.subtract(offset);

    localTimeString = DateFormat('yyyy-MM-dd', 'en_US').format(localTime);
  } catch (e) {
    localTimeString = '';
  }

  // Default style if none provided
  TextStyle defaultStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: box.read("language").toString() == "Fa"
        ? Get.find<FontController>().currentFont
        : null,
  );

  return Text(localTimeString, style: style ?? defaultStyle);
}

Text convertToLocalTime(
  String utcTimeString, {
  TextStyle? style, // optional TextStyle parameter
}) {
  String localTimeString;
  try {
    // Parse the UTC time
    DateTime utcTime = DateTime.parse(utcTimeString);

    // Calculate the offset duration
    Duration offset = Duration(
      hours: int.parse(timeZoneController.hour),
      minutes: int.parse(timeZoneController.minute),
    );

    // Apply the offset
    DateTime localTime = timeZoneController.sign == "+"
        ? utcTime.add(offset)
        : utcTime.subtract(offset);

    localTimeString = DateFormat('hh:mm a', 'en_US').format(localTime);
  } catch (e) {
    localTimeString = '';
  }

  // Provide default style if none is passed
  TextStyle defaultStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: box.read("language").toString() == "Fa"
        ? Get.find<FontController>().currentFont
        : null,
  );

  return Text(
    localTimeString,
    style: style ?? defaultStyle, // use passed style or default
  );
}
