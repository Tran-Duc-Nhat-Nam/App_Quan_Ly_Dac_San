import 'dart:convert';

import 'package:app_dac_san/model/tinh_thanh.dart';
import 'package:async_builder/async_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class TrangTinhThanh extends StatefulWidget {
  const TrangTinhThanh({super.key});

  @override
  State<TrangTinhThanh> createState() => _TrangTinhThanhState();
}

class _TrangTinhThanhState extends State<TrangTinhThanh> {
  List<TinhThanh> dsTinhThanh = [];
  late Future myFuture;
  @override
  void initState() {
    // TODO: implement initState
    myFuture = Future.delayed(const Duration(seconds: 1), () async {
      dsTinhThanh = await docTinhThanh();
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
                    ),
                    DataColumn(
                      label: Text('Tên'),
                    ),
                  ],
                  source: TinhThanhDataTableSource(dsTinhThanh: dsTinhThanh),
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

class TinhThanhDataTableSource extends DataTableSource {
  List<TinhThanh> dsTinhThanh = [];
  TinhThanhDataTableSource({required this.dsTinhThanh});
  @override
  DataRow? getRow(int index) {
    // TODO: implement getRow
    return DataRow2(
      cells: [
        DataCell(Text(dsTinhThanh[index].id.toString())),
        DataCell(Text(dsTinhThanh[index].ten)),
      ],
    );
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => dsTinhThanh.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}

Future<List<TinhThanh>> docTinhThanh() async {
  List<TinhThanh> dsTinhThanh = [];

  var reponse = await get(
    Uri.parse('http://localhost:8080/tinhthanh'),
    headers: {"Access-Control-Allow-Origin": "*"},
  );
  var result = json.decode(utf8.decode(reponse.bodyBytes));

  for (var document in result) {
    TinhThanh tinhThanh = TinhThanh.fromJson(document);
    dsTinhThanh.add(tinhThanh);
  }

  return dsTinhThanh;
}
