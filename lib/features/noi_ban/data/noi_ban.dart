import 'dart:convert';

import 'package:app_dac_san/features/dac_san/data/dac_san.dart';
import 'package:app_dac_san/features/tinh_thanh/data/dia_chi.dart';
import 'package:equatable/equatable.dart';

import '../../../core/json_helper.dart';

class NoiBan extends Equatable {
  int id;
  String ten;
  String? moTa;
  DiaChi diaChi;
  List<int> dsDacSan = [];
  int luotXem = 0;
  double diemDanhGia = 0;
  int luotDanhGia = 0;
  static const String url = "${ApiHelper.baseUrl}noiban";
  static const String noiBanUrl = "${ApiHelper.baseUrl}noibandacsan";

  NoiBan({
    required this.id,
    required this.ten,
    this.moTa,
    required this.diaChi,
    required this.dsDacSan,
  });

  NoiBan.tam()
      : id = -1,
        ten = "",
        diaChi = DiaChi.tam(),
        dsDacSan = const [];

  NoiBan copy() {
    return NoiBan(
        id: id, ten: ten, moTa: moTa, diaChi: diaChi, dsDacSan: dsDacSan);
  }

  factory NoiBan.fromJson(Map<String, dynamic> json) {
    return NoiBan(
      id: json['id'],
      ten: json['ten'],
      moTa: json['mo_ta'],
      diaChi: DiaChi.fromJson(json['dia_chi']),
      dsDacSan: idFromJsonList(json['ds_dac_san']),
    );
  }

  static List<int> idFromJsonList(List<dynamic> json) {
    List<int> dsID = [];

    for (var value in json) {
      dsID.add(value);
    }

    return dsID;
  }

  static Future<List<NoiBan>> doc() async {
    List<NoiBan> dsNoiBan = [];

    var result = await docAPI(url);

    for (var document in result) {
      NoiBan nguyenLieu = NoiBan.fromJson(document);
      dsNoiBan.add(nguyenLieu);
    }

    return dsNoiBan;
  }

  static Future<NoiBan> docTheoID(int id) async {
    var result = await docAPI("$url/$id");
    return NoiBan.fromJson(result);
  }

  Future<List<DacSan>> docDacSan() async {
    List<DacSan> dsDacSan = [];

    var result = await docAPI("$url/$id/dacsan");

    for (var document in result) {
      DacSan dacSan = DacSan.fromJson(document);
      dsDacSan.add(dacSan);
    }

    return dsDacSan;
  }

  static Future<NoiBan?> them(NoiBan noiBan) async {
    final response = await taoAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': noiBan.id,
        'ten': noiBan.ten,
        'mo_ta': noiBan.moTa ?? "Chưa có thông tin",
        'dia_chi': noiBan.diaChi.toJson(),
        'ds_dac_san': noiBan.dsDacSan,
      }),
    );

    if (response.statusCode == 201) {
      return NoiBan.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  static Future<bool> capNhat(NoiBan noiBan) async {
    final response = await capNhatAPI(
      url,
      jsonEncode(<String, dynamic>{
        'id': noiBan.id,
        'ten': noiBan.ten,
        'mo_ta': noiBan.moTa ?? "Chưa có thông tin",
        'dia_chi': noiBan.diaChi.toJson(),
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
  // TODO: implement props
  List<Object?> get props => [id, ten, moTa, dsDacSan];
}
