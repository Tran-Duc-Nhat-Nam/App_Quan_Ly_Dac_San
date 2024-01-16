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
      ngaySinh: json['ngay_sinh'],
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

  static Future<NguoiDung?> them(String ten, String email, bool isNam,
      String soDienThoai, DiaChi diaChi, DateTime ngaySinh) async {
    final response = await taoAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': 0,
        'email': email,
        'ten': ten,
        'is_nam': isNam,
        'ngay_sinh': ngaySinh,
        'dia_chi': diaChi.toJson(),
        'so_dien_thoai': soDienThoai,
      }),
    );

    if (response.statusCode == 201) {
      return NguoiDung.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<bool> capNhat(NguoiDung nguoidung) async {
    final response = await capNhatAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': nguoidung.id,
        'email': nguoidung.email,
        'ten': nguoidung.ten,
        'is_nam': nguoidung.isNam,
        'ngay_sinh': nguoidung.ngaySinh,
        'dia_chi': nguoidung.diaChi.toJson(),
        'so_dien_thoai': nguoidung.soDienThoai,
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
