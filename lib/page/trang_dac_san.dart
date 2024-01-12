import 'dart:convert';

import 'package:async_builder/async_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../model/dac_san.dart';

class TrangDacSan extends StatefulWidget {
  const TrangDacSan({super.key});

  @override
  _TrangDacSanState createState() => _TrangDacSanState();
}

class _TrangDacSanState extends State<TrangDacSan> {
  List<DacSan> dsDacSan = [];
  late Future myFuture;
  @override
  void initState() {
    myFuture = Future.delayed(const Duration(seconds: 1), () async {
      dsDacSan = await docDacSan();
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
                      size: ColumnSize.L,
                    ),
                    DataColumn(
                      label: Text('Tên'),
                    ),
                    DataColumn(
                      label: Text('Mô tả'),
                    ),
                    DataColumn(
                      label: Text('Cách chế biến'),
                    ),
                    DataColumn(
                      label: Text('Lượt xem'),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Điểm đánh giá'),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Lượt đánh giá'),
                      numeric: true,
                    ),
                  ],
                  source: DacSanDataTableSource(dsDacSan: dsDacSan),
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
                            hintText: "Nhập tên đặc sản",
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
                            hintText: "Nhập thông tin mô tả đặc sản",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            )),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            label: const Text("Cách chế biến"),
                            hintText:
                                "Nhập cách thức chế biến đặc sản (nếu có)",
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

class DacSanDataTableSource extends DataTableSource {
  List<DacSan> dsDacSan = [];
  DacSanDataTableSource({required this.dsDacSan});
  @override
  DataRow? getRow(int index) {
    return DataRow2(
      cells: [
        DataCell(Text(dsDacSan[index].id.toString())),
        DataCell(Text(dsDacSan[index].ten)),
        DataCell(Text(dsDacSan[index].moTa ?? "Chưa có thông tin")),
        DataCell(Text(dsDacSan[index].cachCheBien ?? "Chưa có thông tin")),
        DataCell(Text(dsDacSan[index].luotXem.toString())),
        DataCell(Text(dsDacSan[index].diemDanhGia.toString())),
        DataCell(Text(dsDacSan[index].luotDanhGia.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsDacSan.length;

  @override
  int get selectedRowCount => 0;
}

Future<List<DacSan>> docDacSan() async {
  List<DacSan> dsDacSan = [];

  var reponse = await get(
    Uri.parse('http://localhost:8080/dacsan'),
    headers: {"Access-Control-Allow-Origin": "*"},
  );
  var result = json.decode(utf8.decode(reponse.bodyBytes));

  for (var document in result) {
    DacSan dacSan = DacSan.fromJson(document);
    dsDacSan.add(dacSan);
  }

  return dsDacSan;
}
