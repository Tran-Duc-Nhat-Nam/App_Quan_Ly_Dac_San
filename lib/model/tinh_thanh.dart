import 'dart:convert';

import '../json_helper.dart';

class TinhThanh {
  int id;
  String ten;
  static const String url = "${ApiHelper.baseUrl}tinhthanh";
  TinhThanh({
    required this.id,
    required this.ten,
  });

  factory TinhThanh.fromJson(Map<String, dynamic> json) {
    return TinhThanh(
      id: json["id"],
      ten: json["ten"],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ten': ten,
      };

  static Future<List<TinhThanh>> doc() async {
    List<TinhThanh> dsTinhThanh = [];

    var result = await docAPI(url);

    for (var document in result) {
      TinhThanh nguyenLieu = TinhThanh.fromJson(document);
      dsTinhThanh.add(nguyenLieu);
    }

    return dsTinhThanh;
  }

  static Future<TinhThanh?> them(String ten) async {
    final response = await taoAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': 0,
        'ten': ten,
      }),
    );

    if (response.statusCode == 201) {
      return TinhThanh.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<bool> capNhat(TinhThanh tinhThanh) async {
    final response = await capNhatAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': tinhThanh.id,
        'ten': tinhThanh.ten,
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
