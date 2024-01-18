import 'dart:convert';

import '../json_helper.dart';

class VungMien {
  int id;
  String ten;
  static const String url = "${ApiHelper.baseUrl}vungmien";
  VungMien({
    required this.id,
    required this.ten,
  });

  factory VungMien.fromJson(Map<String, dynamic> json) {
    return VungMien(
      id: json["id"],
      ten: json["ten"],
    );
  }

  static List<VungMien> fromJsonList(List<dynamic> json) {
    List<VungMien> dsVungMien = [];

    for (var value in json) {
      dsVungMien.add(VungMien.fromJson(value));
    }

    return dsVungMien;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ten': ten,
      };

  static List<dynamic> toJsonList(List<VungMien> dsVungMien) {
    List<dynamic> dsJson = [];

    for (var vungMien in dsVungMien) {
      dsJson.add(vungMien.toJson());
    }

    return dsJson;
  }

  static Future<List<VungMien>> doc() async {
    List<VungMien> dsVungMien = [];

    var result = await docAPI(url);

    for (var document in result) {
      VungMien nguyenLieu = VungMien.fromJson(document);
      dsVungMien.add(nguyenLieu);
    }

    return dsVungMien;
  }

  static Future<VungMien?> them(String ten) async {
    final response = await taoAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': 0,
        'ten': ten,
      }),
    );

    if (response.statusCode == 201) {
      return VungMien.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<bool> capNhat(VungMien vungMien) async {
    final response = await capNhatAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': vungMien.id,
        'ten': vungMien.ten,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<bool> xoa(int id) async {
    final response = await xoaAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': id,
      }),
    );

    return response.statusCode == 200;
  }
}
