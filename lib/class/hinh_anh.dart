import 'dart:convert';

import '../json_helper.dart';

class HinhAnh {
  int id;
  String ten;
  String? moTa;
  String urlHinhAnh;
  static const String url = "${ApiHelper.baseUrl}thanhphan";
  HinhAnh({
    this.id = -1,
    this.ten = "",
    this.moTa = "",
    this.urlHinhAnh = "",
  });

  factory HinhAnh.fromJson(Map<String, dynamic> json) {
    return HinhAnh(
      id: json['id'],
      ten: json['ten'],
      moTa: json['mo_ta'],
      urlHinhAnh: json['url'],
    );
  }
  static List<HinhAnh> fromJsonList(List<dynamic> json) {
    List<HinhAnh> dsHinhAnh = [];

    for (var value in json) {
      dsHinhAnh.add(HinhAnh.fromJson(value));
    }

    return dsHinhAnh;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ten': ten,
        'mo_ta': moTa,
        'url': urlHinhAnh,
      };

  static List<dynamic> toJsonList(List<HinhAnh> dsHinhAnh) {
    List<dynamic> dsJson = [];

    for (var hinhAnh in dsHinhAnh) {
      dsJson.add(hinhAnh.toJson());
    }

    return dsJson;
  }

  static Future<HinhAnh?> them(HinhAnh hinhAnh) async {
    final response = await taoAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': hinhAnh.id,
        'ten': hinhAnh.ten,
        'mo_ta': hinhAnh.moTa,
        'url': hinhAnh.urlHinhAnh,
      }),
    );

    if (response.statusCode == 201) {
      return HinhAnh.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<bool> capNhat(HinhAnh hinhAnh) async {
    final response = await capNhatAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': hinhAnh.id,
        'ten': hinhAnh.ten,
        'mo_ta': hinhAnh.moTa,
        'url': hinhAnh.urlHinhAnh,
      }),
    );

    return response.statusCode == 200;
  }

  static Future<bool> xoa(int idDacSan, int idNguyenLieu) async {
    final response = await xoaAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': idDacSan,
      }),
    );

    return response.statusCode == 200;
  }
}
