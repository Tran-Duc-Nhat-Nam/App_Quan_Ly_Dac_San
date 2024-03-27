import 'dart:convert';

import 'package:app_dac_san/features/noi_ban/data/luot_xem_noi_ban.dart';

import '../../../core/json_helper.dart';
import '../../dac_san/data/luot_danh_gia_dac_san.dart';
import '../../dac_san/data/luot_xem_dac_san.dart';
import '../../noi_ban/data/luot_danh_gia_noi_ban.dart';
import '../../tinh_thanh/data/dia_chi.dart';

class NguoiDung {
  String id;
  String email;
  String ten;
  bool isNam;
  DateTime ngaySinh;
  DiaChi diaChi;
  String soDienThoai;
  List<LuotXemDacSan> lichSuXemDacSan = const [];
  List<LuotXemNoiBan> lichSuXemNoiBan = const [];
  List<LuotDanhGiaDacSan> lichSuDanhGiaDacSan = const [];
  List<LuotDanhGiaNoiBan> lichSuDanhGiaNoiBan = const [];
  static const String url = "${ApiHelper.baseUrl}nguoidung";

  NguoiDung({
    required this.id,
    required this.email,
    required this.ten,
    required this.isNam,
    required this.ngaySinh,
    required this.diaChi,
    required this.soDienThoai,
    this.lichSuXemDacSan = const [],
    this.lichSuXemNoiBan = const [],
    this.lichSuDanhGiaDacSan = const [],
    this.lichSuDanhGiaNoiBan = const [],
  });

  NguoiDung.tam()
      : id = "",
        ten = "",
        email = '',
        isNam = false,
        ngaySinh = DateTime.now(),
        diaChi = DiaChi.tam(),
        soDienThoai = '';

  factory NguoiDung.fromJson(Map<String, dynamic> json) {
    return NguoiDung(
      id: json['id'],
      email: json['email'],
      ten: json['ten'],
      isNam: json['is_nam'],
      ngaySinh: DateTime.parse(json['ngay_sinh']),
      diaChi: DiaChi.fromJson(json['dia_chi']),
      soDienThoai: json['so_dien_thoai'],
      lichSuXemDacSan: LuotXemDacSan.fromJsonList(json['lich_su_xem_dac_san']),
      lichSuXemNoiBan: LuotXemNoiBan.fromJsonList(json['lich_su_xem_noi_ban']),
      lichSuDanhGiaDacSan:
          LuotDanhGiaDacSan.fromJsonList(json['lich_su_xem_dac_san']),
      lichSuDanhGiaNoiBan:
          LuotDanhGiaNoiBan.fromJsonList(json['lich_su_xem_noi_ban']),
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
        'ngay_sinh': nguoiDung.ngaySinh.toUtc().toIso8601String(),
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

  static Future<bool> xoa(String id) async {
    final response = await xoaAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': id,
      }),
    );

    return response.statusCode == 200;
  }
}
