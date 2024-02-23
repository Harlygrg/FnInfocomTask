// To parse this JSON data, do
//
//     final imageModel = imageModelFromJson(jsonString);

import 'dart:convert';

ImageModel imageModelFromJson(String str) => ImageModel.fromJson(json.decode(str));

class ImageModel {
  String? message;
  String? status;

  ImageModel({
    this.message,
    this.status,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
    message: json["message"],
    status: json["status"],
  );

}
