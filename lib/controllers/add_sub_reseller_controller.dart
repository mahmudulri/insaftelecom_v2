import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global_controller/languages_controller.dart';
import '../utils/api_endpoints.dart';
import 'sub_reseller_controller.dart';

final SubresellerController subresellerController =
    Get.put(SubresellerController());

class AddSubResellerController extends GetxController {
  // ---------- Images ----------
  // existing (profile)
  var selectedImagePath = ''.obs;
  File? imageFile;

  // NEW optional attachments
  var selectedIdentityPath = ''.obs; // reseller_identity_attachment
  var selectedExtraProofPath = ''.obs; // extra_optional_proof

  // ---------- IDs / dropdown ----------
  var groupId = ''.obs;
  var countryId = ''.obs;
  var provinceId = ''.obs;
  var districtID = ''.obs;
  var currencyID = ''.obs;

  // ---------- Text inputs ----------
  TextEditingController resellerNameController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final box = GetStorage();
  RxBool isLoading = false.obs;

  // ---------- Image Pickers ----------
  // keep your original uploadImage() for profile
  Future<void> uploadImage() async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImageFile != null) {
      selectedImagePath.value = pickedImageFile.path;
      imageFile = File(pickedImageFile.path);
      print("before image tag   $imageFile");
    } else {
      print("No image selected");
    }
  }

  // new optional pickers
  Future<void> uploadIdentityAttachment() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedIdentityPath.value = picked.path;
      print("identity selected: ${selectedIdentityPath.value}");
    } else {
      print("No identity image selected");
    }
  }

  Future<void> uploadExtraOptionalProof() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedExtraProofPath.value = picked.path;
      print("extra proof selected: ${selectedExtraProofPath.value}");
    } else {
      print("No extra proof image selected");
    }
  }

  // ---------- Submit ----------
  Future<void> addNow() async {
    try {
      isLoading.value = true;

      final headers = {
        'Authorization': 'Bearer ${box.read("userToken")}',
      };

      final Map<String, String> fields = {
        'reseller_name': resellerNameController.text.trim(),
        'contact_name': contactNameController.text.trim(),
        'email': emailController.text.trim().isNotEmpty
            ? emailController.text.trim()
            : '${phoneController.text.trim()}@gmail.com',
        'phone': phoneController.text.trim(),
        'sub_reseller_comission_group_id': groupId.value,
        'country_id': countryId.value,
        'province_id': provinceId.value,
        'districts_id': districtID.value,
        'currency_preference_id': box.read("currencypreferenceID").toString(),
      };

      final url = Uri.parse("${ApiEndPoints.baseUrl}sub-resellers");
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);

      // add fields
      request.fields.addAll(fields);

      // attach files if present
      if (selectedImagePath.value.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_image_url',
          selectedImagePath.value,
          filename: "profile.jpg",
        ));
      }

      if (selectedIdentityPath.value.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'reseller_identity_attachment',
          selectedIdentityPath.value,
          filename: "identity.jpg",
        ));
      }

      if (selectedExtraProofPath.value.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'extra_optional_proof',
          selectedExtraProofPath.value,
          filename: "extra_proof.jpg",
        ));
      }

      // send
      final streamed = await request.send();
      final httpResponse = await http.Response.fromStream(streamed);

      print(streamed.statusCode.toString());
      print(httpResponse.body.toString());

      dynamic res;
      try {
        res = jsonDecode(httpResponse.body);
      } catch (_) {
        res = null;
      }

      if (streamed.statusCode == 201) {
        Fluttertoast.showToast(
          msg: "Successfully Created",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // refresh list
        subresellerController.fetchSubReseller();

        // clear inputs
        resellerNameController.clear();
        contactNameController.clear();
        emailController.clear();
        phoneController.clear();

        currencyID.value = '';
        countryId.value = '';
        provinceId.value = '';
        districtID.value = '';
        groupId.value = '';

        // clear images
        selectedImagePath.value = '';
        selectedIdentityPath.value = '';
        selectedExtraProofPath.value = '';
        imageFile = null;
      } else {
        final msg = (res is Map && res['message'] != null)
            ? res['message'].toString()
            : "Something error";
        Get.snackbar(
          "Wrong",
          msg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
