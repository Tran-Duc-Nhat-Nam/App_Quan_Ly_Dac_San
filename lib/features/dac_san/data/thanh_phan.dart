import 'dart:convert';

import 'package:app_dac_san/features/nguyen_lieu/data/nguyen_lieu.dart';

import '../../../core/json_helper.dart';

class ThanhPhan {
  NguyenLieu nguyenLieu;
  double soLuong;
  String donViTinh;
  static const String url = "${ApiHelper.baseUrl}thanhphan";

  ThanhPhan({
    required this.nguyenLieu,
    required this.soLuong,
    required this.donViTinh,
  });

  ThanhPhan.tam()
      : nguyenLieu = NguyenLieu(id: -1, ten: ""),
        soLuong = 0,
        donViTinh = "";

  factory ThanhPhan.fromJson(Map<String, dynamic> json) {
    return ThanhPhan(
      nguyenLieu: NguyenLieu.fromJson(json['nguyen_lieu']),
      soLuong: json['so_luong'],
      donViTinh: json['don_vi_tinh'],
    );
  }

  static List<ThanhPhan> fromJsonList(List<dynamic> json) {
    List<ThanhPhan> dsThanhPhan = [];

    for (var value in json) {
      dsThanhPhan.add(ThanhPhan.fromJson(value));
    }

    return dsThanhPhan;
  }

  Map<String, dynamic> toJson() => {
        'nguyen_lieu': nguyenLieu.toJson(),
        'so_luong': soLuong,
        'don_vi_tinh': donViTinh,
      };

  static List<dynamic> toJsonList(List<ThanhPhan> dsThanhPhan) {
    List<dynamic> dsJson = [];

    for (var thanhPhan in dsThanhPhan) {
      dsJson.add(thanhPhan.toJson());
    }

    return dsJson;
  }

  static Future<ThanhPhan?> them(ThanhPhan thanhPhan) async {
    final response = await taoAPI(
      url,
      jsonEncode(<String, dynamic>{
        'nguyen_lieu': thanhPhan.nguyenLieu.toJson(),
        'so_luong': thanhPhan.soLuong,
        'don_vi_tinh': thanhPhan.donViTinh,
      }),
    );

    if (response.statusCode == 201) {
      return ThanhPhan.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<bool> capNhat(ThanhPhan thanhPhan) async {
    final response = await capNhatAPI(
      url,
      jsonEncode(<String, dynamic>{
        'nguyen_lieu': thanhPhan.nguyenLieu.toJson(),
        'so_luong': thanhPhan.soLuong,
        'don_vi_tinh': thanhPhan.donViTinh,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<bool> xoa(int idDacSan, int idNguyenLieu) async {
    final response = await xoaAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id_dac_san': idDacSan,
        'id_nguyen_lieu': idNguyenLieu,
      }),
    );

    return response.statusCode == 200;
  }

  @override
  String toString() {
    return "$soLuong $donViTinh ${nguyenLieu.ten}";
  }
}
