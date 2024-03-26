import 'dart:convert';

import 'package:app_dac_san/features/dac_san/data/thanh_phan.dart';
import 'package:app_dac_san/features/mua_dac_san/data/mua_dac_san.dart';
import 'package:app_dac_san/features/vung_mien/data/vung_mien.dart';
import 'package:equatable/equatable.dart';

import '../../../core/json_helper.dart';
import 'hinh_anh.dart';

class DacSan extends Equatable {
  int id;
  String ten;
  String? moTa;
  String? cachCheBien;
  int luotXem = 0;
  double diemDanhGia = 0;
  int luotDanhGia = 0;
  List<VungMien> vungMien = [];
  List<MuaDacSan> muaDacSan = [];
  List<ThanhPhan> thanhPhan = [];
  List<HinhAnh> hinhAnh = [];
  HinhAnh hinhDaiDien;
  static const String url = "${ApiHelper.baseUrl}dacsan";

  DacSan({
    this.id = -1,
    this.ten = "",
    this.moTa,
    this.cachCheBien,
  this.luotXem = 0,
  this.diemDanhGia = 0,
  this.luotDanhGia = 0,
    this.vungMien = const [],
    this.muaDacSan = const [],
    this.thanhPhan = const [],
    this.hinhAnh = const [],
    required this.hinhDaiDien,
  });

  DacSan.tam()
      : id = -1,
        ten = "",
        vungMien = const [],
        muaDacSan = const [],
        thanhPhan = const [],
        hinhAnh = const [],
        hinhDaiDien = HinhAnh.tam();

  DacSan copy() {
    return DacSan(
        id: id,
        ten: ten,
        moTa: moTa,
        cachCheBien: cachCheBien,
        vungMien: vungMien,
        muaDacSan: muaDacSan,
        thanhPhan: thanhPhan,
        luotXem: luotXem,
        diemDanhGia: diemDanhGia,
        luotDanhGia: luotDanhGia,
        hinhAnh: hinhAnh,
        hinhDaiDien: hinhDaiDien);
  }

  factory DacSan.fromJson(Map<String, dynamic> json) {
    return DacSan(
      id: json['id'],
      ten: json['ten'],
      moTa: json['mo_ta'],
      cachCheBien: json['cach_che_bien'],
      luotXem: json['luot_xem'],
      diemDanhGia: json['diem_danh_gia'],
      luotDanhGia: json['luot_danh_gia'],
      vungMien: VungMien.fromJsonList(json['vung_mien']),
      muaDacSan: MuaDacSan.fromJsonList(json['mua_dac_san']),
      thanhPhan: ThanhPhan.fromJsonList(json['thanh_phan']),
      hinhAnh: HinhAnh.fromJsonList(json['hinh_anh']),
      hinhDaiDien: HinhAnh.fromJson(json['hinh_dai_dien']),
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

  static Future<DacSan> docTheoID(int id) async {
    var result = await docAPI("$url/$id");
    return DacSan.fromJson(result);
  }

  static Future<DacSan?> them(DacSan dacSan) async {
    final response = await taoAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': 0,
        'ten': dacSan.ten,
        'mo_ta': dacSan.moTa ?? "Chưa có thông tin",
        'cach_che_bien': dacSan.cachCheBien ?? "Chưa có thông tin",
        'luot_xem': dacSan.luotXem,
        'diem_danh_gia': dacSan.diemDanhGia,
        'luot_danh_gia': dacSan.luotDanhGia,
        'vung_mien': VungMien.toJsonList(dacSan.vungMien),
        'mua_dac_san': MuaDacSan.toJsonList(dacSan.muaDacSan),
        'thanh_phan': ThanhPhan.toJsonList(dacSan.thanhPhan),
        'hinh_anh': HinhAnh.toJsonList(dacSan.hinhAnh),
        'hinh_dai_dien': dacSan.hinhDaiDien.toJson(),
        'noi_ban_dac_san': [],
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
        'luot_xem': dacSan.luotXem,
        'diem_danh_gia': dacSan.diemDanhGia,
        'luot_danh_gia': dacSan.luotDanhGia,
        'vung_mien': dacSan.vungMien,
        'mua_dac_san': dacSan.muaDacSan,
        'thanh_phan': dacSan.thanhPhan,
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

  @override
  List<Object?> get props =>
      [id, ten, vungMien, muaDacSan, hinhAnh, hinhDaiDien];
}
