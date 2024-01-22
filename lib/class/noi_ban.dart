import 'dart:convert';

import 'package:app_dac_san/class/dia_chi.dart';

import '../json_helper.dart';
import 'dac_san.dart';

class NoiBan {
  int id;
  String ten;
  String? moTa;
  DiaChi diaChi;
  int luotXem = 0;
  double diemDanhGia = 0;
  int luotDanhGia = 0;
  static const String url = "${ApiHelper.baseUrl}noiban";
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

    var result = await docAPI(url);

    for (var document in result) {
      NoiBan nguyenLieu = NoiBan.fromJson(document);
      dsNoiBan.add(nguyenLieu);
    }

    return dsNoiBan;
  }

  static Future<NoiBan> docTheoID(int id) async {
    var result = await docAPI("$url/$id");
    return NoiBan.fromJson(result);
  }

  Future<List<DacSan>> docDacSan() async {
    List<DacSan> dsDacSan = [];

    var result = await docAPI("$url/$id/dacsan");

    for (var document in result) {
      DacSan nguyenLieu = DacSan.fromJson(document);
      dsDacSan.add(nguyenLieu);
    }

    return dsDacSan;
  }

  static Future<NoiBan?> them(NoiBan noiBan) async {
    final response = await taoAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': noiBan.id,
        'ten': noiBan.ten,
        'mo_ta': noiBan.moTa ?? "Chưa có thông tin",
        'dia_chi': noiBan.diaChi.toJson(),
      }),
    );

    if (response.statusCode == 201) {
      return NoiBan.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<bool> capNhat(NoiBan noiBan) async {
    final response = await capNhatAPI(
      url,
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
    final response = await xoaAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': id,
      }),
    );

    return response.statusCode == 200;
  }
}
