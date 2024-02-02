import 'dart:convert';

import 'package:app_dac_san/features/tinh_thanh/data/tinh_thanh.dart';

import '../../../core/json_helper.dart';

class QuanHuyen {
  int id;
  String ten;
  TinhThanh tinhThanh;
  static const String url = "${ApiHelper.baseUrl}quanhuyen";

  QuanHuyen({
    required this.id,
    required this.ten,
    required this.tinhThanh,
  });

  QuanHuyen.tam()
      : id = -1,
        ten = "",
        tinhThanh = TinhThanh.tam();

  factory QuanHuyen.fromJson(Map<String, dynamic> json) {
    return QuanHuyen(
      id: json["id"],
      ten: json["ten"],
      tinhThanh: TinhThanh.fromJson(json["tinh_thanh"]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ten': ten,
        'tinh_thanh': tinhThanh.toJson(),
      };

  static Future<List<QuanHuyen>> doc(int idTinhThanh) async {
    List<QuanHuyen> dsQuanHuyen = [];

    var result =
        await docAPI("${ApiHelper.baseUrl}tinhthanh/$idTinhThanh/quanhuyen");

    for (var document in result) {
      QuanHuyen nguyenLieu = QuanHuyen.fromJson(document);
      dsQuanHuyen.add(nguyenLieu);
    }

    return dsQuanHuyen;
  }

  static Future<QuanHuyen?> them(QuanHuyen quanHuyen) async {
    final response = await taoAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': quanHuyen.id,
        'ten': quanHuyen.ten,
        'dia_chi': quanHuyen.tinhThanh.toJson(),
      }),
    );

    if (response.statusCode == 201) {
      return QuanHuyen.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<bool> capNhat(QuanHuyen quanHuyen) async {
    final response = await capNhatAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': quanHuyen.id,
        'ten': quanHuyen.ten,
        'dia_chi': quanHuyen.tinhThanh.toJson(),
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
