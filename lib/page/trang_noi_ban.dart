import 'dart:convert';

import 'package:app_dac_san/model/noi_ban.dart';
import 'package:async_builder/async_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class TrangNoiBan extends StatefulWidget {
  const TrangNoiBan({super.key});

  @override
  State<TrangNoiBan> createState() => _TrangNoiBanState();
}

class _TrangNoiBanState extends State<TrangNoiBan> {
  List<NoiBan> dsNoiBan = [];
  late Future myFuture;
  @override
  void initState() {
    myFuture = Future.delayed(const Duration(seconds: 1), () async {
      dsNoiBan = await docNoiBan();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder(
      future: myFuture,
      waiting: (context) => const Center(child: Text('Loading...')),
      builder: (context, value) => Flexible(
        flex: 1,
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 600),
                child: PaginatedDataTable2(
                  rowsPerPage: 10,
                  columns: const [
                    DataColumn2(
                      label: Text('ID'),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text('Tên'),
                      size: ColumnSize.M,
                    ),
                    DataColumn2(
                      label: Text('Mô tả'),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: Text('Địa chỉ'),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: Text('Lượt xem'),
                      size: ColumnSize.S,
                      numeric: true,
                    ),
                    DataColumn2(
                      label: Text('Điểm đánh giá'),
                      size: ColumnSize.S,
                      numeric: true,
                    ),
                    DataColumn2(
                      label: Text('Lượt đánh giá'),
                      size: ColumnSize.S,
                      numeric: true,
                    ),
                  ],
                  source: NoiBanDataTableSource(dsNoiBan: dsNoiBan),
                ),
              ),
            ),
            Container(
              height: 250,
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            label: const Text("Tên"),
                            hintText: "Nhập tên nơi bán",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            )),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            label: const Text("Mô tả"),
                            hintText: "Nhập thông tin mô tả nơi bán",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      error: (context, error, stackTrace) =>
          Center(child: Text('Error! $error')),
    );
  }
}

class NoiBanDataTableSource extends DataTableSource {
  List<NoiBan> dsNoiBan = [];
  NoiBanDataTableSource({required this.dsNoiBan});
  @override
  DataRow? getRow(int index) {
    return DataRow2(
      cells: [
        DataCell(Text(dsNoiBan[index].id.toString())),
        DataCell(Text(dsNoiBan[index].ten)),
        DataCell(Text(dsNoiBan[index].moTa ?? "Chưa có thông tin")),
        DataCell(Text(dsNoiBan[index].diaChi.toString())),
        DataCell(Text(dsNoiBan[index].luotXem.toString())),
        DataCell(Text(dsNoiBan[index].diemDanhGia.toString())),
        DataCell(Text(dsNoiBan[index].luotDanhGia.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsNoiBan.length;

  @override
  int get selectedRowCount => 0;
}

Future<List<NoiBan>> docNoiBan() async {
  List<NoiBan> dsNoiBan = [];

  var reponse = await get(
    Uri.parse('http://localhost:8080/noiban'),
    headers: {"Access-Control-Allow-Origin": "*"},
  );
  var result = json.decode(utf8.decode(reponse.bodyBytes));

  for (var document in result) {
    NoiBan noiBan = NoiBan.fromJson(document);
    dsNoiBan.add(noiBan);
  }

  return dsNoiBan;
}
