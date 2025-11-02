import 'dart:convert';

HelpModel helpModelFromJson(String str) => HelpModel.fromJson(json.decode(str));

String helpModelToJson(HelpModel data) => json.encode(data.toJson());

class HelpModel {
  final bool? success;
  final int? code;
  final String? message;
  final Data? data;

  HelpModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory HelpModel.fromJson(Map<String, dynamic> json) => HelpModel(
        success: json["success"],
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "code": code,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  final List<Article>? articles;

  Data({
    this.articles,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        articles: List<Article>.from(
            json["articles"].map((x) => Article.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "articles": List<dynamic>.from(articles!.map((x) => x.toJson())),
      };
}

class Article {
  final int? id;
  final String? title;
  final String? description;

  Article({
    this.id,
    this.title,
    this.description,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
      };
}
