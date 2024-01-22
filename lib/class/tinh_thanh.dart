import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

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
      TinhThanh tinhThanh = TinhThanh.fromJson(document);
      dsTinhThanh.add(tinhThanh);
    }

    return dsTinhThanh;
  }

  static Future<TinhThanh> docTheoID(int id) async {
    var result = await docAPI("$url/$id");
    return TinhThanh.fromJson(result);
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

class TinhThanhDataTableSource extends DataTableSource {
  List<TinhThanh> dsTinhThanh = [];
  List<bool> dsChon = [];
  void Function(int) notifyParent;
  TinhThanhDataTableSource({
    required this.dsTinhThanh,
    required this.dsChon,
    required this.notifyParent,
  });
  @override
  DataRow? getRow(int index) {
    // TODO: implement getRow
    return DataRow2(
      onSelectChanged: (value) {
        dsChon[index] = value!;
        notifyListeners();
        notifyParent(index);
      },
      selected: dsChon[index],
      cells: [
        DataCell(Text(dsTinhThanh[index].id.toString())),
        DataCell(Text(dsTinhThanh[index].ten)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsTinhThanh.length;

  @override
  int get selectedRowCount => 0;
}
