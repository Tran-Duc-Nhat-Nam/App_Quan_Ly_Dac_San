import 'dart:convert';

import '../json_helper.dart';

class MuaDacSan {
  int id;
  String ten;

  MuaDacSan({
    required this.id,
    required this.ten,
  });

  factory MuaDacSan.fromJson(Map<String, dynamic> json) {
    return MuaDacSan(
      id: json["id"],
      ten: json["ten"],
    );
  }

  static Future<List<MuaDacSan>> doc() async {
    List<MuaDacSan> dsMuaDacSan = [];

    var result = await docJson('http://localhost:8080/muadacsan');

    for (var document in result) {
      MuaDacSan nguyenLieu = MuaDacSan.fromJson(document);
      dsMuaDacSan.add(nguyenLieu);
    }

    return dsMuaDacSan;
  }

  static Future<MuaDacSan?> them(String ten) async {
    final response = await ghiJson(
      'http://localhost:8080/muadacsan/them',
      jsonEncode(<String, dynamic>{
        'id': 0,
        'ten': ten,
      }),
    );

    if (response.statusCode == 201) {
      return MuaDacSan.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<bool> capNhat(MuaDacSan muaDacSan) async {
    final response = await ghiJson(
      'http://localhost:8080/muadacsan/capnhat',
      jsonEncode(<String, dynamic>{
        'id': muaDacSan.id,
        'ten': muaDacSan.ten,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<bool> xoa(int id) async {
    final response = await ghiJson(
      'http://localhost:8080/muadacsan/xoa',
      jsonEncode(<String, dynamic>{
        'id': id,
      }),
    );

    return response.statusCode == 200;
  }
}
