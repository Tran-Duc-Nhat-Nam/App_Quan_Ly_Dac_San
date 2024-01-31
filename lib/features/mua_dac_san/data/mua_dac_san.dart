import 'dart:convert';

import '../../../core/json_helper.dart';

class MuaDacSan {
  int id;
  String ten;
  static const String url = "${ApiHelper.baseUrl}muadacsan";

  MuaDacSan({
    required this.id,
    required this.ten,
  });

  factory MuaDacSan.fromJson(Map<String, dynamic> json) {
    return MuaDacSan(
      id: json["id"],
      ten: json["ten"],
    );
  }

  static List<MuaDacSan> fromJsonList(List<dynamic> json) {
    List<MuaDacSan> dsMuaDacSan = [];

    for (var value in json) {
      dsMuaDacSan.add(MuaDacSan.fromJson(value));
    }

    return dsMuaDacSan;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ten': ten,
      };

  static List<dynamic> toJsonList(List<MuaDacSan> dsMuaDacSan) {
    List<dynamic> dsJson = [];

    for (var muaDacSan in dsMuaDacSan) {
      dsJson.add(muaDacSan.toJson());
    }

    return dsJson;
  }

  static Future<List<MuaDacSan>> doc() async {
    List<MuaDacSan> dsMuaDacSan = [];

    var result = await docAPI(url);

    for (var document in result) {
      MuaDacSan nguyenLieu = MuaDacSan.fromJson(document);
      dsMuaDacSan.add(nguyenLieu);
    }

    return dsMuaDacSan;
  }

  static Future<MuaDacSan> docTheoID(int id) async {
    var result = await docAPI("$url/$id");
    return MuaDacSan.fromJson(result);
  }

  static Future<MuaDacSan?> them(String ten) async {
    final response = await taoAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': 0,
        'ten': ten,
      }),
    );

    if (response.statusCode == 201) {
      return MuaDacSan.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<bool> capNhat(MuaDacSan muaDacSan) async {
    final response = await capNhatAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': muaDacSan.id,
        'ten': muaDacSan.ten,
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
