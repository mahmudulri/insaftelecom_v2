import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../global_controller/languages_controller.dart';

final languagesController = Get.find<LanguagesController>();

class SignUpController extends GetxController {
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

  void resetForm() {
    // Text controllers
    resellerNameController.clear();
    contactNameController.clear();
    emailController.clear();
    phoneController.clear();
    pinController.clear();
    confirmPinController.clear();
    passwordController.clear();
    confirmPassController.clear();

    // Dropdown / IDs
    groupId.value = '';
    countryId.value = '';
    provinceId.value = '';
    districtID.value = '';
    currencyId.value = '';

    // Images
    selectedImagePath.value = '';
    selectedIdentityPath.value = '';
    selectedExtraProofPath.value = '';
    imageFile = null;

    // Loading flag
    isLoading.value = false;
  }

  @override
  void onClose() {
    resellerNameController.dispose();
    contactNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    pinController.dispose();
    confirmPinController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    super.onClose();
  }

  // Returns null if OK, otherwise error message
  String? validateInputs() {
    // Required
    if (resellerNameController.text.trim().isEmpty) {
      return languagesController.tr("PLEASE_ENTER_FULL_NAME");
    }
    if (contactNameController.text.trim().isEmpty) {
      return languagesController.tr("PLEASE_ENTER_CONTACT_NAME");
    }
    if (phoneController.text.trim().isEmpty) {
      return languagesController.tr("PLEASE_ENTER_PHONE_NUMBER");
    }
    if (currencyId.value.isEmpty) {
      return languagesController.tr("PLEASE_SELECT_CURRENCY");
    }
    // Profile photo is now optional — removed this validation
    // if (selectedImagePath.value.isEmpty) {
    //   return languagesController.tr("PLEASE_SELECT_PROFILE_PHOTO");
    // }
    if (passwordController.text.trim().isEmpty) {
      return languagesController.tr("PLEASE_SELECT_PASSWORD");
    }
    if (confirmPassController.text.trim().isEmpty) {
      return languagesController.tr("PLEASE_CONFIRM_THE_PASSWORD");
    }
    if (passwordController.text.trim() != confirmPassController.text.trim()) {
      return languagesController.tr("PASSWORD_DO_NOT_MATCH");
    }

    // Optional email, validate if provided
    final email = emailController.text.trim();
    if (email.isNotEmpty) {
      final emailRe = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
      if (!emailRe.hasMatch(email)) {
        return languagesController.tr("PLEASE_ENTER_A_VALID_EMAIL");
      }
    }

    // Optional PIN pair
    final pin = pinController.text.trim();
    final cpin = confirmPinController.text.trim();
    if (pin.isNotEmpty || cpin.isNotEmpty) {
      if (pin.isEmpty || cpin.isEmpty) {
        return languagesController.tr("PLEASE_FILL_BOTH_PIN_AND_CONFIRM_PIN");
      }
      if (pin != cpin) {
        return languagesController.tr("PIN_AND_CONFIRM_PIN_DO_NOT_MATCH");
      }
    }

    return null;
  }

  // ---------- Submit ----------
  Future<void> registernow() async {
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
        'country_id': countryId.value,
        'province_id': provinceId.value,
        'districts_id': districtID.value,
        'currency_preference_id': currencyId.value,
        'account_password': passwordController.text.trim(),
        'personal_pin': pinController.text.trim(),
      };
      print(fields.toString());

      final url = Uri.parse(
        "https://app-api-vpro-as-afghanstore.milliekit.com/api/public/reseller-self-register",
      );
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll(headers);
      request.fields.addAll(fields);

      // Files (optional)
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

      final streamed = await request.send();
      final httpResponse = await http.Response.fromStream(streamed);

      print("------------------code---${streamed.statusCode}");
      print("------------------body---${httpResponse.body}");

      dynamic res;
      try {
        res = jsonDecode(httpResponse.body);
      } catch (_) {
        res = null;
      }

      if (streamed.statusCode == 201) {
        Fluttertoast.showToast(
          msg: res["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // Full reset after success
        resetForm();
      } else {
        final msg = (res is Map && res['message'] != null)
            ? res['message'].toString()
            : languagesController.tr("SOMETHING_ERROR");
        Get.snackbar(
          languagesController.tr("WRONG"),
          msg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        languagesController.tr("ERROR"),
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ---------- Images / Storage ----------
  final box = GetStorage();
  var selectedImagePath = ''.obs;
  File? imageFile;

  var selectedIdentityPath = ''.obs;
  var selectedExtraProofPath = ''.obs;

  var groupId = ''.obs;
  var countryId = ''.obs;
  var provinceId = ''.obs;
  var districtID = ''.obs;
  var currencyId = ''.obs;

  TextEditingController resellerNameController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController confirmPinController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  RxBool isLoading = false.obs;
}
