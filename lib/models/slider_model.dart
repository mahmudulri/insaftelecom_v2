// To parse this JSON data, do
//
//     final sliderModel = sliderModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SliderModel sliderModelFromJson(String str) =>
    SliderModel.fromJson(json.decode(str));

String sliderModelToJson(SliderModel data) => json.encode(data.toJson());

class SliderModel {
  final bool? success;

  final Data? data;

  SliderModel({
    this.success,
    this.data,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data!.toJson(),
      };
}

class Data {
  final List<Advertisement> advertisements;

  Data({
    required this.advertisements,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        advertisements: List<Advertisement>.from(
            json["advertisements"].map((x) => Advertisement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "advertisements":
            List<dynamic>.from(advertisements.map((x) => x.toJson())),
      };
}

class Advertisement {
  final int? id;
  final String? advertisementTitle;
  final String? adSliderImageUrl;

  Advertisement({
    this.id,
    this.advertisementTitle,
    this.adSliderImageUrl,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) => Advertisement(
        id: json["id"],
        advertisementTitle: json["advertisement_title"],
        adSliderImageUrl: json["ad_slider_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "advertisement_title": advertisementTitle,
        "ad_slider_image_url": adSliderImageUrl,
      };
}
