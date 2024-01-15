import 'dart:convert';

import 'package:app_dac_san/json_helper.dart';

class NguyenLieu {
  int id;
  String ten;

  NguyenLieu({
    required this.id,
    required this.ten,
  });

  factory NguyenLieu.fromJson(Map<String, dynamic> json) {
    return NguyenLieu(
      id: json["id"],
      ten: json["ten"],
    );
  }

  static Future<List<NguyenLieu>> doc() async {
    List<NguyenLieu> dsNguyenLieu = [];

    var result = await docJson('http://localhost:8080/nguyenlieu');

    for (var document in result) {
      NguyenLieu nguyenLieu = NguyenLieu.fromJson(document);
      dsNguyenLieu.add(nguyenLieu);
    }

    return dsNguyenLieu;
  }

  static Future<NguyenLieu?> them(String ten) async {
    final response = await ghiJson(
      'http://localhost:8080/nguyenlieu/them',
      jsonEncode(<String, dynamic>{
        'id': 0,
        'ten': ten,
      }),
    );

    if (response.statusCode == 201) {
      return NguyenLieu.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<bool> capNhat(NguyenLieu nguyenLieu) async {
    final response = await ghiJson(
      'http://localhost:8080/nguyenlieu/capnhat',
      jsonEncode(<String, dynamic>{
        'id': nguyenLieu.id,
        'ten': nguyenLieu.ten,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<bool> xoa(int id) async {
    final response = await ghiJson(
      'http://localhost:8080/nguyenlieu/xoa',
      jsonEncode(<String, dynamic>{
        'id': id,
      }),
    );

    return response.statusCode == 200;
  }
}
