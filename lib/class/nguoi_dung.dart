import 'dart:convert';

import '../json_helper.dart';
import 'dia_chi.dart';

class NguoiDung {
  int id;
  String email;
  String ten;
  bool isNam;
  DateTime ngaySinh;
  DiaChi diaChi;
  String soDienThoai;
  static const String url = "${ApiHelper.baseUrl}nguoidung";
  NguoiDung({
    required this.id,
    required this.email,
    required this.ten,
    required this.isNam,
    required this.ngaySinh,
    required this.diaChi,
    required this.soDienThoai,
  });

  factory NguoiDung.fromJson(Map<String, dynamic> json) {
    return NguoiDung(
      id: json['id'],
      email: json['email'],
      ten: json['ten'],
      isNam: json['is_nam'],
      ngaySinh: DateTime.parse(json['ngay_sinh']),
      diaChi: DiaChi.fromJson(json['dia_chi']),
      soDienThoai: json['so_dien_thoai'],
    );
  }

  static Future<List<NguoiDung>> doc() async {
    List<NguoiDung> dsNguoiDung = [];

    var result = await docAPI(url);

    for (var document in result) {
      NguoiDung nguoiDung = NguoiDung.fromJson(document);
      dsNguoiDung.add(nguoiDung);
    }

    return dsNguoiDung;
  }

  static Future<NguoiDung> docTheoID(int id) async {
    var result = await docAPI("$url/$id");
    return NguoiDung.fromJson(result);
  }

  static Future<NguoiDung?> them(NguoiDung nguoiDung) async {
    final response = await taoAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': 0,
        'email': nguoiDung.email,
        'ten': nguoiDung.ten,
        'is_nam': nguoiDung.isNam,
        'ngay_sinh': nguoiDung.ngaySinh.toIso8601String(),
        'dia_chi': nguoiDung.diaChi.toJson(),
        'so_dien_thoai': nguoiDung.soDienThoai,
      }),
    );

    if (response.statusCode == 201) {
      return NguoiDung.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<bool> capNhat(NguoiDung nguoiDung) async {
    final response = await capNhatAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': nguoiDung.id,
        'email': nguoiDung.email,
        'ten': nguoiDung.ten,
        'is_nam': nguoiDung.isNam,
        'ngay_sinh': nguoiDung.ngaySinh,
        'dia_chi': nguoiDung.diaChi.toJson(),
        'so_dien_thoai': nguoiDung.soDienThoai,
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
