import 'dart:convert';

import '../json_helper.dart';

class VungMien {
  int id;
  String ten;

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

  static Future<List<VungMien>> doc() async {
    List<VungMien> dsVungMien = [];

    var result = await docJson('http://localhost:8080/vungmien');

    for (var document in result) {
      VungMien nguyenLieu = VungMien.fromJson(document);
      dsVungMien.add(nguyenLieu);
    }

    return dsVungMien;
  }

  static Future<VungMien?> them(String ten) async {
    final response = await ghiJson(
      'http://localhost:8080/vungmien/them',
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
    final response = await ghiJson(
      'http://localhost:8080/vungmien/capnhat',
      jsonEncode(<String, dynamic>{
        'id': vungMien.id,
        'ten': vungMien.ten,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<bool> xoa(int id) async {
    final response = await ghiJson(
      'http://localhost:8080/vungmien/xoa',
      jsonEncode(<String, dynamic>{
        'id': id,
      }),
    );

    return response.statusCode == 200;
  }
}
