import 'package:app_dac_san/model/nguyen_lieu.dart';
import 'package:async_builder/async_builder.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../gui_helper.dart';

class TrangNguyenLieu extends StatefulWidget {
  TrangNguyenLieu({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tenController = TextEditingController();
  @override
  State<TrangNguyenLieu> createState() => _TrangNguyenLieuState();
}

class _TrangNguyenLieuState extends State<TrangNguyenLieu> {
  List<NguyenLieu> dsNguyenLieu = [];
  List<bool> selectedRowsIndex = [];
  late NguyenLieuDataTableSource dataTableSource;
  late Future myFuture;
  void taoBang() {
    dataTableSource = NguyenLieuDataTableSource(
      dsNguyenLieu: dsNguyenLieu,
      selectedRowIndexs: selectedRowsIndex,
    );
  }

  @override
  void initState() {
    myFuture = Future.delayed(const Duration(seconds: 1), () async {
      dsNguyenLieu = await NguyenLieu.doc();
      selectedRowsIndex = dsNguyenLieu.map((e) => false).toList();
      taoBang();
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
                            ? "Vui lòng nhập tên nguyên liệu"
                            : null,
                        decoration: roundInputDecoration(
                            "Tên nguyên liệu", "Nhập tên nguyên liệu"),
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
      NguyenLieu.them(widget.tenController.text).then((value) {
        if (value != null) {
          setState(() {
            dsNguyenLieu.add(value);
            selectedRowsIndex.add(false);
            taoBang();
          });
        } else {
          showNotify(context, "Thêm nguyên liệu thất bại");
        }
      });
    }
  }

  void capNhat(BuildContext context) {
    if (widget.formKey.currentState!.validate()) {
      if (selectedRowsIndex.where((element) => element).length == 1) {
        int i = selectedRowsIndex.indexOf(true);
        NguyenLieu nguyenLieu =
            NguyenLieu(id: dsNguyenLieu[i].id, ten: widget.tenController.text);
        NguyenLieu.capNhat(nguyenLieu).then((value) {
          if (value) {
            setState(() {
              dsNguyenLieu[i] = nguyenLieu;
              taoBang();
            });
          } else {
            showNotify(context, "Cập nhật nguyên liệu thất bại");
          }
        });
      }
    }
  }

  void xoa(BuildContext context) {
    if (widget.formKey.currentState!.validate()) {
      for (int i = 0; i < selectedRowsIndex.length; i++) {
        if (selectedRowsIndex[i]) {
          NguyenLieu.xoa(dsNguyenLieu[i].id).then((value) {
            if (value) {
              setState(() {
                dsNguyenLieu.remove(dsNguyenLieu[i]);
                selectedRowsIndex[i] = false;
                taoBang();
              });
            } else {
              showNotify(context, "Xóa nguyên liệu thất bại");
            }
          });
        }
      }
    }
  }
}

class NguyenLieuDataTableSource extends DataTableSource {
  List<NguyenLieu> dsNguyenLieu = [];
  List<bool> selectedRowIndexs = [];
  NguyenLieuDataTableSource({
    required this.dsNguyenLieu,
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
        DataCell(Text(dsNguyenLieu[index].id.toString())),
        DataCell(Text(dsNguyenLieu[index].ten)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dsNguyenLieu.length;

  @override
  int get selectedRowCount => 0;
}
