import 'package:app_dac_san/model/vung_mien.dart';
import 'package:async_builder/async_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../gui_helper.dart';

class TrangVungMien extends StatefulWidget {
  TrangVungMien({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tenController = TextEditingController();
  @override
  State<TrangVungMien> createState() => _TrangVungMienState();
}

class _TrangVungMienState extends State<TrangVungMien> {
  List<VungMien> dsVungMien = [];
  List<bool> selectedRowsIndex = [];
  late VungMienDataTableSource dataTableSource;
  late Future myFuture;
  void createTable() {
    dataTableSource = VungMienDataTableSource(
      dsVungMien: dsVungMien,
      selectedRowIndexs: selectedRowsIndex,
    );
  }

  @override
  void initState() {
    myFuture = Future.delayed(const Duration(seconds: 1), () async {
      dsVungMien = await VungMien.doc();
      selectedRowsIndex = dsVungMien.map((e) => false).toList();
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
                        validator: (value) => value == null || value.isEmpty
                            ? "Vui lòng nhập tên vùng miền"
                            : "null",
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
      VungMien.them(widget.tenController.text).then(
        (value) {
          if (value != null) {
            setState(() {
              dsVungMien.add(value);
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
        VungMien vungMien =
            VungMien(id: dsVungMien[i].id, ten: widget.tenController.text);
        VungMien.capNhat(vungMien).then(
          (value) {
            if (value) {
              setState(() {
                dsVungMien[i] = vungMien;
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
          VungMien.xoa(dsVungMien[i].id).then(
            (value) {
              if (value) {
                setState(() {
                  dsVungMien.remove(dsVungMien[i]);
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

class VungMienDataTableSource extends DataTableSource {
  List<VungMien> dsVungMien = [];
  List<bool> selectedRowIndexs = [];
  VungMienDataTableSource({
    required this.dsVungMien,
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
        DataCell(Text(dsVungMien[index].id.toString())),
        DataCell(Text(dsVungMien[index].ten)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsVungMien.length;

  @override
  int get selectedRowCount => 0;
}
