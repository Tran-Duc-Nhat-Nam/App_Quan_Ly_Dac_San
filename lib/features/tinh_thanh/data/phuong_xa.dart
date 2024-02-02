import 'dart:convert';

import 'package:app_dac_san/features/tinh_thanh/data/quan_huyen.dart';

import '../../../core/json_helper.dart';

class PhuongXa {
  int id;
  String ten;
  QuanHuyen quanHuyen;
  static const String url = "${ApiHelper.baseUrl}phuongxa";

  PhuongXa({
    required this.id,
    required this.ten,
    required this.quanHuyen,
  });

  PhuongXa.tam()
      : id = -1,
        ten = "",
        quanHuyen = QuanHuyen.tam();

  factory PhuongXa.fromJson(Map<String, dynamic> json) {
    return PhuongXa(
      id: json["id"],
      ten: json["ten"],
      quanHuyen: QuanHuyen.fromJson(json["quan_huyen"]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ten': ten,
        'quan_huyen': quanHuyen.toJson(),
      };

  static Future<List<PhuongXa>> doc(int idQuanHuyen) async {
    List<PhuongXa> dsPhuongXa = [];

    var result =
        await docAPI("${ApiHelper.baseUrl}quanhuyen/$idQuanHuyen/phuongxa");

    for (var document in result) {
      PhuongXa phuongXa = PhuongXa.fromJson(document);
      dsPhuongXa.add(phuongXa);
    }

    return dsPhuongXa;
  }

  static Future<PhuongXa?> them(PhuongXa phuongXa) async {
    final response = await taoAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': phuongXa.id,
        'ten': phuongXa.ten,
        'dia_chi': phuongXa.quanHuyen.toJson(),
      }),
    );

    if (response.statusCode == 201) {
      return PhuongXa.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<bool> capNhat(PhuongXa phuongXa) async {
    final response = await capNhatAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': phuongXa.id,
        'ten': phuongXa.ten,
        'dia_chi': phuongXa.quanHuyen.toJson(),
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
