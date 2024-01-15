import 'dart:convert';

import 'package:app_dac_san/model/dia_chi.dart';

import '../json_helper.dart';

class NoiBan {
  int id;
  String ten;
  String? moTa;
  DiaChi diaChi;
  int luotXem = 0;
  double diemDanhGia = 0;
  int luotDanhGia = 0;

  NoiBan({
    required this.id,
    required this.ten,
    this.moTa,
    required this.diaChi,
  });

  factory NoiBan.fromJson(Map<String, dynamic> json) {
    return NoiBan(
      id: json['id'],
      ten: json['ten'],
      moTa: json['mo_ta'],
      diaChi: DiaChi.fromJson(json['dia_chi']),
    );
  }

  static Future<List<NoiBan>> doc() async {
    List<NoiBan> dsNoiBan = [];

    var result = await docJson('http://localhost:8080/noiban');

    for (var document in result) {
      NoiBan nguyenLieu = NoiBan.fromJson(document);
      dsNoiBan.add(nguyenLieu);
    }

    return dsNoiBan;
  }

  static Future<NoiBan?> them(String ten, String? moTa, DiaChi diaChi) async {
    final response = await ghiJson(
      'http://localhost:8080/noiban/them',
      jsonEncode(<String, dynamic>{
        'id': 0,
        'ten': ten,
        'mo_ta': moTa ?? "Chưa có thông tin",
        'dia_chi': diaChi.toJson(),
      }),
    );

    if (response.statusCode == 201) {
      return NoiBan.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<bool> capNhat(NoiBan noiBan) async {
    final response = await ghiJson(
      'http://localhost:8080/noiban/capnhat',
      jsonEncode(<String, dynamic>{
        'id': noiBan.id,
        'ten': noiBan.ten,
        'mo_ta': noiBan.moTa ?? "Chưa có thông tin",
        'dia_chi': noiBan.diaChi.toJson(),
      }),
    );

    return response.statusCode == 200;
  }

  static Future<bool> xoa(int id) async {
    final response = await ghiJson(
      'http://localhost:8080/noiban/xoa',
      jsonEncode(<String, dynamic>{
        'id': id,
      }),
    );

    return response.statusCode == 200;
  }
}
