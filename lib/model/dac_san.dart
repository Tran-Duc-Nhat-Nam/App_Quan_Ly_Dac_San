import 'dart:convert';

import '../json_helper.dart';

class DacSan {
  int id;
  String ten;
  String? moTa;
  String? cachCheBien;
  int luotXem = 0;
  double diemDanhGia = 0;
  int luotDanhGia = 0;
  static const String url = "${ApiHelper.baseUrl}dacsan";

  DacSan({
    required this.id,
    required this.ten,
    this.moTa,
    this.cachCheBien,
  });

  factory DacSan.fromJson(Map<String, dynamic> json) {
    return DacSan(
      id: json['id'],
      ten: json['ten'],
      moTa: json['mo_ta'],
      cachCheBien: json['cach_che_bien'],
    );
  }

  static Future<List<DacSan>> doc() async {
    List<DacSan> dsDacSan = [];

    var result = await docAPI(url);

    for (var document in result) {
      DacSan nguyenLieu = DacSan.fromJson(document);
      dsDacSan.add(nguyenLieu);
    }

    return dsDacSan;
  }

  static Future<DacSan?> them(
      String ten, String? moTa, String? cachCheBien) async {
    final response = await taoAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': 0,
        'ten': ten,
        'mo_ta': moTa ?? "Chưa có thông tin",
        'cach_che_bien': cachCheBien ?? "Chưa có thông tin",
      }),
    );

    if (response.statusCode == 201) {
      return DacSan.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<bool> capNhat(DacSan dacSan) async {
    final response = await capNhatAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': dacSan.id,
        'ten': dacSan.ten,
        'mo_ta': dacSan.moTa ?? "Chưa có thông tin",
        'cach_che_bien': dacSan.cachCheBien ?? "Chưa có thông tin",
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
