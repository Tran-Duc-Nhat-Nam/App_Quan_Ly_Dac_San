import 'package:app_dac_san/model/tinh_thanh.dart';
import 'package:async_builder/async_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../gui_helper.dart';

class TrangTinhThanh extends StatefulWidget {
  TrangTinhThanh({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tenController = TextEditingController();
  @override
  State<TrangTinhThanh> createState() => _TrangTinhThanhState();
}

class _TrangTinhThanhState extends State<TrangTinhThanh> {
  List<TinhThanh> dsTinhThanh = [];
  List<bool> selectedRowsIndex = [];
  late TinhThanhDataTableSource dataTableSource;
  late Future myFuture;
  void createTable() {
    dataTableSource = TinhThanhDataTableSource(
      dsTinhThanh: dsTinhThanh,
      selectedRowIndexs: selectedRowsIndex,
    );
  }

  @override
  void initState() {
    myFuture = Future.delayed(const Duration(seconds: 1), () async {
      dsTinhThanh = await TinhThanh.doc();
      selectedRowsIndex = dsTinhThanh.map((e) => false).toList();
      createTable();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: AsyncBuilder(
        future: myFuture,
        waiting: (context) => loadingCircle(),
        builder: (context, value) => Column(
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
                  source: dataTableSource,
                ),
              ),
            ),
            Form(
              key: widget.formKey,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: widget.tenController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập tên tỉnh thành";
                          } else {
                            return null;
                          }
                        },
                        decoration: roundInputDecoration(
                            "Tên vùng miền", "Nhập tên vùng miền"),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              style: roundButtonStyle(),
                              onPressed: () => them(context),
                              child: const Text("Thêm"),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              style: roundButtonStyle(),
                              onPressed: () => capNhat(context),
                              child: const Text("Cập nhật"),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: FilledButton(
                              style: roundButtonStyle(),
                              onPressed: () => xoa(context),
                              child: const Text("Xóa"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        error: (context, error, stackTrace) =>
            Center(child: Text('Error: $error')),
      ),
    );
  }

  void them(BuildContext context) {
    if (widget.formKey.currentState!.validate()) {
      TinhThanh.them(widget.tenController.text).then(
        (value) {
          if (value != null) {
            setState(() {
              dsTinhThanh.add(value);
              selectedRowsIndex.add(false);
              createTable();
            });
          } else {
            showNotify(context, "Thêm vùng miền thất bại");
          }
        },
      );
    }
  }

  void capNhat(BuildContext context) {
    if (widget.formKey.currentState!.validate()) {
      if (selectedRowsIndex.where((element) => element).length == 1) {
        int i = selectedRowsIndex.indexOf(true);
        TinhThanh tinhThanh =
            TinhThanh(id: dsTinhThanh[i].id, ten: widget.tenController.text);
        TinhThanh.capNhat(tinhThanh).then(
          (value) {
            if (value) {
              setState(() {
                dsTinhThanh[i] = tinhThanh;
                createTable();
              });
            } else {
              showNotify(context, "Cập nhật vùng miền thất bại");
            }
          },
        );
      }
    }
  }

  void xoa(BuildContext context) {
    if (widget.formKey.currentState!.validate()) {
      for (int i = 0; i < selectedRowsIndex.length; i++) {
        if (selectedRowsIndex[i]) {
          TinhThanh.xoa(dsTinhThanh[i].id).then(
            (value) {
              if (value) {
                setState(() {
                  dsTinhThanh.remove(dsTinhThanh[i]);
                  selectedRowsIndex[i] = false;
                  createTable();
                });
              } else {
                showNotify(context, "Xóa vùng miền thất bại");
              }
            },
          );
        }
      }
    }
  }
}

class TinhThanhDataTableSource extends DataTableSource {
  List<TinhThanh> dsTinhThanh = [];
  List<bool> selectedRowIndexs = [];
  TinhThanhDataTableSource({
    required this.dsTinhThanh,
    required this.selectedRowIndexs,
  });
  @override
  DataRow? getRow(int index) {
    // TODO: implement getRow
    return DataRow2(
      onSelectChanged: (value) {
        selectedRowIndexs[index] = value!;
        notifyListeners();
      },
      selected: selectedRowIndexs[index],
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
