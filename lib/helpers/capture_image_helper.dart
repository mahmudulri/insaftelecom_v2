import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../global_controller/languages_controller.dart';

/// Use this GlobalKey in your widget to wrap the part you want to capture.
GlobalKey catpureKey = GlobalKey();

LanguagesController languageController = Get.put(LanguagesController());

/// Capture the widget and save as image in Android Gallery.
Future<void> capturePng() async {
  try {
    // ✅ Handle Android 13+ (API 33+) new permissions
    bool hasPermission = await _handlePermission();

    if (!hasPermission) {
      Get.snackbar(
        languageController.tr("PERMISSION_DENIED"),
        languageController.tr("STORAGE_PERMISSION_IS_REQUIRED"),
      );
      return;
    }

    // ✅ Find RenderBoundary
    RenderRepaintBoundary? boundary =
        catpureKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) {
      print("❌ No boundary found.");
      return;
    }

    // ✅ Capture image
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      print("❌ Failed to convert image to bytes.");
      return;
    }

    Uint8List pngBytes = byteData.buffer.asUint8List();

    // ✅ Save image to gallery
    final result = await ImageGallerySaverPlus.saveImage(
      pngBytes,
      quality: 100,
      name: "screenshot_${DateTime.now().millisecondsSinceEpoch}",
    );

    if (result['isSuccess'] == true) {
      Get.snackbar(
        languageController.tr("SUCCESS"),
        languageController.tr("IMAGE_SAVED_TO_GALLERY"),
      );
    } else {
      Get.snackbar("FAILED", "Could not save image.");
    }
  } catch (e) {
    print("⚠️ Error while capturing: $e");

    Get.snackbar(
      languageController.tr("ERROR"),
      languageController.tr("FAILED_TO_CAPTURE_IMAGE"),
    );
  }
}

/// Internal permission handler (for Android 13+ safe)
Future<bool> _handlePermission() async {
  // Old Android versions (below 13)
  if (await Permission.storage.isGranted) return true;

  // Android 13+ granular permission
  if (await Permission.photos.request().isGranted) return true;

  // Fallback
  final status = await Permission.storage.request();
  return status.isGranted;
}
