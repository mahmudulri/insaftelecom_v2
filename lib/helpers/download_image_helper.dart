// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';

// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:insaftelecom/global_controller/languages_controller.dart';

// final LanguagesController languageController = Get.put(LanguagesController());

// Future<void> downloadImage(String imageUrl) async {
//   try {
//     // Check for permissions based on Android version
//     if (await _requestStoragePermission()) {
//       // Fetch image from URL
//       var response = await http.get(Uri.parse(imageUrl.toString()));
//       if (response.statusCode == 200) {
//         // Convert the response body to Uint8List
//         Uint8List bytes = response.bodyBytes;

//         // Save the image directly to the gallery
//         final result = await ImageGallerySaver.saveImage(
//           bytes,
//           quality: 100,
//           name: "downloaded_image",
//         );
//         print(result);

//         // Show success message
//         Get.snackbar(
//           languageController.tr("SUCCESS"),
//           languageController.tr("IMAGE_SAVED_TO_GALLERY"),
//         );
//       } else {
//         Get.snackbar("Error", "Failed to download image: Server error");

//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   SnackBar(content: Text('Failed to download image: Server error')),
//         // );
//       }
//     } else {
//       Get.snackbar("Denied", "Permission denied!");
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   SnackBar(content: Text('Permission denied!')),
//       // );
//     }
//   } catch (e) {
//     Get.snackbar("Failed", "Failed to download image");

//     // ScaffoldMessenger.of(context).showSnackBar(
//     //   SnackBar(content: Text('Failed to download image: $e')),
//     // );
//   }
// }

// Future<bool> _requestStoragePermission() async {
//   PermissionStatus status;

//   if (await Permission.storage.isGranted) {
//     return true;
//   }

//   // For Android 13+ check both storage and photos permissions
//   if (await Permission.photos.isGranted) {
//     return true;
//   }

//   // Request permissions and handle the status
//   if (await Permission.storage.request().isGranted ||
//       await Permission.photos.request().isGranted) {
//     return true;
//   }

//   return false; // Return false if permission is denied
// }
